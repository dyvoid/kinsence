package nl.usmedia.kinsence.modules.handtracking.hands
{


    /**
     * @author Pieter van de Sluis
     */
    public class Hands
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var skeletonTrackingID:int;
        public var skeletonUserIndex:int;

        public var left:HandData;
        public var right:HandData;

        public var distanceRatio:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Hands()
        {
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            skeletonTrackingID = object.TrackingState;

            skeletonUserIndex = object.SkeletonUserIndex;

            left = new HandData();
            left.fromObject( object.Left );

            right = new HandData();
            right.fromObject( object.Right );

            distanceRatio = object.DistanceRatio;
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