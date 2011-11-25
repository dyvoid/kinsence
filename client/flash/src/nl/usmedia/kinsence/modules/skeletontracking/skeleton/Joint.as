package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public final class Joint
	{
        // ____________________________________________________________________________________________________
        // PROPERTIES

		public var id:uint;
        public var position:KinSenceVector;
        public var trackingState:uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

		public function Joint():void
		{

		}

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            id = object.ID;

            position = new KinSenceVector();
            position.fromObject( object.Position );

            trackingState = object.TrackingState;
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