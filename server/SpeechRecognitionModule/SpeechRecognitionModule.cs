///////////////////////////////////////////////////////////////////////////////////
//
// Licensed under the MIT license
//
// Copyright (c) 2012 Pieter van de Sluis, Us Media
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// http://www.usmedia.nl
//
///////////////////////////////////////////////////////////////////////////////////

using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Kinect;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Speech.AudioFormat;
using Microsoft.Speech.Recognition;
using System.Threading;
using UsMedia.KinSence.Server;
using System.Globalization;
using System.Reflection;

namespace UsMedia.KinSence.Modules.SpeechRecognition
{
    public class SpeechRecognitionModule : AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "SpeechRecognition";

        private KinectSensor sensor;
        private SpeechRecognitionEngine speechEngine;

        private bool isActive = false;

        private List<String> phrases;
        private String activationPhrase;
        private String deactivationPhrase;

        private double activationConfidenceTreshold = 0.9;

        private CultureInfo recognizerCulture;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public SpeechRecognitionModule() : base( NAME )
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public override void OnRegister()
        {
            base.OnRegister();
            
            // Look through all sensors and start the first connected one.
            // This requires that a Kinect is connected at the time of app startup.
            // To make your app robust against plug/unplug, 
            // it is recommended to use KinectSensorChooser provided in Microsoft.Kinect.Toolkit
            foreach (var potentialSensor in KinectSensor.KinectSensors)
            {
                if (potentialSensor.Status == KinectStatus.Connected)
                {
                    this.sensor = potentialSensor;
                    break;
                }
            }

            if (null != this.sensor)
            {
                try
                {
                    // Start the sensor!
                    this.sensor.Start();
                }
                catch (IOException)
                {
                    // Some other application is streaming from the same Kinect sensor
                    this.sensor = null;
                }
            }

            if (this.sensor == null)
            {
                
                return;
            }

            RecognizerInfo ri = GetKinectRecognizer();

            if (ri != null)
            {
                this.speechEngine = new SpeechRecognitionEngine(ri.Id);
            }

            speechEngine.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>(sre_SpeechDetected);
            speechEngine.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>(sre_SpeechHypothesized);
            speechEngine.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>(sre_SpeechRecognized);
            speechEngine.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>(sre_SpeechRecognitionRejected);

            Start();
        }


        public override void OnRemove()
        {
            base.OnRemove();

            speechEngine.SpeechDetected -= sre_SpeechDetected;
            speechEngine.SpeechHypothesized -= sre_SpeechHypothesized;
            speechEngine.SpeechRecognized -= sre_SpeechRecognized;
            speechEngine.SpeechRecognitionRejected -= sre_SpeechRecognitionRejected;

            Stop();
        }


        public virtual void Start()
        {
            //var t = new Thread( InitEngine );
            //t.Start();
            InitEngine();
        }


        public virtual void Stop()
        {
            if ( speechEngine != null )
            {
                speechEngine.RecognizeAsyncCancel();
                speechEngine.RecognizeAsyncStop();
            }
        }


        public virtual void Configure( List<String> phrases, String activationPhrase = null, String deactivationPhrase = null )
        {
            this.phrases = phrases;
            this.activationPhrase = activationPhrase;
            this.deactivationPhrase = deactivationPhrase;

            if ( activationPhrase != null )
            {
                isActive = true;
                Deactivate();
            }
        }


        public override void OnClientMessage( string type, dynamic data )
        {
            switch ( type )
            {
                case "Configure":

                    List<String> newPhrases = new List<String>();
                    string newActivationPhrase = null;
                    string newDeactivationPhrase = null;

                    if ( data.Phrases != null )
                    {
                        ICollection<JToken> phrasesList = (ICollection<JToken>)data.Phrases;

                        foreach (string phrase in phrasesList)
                        {
                            newPhrases.Add( phrase );
                        }
                    }

                    if ( data.ActivationPhrase != null )
                    {
                        newActivationPhrase = (string) data.ActivationPhrase;
                    }

                    if ( data.DeactivationPhrase != null )
                    {
                        newDeactivationPhrase = (string) data.DeactivationPhrase;
                    }

                    Configure( newPhrases, newActivationPhrase, newDeactivationPhrase );
                    break;

                case "Activate":
                    Activate();
                    break;

                case "Deactivate":
                    Deactivate();
                    break;
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        /// <summary>
        /// Gets the metadata for the speech recognizer (acoustic model) most suitable to
        /// process audio from Kinect device.
        /// </summary>
        /// <returns>
        /// RecognizerInfo if found, <code>null</code> otherwise.
        /// </returns>
        private static RecognizerInfo GetKinectRecognizer()
        {
            foreach (RecognizerInfo recognizer in SpeechRecognitionEngine.InstalledRecognizers())
            {
                string value;
                recognizer.AdditionalInfo.TryGetValue("Kinect", out value);
                if ("True".Equals(value, StringComparison.OrdinalIgnoreCase) && "en-US".Equals(recognizer.Culture.Name, StringComparison.OrdinalIgnoreCase))
                {
                    return recognizer;
                }
            }

            return null;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void InitEngine()
        {
            KinectAudioSource kinectSource = sensor.AudioSource;
            kinectSource.EchoCancellationMode = EchoCancellationMode.None;
            kinectSource.AutomaticGainControlEnabled = false;
            var kinectStream = kinectSource.Start();
            speechEngine.SetInputToAudioStream(kinectStream, new SpeechAudioFormatInfo(
                                                  EncodingFormat.Pcm, 16000, 16, 1,
                                                  32000, 2, null ) );
            var gb = new GrammarBuilder();
            //gb.Culture = recognizerCulture;
            gb.Append( "Dummy" );
            speechEngine.LoadGrammar(new Grammar(gb));
            speechEngine.RecognizeAsync(RecognizeMode.Multiple);
            speechEngine.UnloadAllGrammars();
        }


        protected virtual void SendMessage( string type, string text, float confidence )
        {
            SpeechRecognitionResult result = new SpeechRecognitionResult();
            result.Text = text;
            result.Confidence = confidence;

            base.SendMessage( type, result );
        }

        protected virtual void Activate()
        {
            if (isActive)
                return;

            speechEngine.UnloadAllGrammars();

            Choices choices = new Choices();
            foreach (String phrase in phrases)
            {
                choices.Add(phrase);
            }

            if (deactivationPhrase != null)
            {
                choices.Add(deactivationPhrase);
            }

            //recognizerCulture = new CultureInfo("en_GB");

            var gb = new GrammarBuilder();
            //gb.Culture = recognizerCulture;
            gb.Append(choices);

            speechEngine.LoadGrammar(new Grammar(gb));

            isActive = true;

            SendMessage("Activated", null);
        }


        protected virtual void Deactivate()
        {
            if (!isActive)
                return;

            speechEngine.UnloadAllGrammars();

            if (activationPhrase != null)
            {
                var gb = new GrammarBuilder();
                //gb.Culture = recognizerCulture;
                gb.Append(activationPhrase);

                speechEngine.LoadGrammar(new Grammar(gb));
            }

            isActive = false;

            SendMessage("Deactivated", null);
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public bool IsActive { get { return isActive; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void sre_SpeechDetected( object sender, SpeechDetectedEventArgs e )
        {
            System.Diagnostics.Debug.WriteLine( "Speech Detected" );

            SendMessage( "SpeechDetected", null );
        }


        void sre_SpeechHypothesized( object sender, SpeechHypothesizedEventArgs e )
        {
            System.Diagnostics.Debug.WriteLine( "Speech Hypothesized: " + e.Result.Text + "::Confidence: " + e.Result.Confidence );

            SendMessage( "SpeechHypothesized", e.Result.Text, e.Result.Confidence );
        }


        void sre_SpeechRecognized( object sender, SpeechRecognizedEventArgs e )
        {
            System.Diagnostics.Debug.WriteLine( "Speech Recognized: " + e.Result.Text + "::Confidence: " + e.Result.Confidence );

            if ( e.Result.Confidence > activationConfidenceTreshold )
            {
                if ( e.Result.Text == activationPhrase )
                {
                    Activate();
                }
                else if ( e.Result.Text == deactivationPhrase )
                {
                    Deactivate();
                }
            }            

            SendMessage( "SpeechRecognized", e.Result.Text, e.Result.Confidence );
        }


        void sre_SpeechRecognitionRejected( object sender, SpeechRecognitionRejectedEventArgs e )
        {
            System.Diagnostics.Debug.WriteLine( "Speech Rejected: " + e.Result.Text + "::Confidence: " + e.Result.Confidence );

            SendMessage( "SpeechRecognitionRejected", e.Result.Text, e.Result.Confidence );
        }

    }

}
