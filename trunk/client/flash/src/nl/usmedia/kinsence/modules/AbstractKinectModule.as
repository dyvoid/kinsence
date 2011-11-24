package nl.usmedia.kinsence.modules
{
    import flash.events.EventDispatcher;

    import nl.usmedia.kinsence.interfaces.IKinSenceCore;

    import nl.usmedia.kinsence.interfaces.IKinSenceModule;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="KinectModuleEvent::REGISTERED", type="nl.usmedia.kinsence.modules.events.KinSenceModuleEvent")]
    [Event(name="KinectModuleEvent::REMOVED", type="nl.usmedia.kinsence.modules.events.KinSenceModuleEvent")]

    public class AbstractKinectModule extends EventDispatcher implements IKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _name       :String;
        private var _core       :IKinSenceCore;
        
        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AbstractKinectModule( name:String )
        {
            _name = name;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function onRegister():void { }

        public function onRemove():void { }

        public function onServerMessage( type:String, data:* ):void { }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function sendMessage( type:String, data:* = null ):void
        {
            _core.sendMessage( _name, type, data );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get core():IKinSenceCore
        {
            return _core;
        }

        public function set core( value:IKinSenceCore ):void
        {
            _core = value;
        }
        

        public function get name():String
        {
            return _name;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}