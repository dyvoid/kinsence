package nl.usmedia.kinsence.modules.handtracking.hands
{
    /**
     * @author Pieter van de Sluis
     */
    public class HandData
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var trackingState:uint;

        public var ratioX:Number;
        public var ratioY:Number;
        public var ratioZ:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function HandData()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            trackingState = object.TrackingState;

            ratioX = object.RatioX;

            ratioY = object.RatioY;

            ratioZ = object.RatioZ;
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