package nl.usmedia.kinsence.modules.speechrecognition
{
    import nl.usmedia.kinsence.modules.AbstractKinectModule;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="SpeechRecognitionEvent::ACTIVATED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::DEACTIVATED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_DETECTED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_HYPOTHIZED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_RECOGNIZED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]
    [Event(name="SpeechRecognitionEvent::SPEECH_RECOGNITION_REJECTED", type="nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent")]

    public class SpeechRecognitionModule extends AbstractKinectModule
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