/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2012 Pieter van de Sluis, Us Media
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://www.usmedia.nl
 */

package nl.usmedia.kinsence.modules.speechrecognition
{
    import nl.usmedia.kinsence.modules.AbstractKinSenceModule;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="SpeechRecognitionEvent::ACTIVATED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::DEACTIVATED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_DETECTED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_HYPOTHIZED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_RECOGNIZED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_RECOGNITION_REJECTED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]

    public class SpeechRecognitionModule extends AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "SpeechRecognition";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SpeechRecognitionModule()
        {
            super( NAME );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function configure( phrases:Array, activationPhrase:String = null, deactivationPhrase:String = null ):void
        {
            var message:Object = new Object();
            message.Phrases = phrases;
            if ( activationPhrase ) message.ActivationPhrase = activationPhrase;
            if ( deactivationPhrase ) message.DeactivationPhrase = deactivationPhrase;

            sendMessage( "Configure", message );
        }


        public function activate():void
        {
            sendMessage( "Activate" );
        }


        public function deactivate():void
        {
            sendMessage( "Deactivate" );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED

        override public function onServerMessage( type:String, data:* ):void
        {
            var result:SpeechRecognitionResult;

            if ( data )
            {
                result = new SpeechRecognitionResult();
                result.fromObject( data );
            }

            var eventType:String;

            switch( type )
            {
                case "Activated":
                    eventType = SpeechRecognitionEvent.ACTIVATED;
                break;

                case "Deactivated":
                    eventType = SpeechRecognitionEvent.DEACTIVATED;
                break;

                case "SpeechDetected":
                    eventType = SpeechRecognitionEvent.SPEECH_DETECTED;
                break;

                case "SpeechHypothized":
                    eventType = SpeechRecognitionEvent.SPEECH_HYPOTHIZED;
                break;

                case "SpeechRecognized":
                    eventType = SpeechRecognitionEvent.SPEECH_RECOGNIZED;
                break;

                case "SpeechRecognitionRejected":
                    eventType = SpeechRecognitionEvent.SPEECH_RECOGNITION_REJECTED;
                break;

                default:
                return;
            }

            dispatchEvent( new SpeechRecognitionEvent( eventType, result ) );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}