package nl.usmedia.kinsence.interfaces
{
    /**
     * @author Pieter van de Sluis
     */
    public interface IKinSenceCore extends IServerMessageHandler
    {
        function registerModule( module:IKinSenceModule ):IKinSenceModule
        function removeModule( name:String ):IKinSenceModule
        function retrieveModule( name:String ):IKinSenceModule

        function sendMessage( target:String, type:String, data:* = null ):void
    }
}
