package nl.usmedia.kinsence.modules.handtracking
{
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent;

    import nl.usmedia.kinsence.modules.AbstractKinectModule;
    import nl.usmedia.kinsence.modules.handtracking.hands.Hands;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.KinSenceVector;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="HandTrackingEvent::HAND_TRACKING_UPDATE", type="nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent")]

    public class HandTrackingModule extends AbstractKinectModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "HandTracking";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function HandTrackingModule()
        {
            super( NAME );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function onServerMessage( type:String, data:* ):void
        {
            switch( type )
            {
                case "HandTrackingUpdate":
                    var handSets:Array = data;

                    var arr:Array = [];

                    for each ( var handsObject:Object in handSets )
                    {
                        var hands:Hands = new Hands();
                        hands.fromObject( handsObject );
                        arr.push( hands );
                    }

                    dispatchEvent( new HandTrackingEvent( HandTrackingEvent.HAND_TRACKING_UPDATE, arr ) );
                break;
            }
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