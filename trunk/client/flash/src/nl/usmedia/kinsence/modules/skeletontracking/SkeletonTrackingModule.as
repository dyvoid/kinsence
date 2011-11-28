package nl.usmedia.kinsence.modules.skeletontracking
{
    import nl.usmedia.kinsence.modules.*;
    import nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingEvent;

    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonFrame;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="SkeletonTrackingEvent::SKELETON_TRACKING_UPDATE", type="nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingEvent")]

    public class SkeletonTrackingModule extends AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "SkeletonTracking";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SkeletonTrackingModule()
        {
            super( NAME );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED

        override public function onServerMessage( type:String, data:* ):void
        {
            switch( type )
            {
                case "SkeletonTrackingUpdate":
                    var skeletonFrame:SkeletonFrame = new SkeletonFrame();
                    skeletonFrame.fromObject( data );

                    dispatchEvent( new SkeletonTrackingEvent( SkeletonTrackingEvent.SKELETON_TRACKING_UPDATE, skeletonFrame ) );
                break;
            }
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}