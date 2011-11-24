package nl.usmedia.kinsence.modules.events
{

    import flash.events.Event;


    /**
     * Package:    nl.usmedia.kinsence.modules.events
     * Class:      KinectModuleEvent
     *
     * @author     pieter.van.de.sluis
     * @since      10/28/11
     */
    public class KinSenceModuleEvent extends Event
    {

        // EVENT TYPES
        public static const REGISTERED:String = "KinSenceModuleEvent::REGISTERED";
        public static const REMOVED:String = "KinSenceModuleEvent::REMOVED";

        // EVENT DATA


        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function KinSenceModuleEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( type, bubbles, cancelable );
        }


        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        public override function clone():Event
        {
            return new KinSenceModuleEvent( type, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString( "KinectModuleEvent", "type", "bubbles", "cancelable", "eventPhase" );
        }


        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S



    }
}