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

        private const string RecognizerId = "SR_MS_en-US_Kinect_10.0";

        private KinectAudioSource kinectSource;
        private SpeechRecognitionEngine sre;

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

            RecognizerInfo ri = SpeechRecognitionEngine.InstalledRecognizers().Where( r => r.Id == RecognizerId ).FirstOrDefault();
            if ( ri == null )
                return;

            recognizerCulture = ri.Culture;

            sre = new SpeechRecognitionEngine( ri.Id );

            sre.SpeechDetected += new EventHandler<SpeechDetectedEventArgs>( sre_SpeechDetected );
            sre.SpeechHypothesized += new EventHandler<SpeechHypothesizedEventArgs>( sre_SpeechHypothesized );
            sre.SpeechRecognized += new EventHandler<SpeechRecognizedEventArgs>( sre_SpeechRecognized );
            sre.SpeechRecognitionRejected += new EventHandler<SpeechRecognitionRejectedEventArgs>( sre_SpeechRecognitionRejected );

            Start();
        }


        public override void OnRemove()
        {
            base.OnRemove();

            sre.SpeechDetected -= sre_SpeechDetected;
            sre.SpeechHypothesized -= sre_SpeechHypothesized;
            sre.SpeechRecognized -= sre_SpeechRecognized;
            sre.SpeechRecognitionRejected -= sre_SpeechRecognitionRejected;

            Stop();
        }


        public virtual void Start()
        {
            var t = new Thread( InitEngine );
            t.Start();
        }


        public virtual void Stop()
        {
            if ( sre != null )
            {
                sre.RecognizeAsyncCancel();
                sre.RecognizeAsyncStop();
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

        protected virtual void Activate()
        {
            if ( isActive )
                return;

            sre.UnloadAllGrammars();

            Choices choices = new Choices();
            foreach ( String phrase in phrases )
            {
                choices.Add( phrase );
            }
            
            if ( deactivationPhrase != null )
            {
                choices.Add( deactivationPhrase );
            }

            var gb = new GrammarBuilder();
            gb.Culture = recognizerCulture;
            gb.Append( choices );

            sre.LoadGrammar( new Grammar( gb ) );

            isActive = true;

            SendMessage( "Activated", null );
        }


        protected virtual void Deactivate()
        {
            if ( !isActive )
                return;

            sre.UnloadAllGrammars();

            if ( activationPhrase != null )
            {
                var gb = new GrammarBuilder();
                gb.Culture = recognizerCulture;
                gb.Append( activationPhrase );

                sre.LoadGrammar( new Grammar( gb ) );
            }

            isActive = false;

            SendMessage( "Deactivated", null );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void InitEngine()
        {
            kinectSource = new KinectAudioSource();
            kinectSource.EchoCancellationMode = EchoCancellationMode.None;
            kinectSource.AutomaticGainControlEnabled = false;
            var kinectStream = kinectSource.Start();
            sre.SetInputToAudioStream( kinectStream, new SpeechAudioFormatInfo(
                                                  EncodingFormat.Pcm, 16000, 16, 1,
                                                  32000, 2, null ) );
            var gb = new GrammarBuilder();
            gb.Culture = recognizerCulture;
            gb.Append( "Dummy" );
            sre.LoadGrammar( new Grammar( gb ) );
            sre.RecognizeAsync( RecognizeMode.Multiple );
            sre.UnloadAllGrammars();
        }


        protected virtual void SendMessage( string type, string text, float confidence )
        {
            SpeechRecognitionResult result = new SpeechRecognitionResult();
            result.Text = text;
            result.Confidence = confidence;

            base.SendMessage( type, result );
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
