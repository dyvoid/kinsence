package nl.usmedia.kinsence.interfaces
{
    import flash.events.IEventDispatcher;


    /**
     * @author Pieter van de Sluis
     */
    public interface IKinSenceModule extends IServerMessageHandler, IEventDispatcher
    {
        function onRegister():void
        function onRemove():void

        function get core():IKinSenceCore
        function set core( value:IKinSenceCore ):void

        function get name():String
    }
}
