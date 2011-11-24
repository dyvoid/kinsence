package nl.usmedia.kinsence.modules.speechrecognition
{
    /**
     * @author Pieter van de Sluis
     */
    public class SpeechRecognitionResult
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var text       :String;
        public var confidence :Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SpeechRecognitionResult()
        {
            
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            text = object.Text;
            confidence = object.Confidence;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}