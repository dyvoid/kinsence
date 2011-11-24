package nl.usmedia.kinsence
{
    import flash.events.ErrorEvent;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.utils.Dictionary;

    import nl.usmedia.kinsence.interfaces.IKinSenceCore;

    import nl.usmedia.kinsence.interfaces.IKinSenceModule;

    import nl.usmedia.kinsence.modules.events.KinSenceModuleEvent;
    import nl.usmedia.kinsence.transformsmooth.TransformSmoothParameters;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="connect", type="flash.events.Event")]
    [Event(name="close", type="flash.events.Event")]
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
    [Event(name="securityError", type="flash.events.SecurityErrorEvent")]
    
    public class KinSence extends EventDispatcher implements IKinSenceCore
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private const NAME:String = "Core";

        private var _socket     :Socket;
        private var _readBuffer :String = "";

        private var _modules    :Dictionary;

        private var _isConnected    :Boolean = false;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function KinSence()
        {
            _modules = new Dictionary();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function connect( ipAddress:String, port:uint ):void
        {
            _socket = new Socket();
            _socket.addEventListener( Event.CONNECT, socketConnectHandler );
            _socket.addEventListener( Event.CLOSE, socketCloseHandler );
            _socket.addEventListener( IOErrorEvent.IO_ERROR, socketErrorHandler );
            _socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, socketErrorHandler );
            _socket.addEventListener( ProgressEvent.SOCKET_DATA, socketDataHandler );
            _socket.connect( ipAddress, port );
        }


        public function registerModule( module:IKinSenceModule ):IKinSenceModule
        {
            _modules[ module.name ] = module;

            module.core = this;

//            sendMessage( NAME, "RegisterModule", module.name );

            return module;
        }


        public function removeModule( name:String ):IKinSenceModule
        {
            var module:IKinSenceModule = _modules[ name ];

            if ( module )
            {
                delete _modules[ name ];

//                sendMessage( NAME, "RemoveModule", name );
            }

            return module;
        }


        public function retrieveModule( name:String ):IKinSenceModule
        {
            return _modules[ name ];
        }


        public function sendMessage( target:String, type:String, data:* = null ):void
        {
            if ( !_socket.connected ) return;

            var message:Object = new Object();
            message.Type = target + "." + type;
            message.Data = data;

//            _socket.writeUTFBytes( example.fireball.JSON.stringify( message ) + "\r\n" );
            _socket.writeUTFBytes( JSON.stringify( message ) + "\r\n" );
            _socket.flush();
        }


        public function onServerMessage( type:String, data:* ):void
        {
            
        }


        public function setElevationAngle( elevationAngle:Number ):void
        {
            sendMessage( NAME, "SetElevationAngle", elevationAngle );
        }


        public function setTransformSmooth( isEnabled:Boolean ):void
        {
            sendMessage( NAME, "SetTransformSmooth", isEnabled );
        }


        public function setTransformSmoothParameters( smoothParameters: TransformSmoothParameters ):void
        {
            var smoothParametersObj:Object =
            {
                Correction: smoothParameters.correction,
                JitterRadius: smoothParameters.jitterRadius,
                MaxDeviationRadius: smoothParameters.maxDeviationRadius,
                Prediction: smoothParameters.prediction,
                Smoothing: smoothParameters.smoothing
            };

            sendMessage( NAME, "SetTransformSmoothParameters", smoothParametersObj );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function deliverMessage( message:Object ):void
        {
            var messageType:String = message.Type;
            var messageTypeArr:Array = messageType.split(".");

            var target:String = messageTypeArr[ 0 ];
            var type:String = messageTypeArr[ 1 ];
            var data:* = message.Data;

            if ( target == NAME )
            {
                onServerMessage( type, data )
            }
            else
            {
                var module:IKinSenceModule = retrieveModule( target );

                if ( module )
                {
                    /*
                    On behalf of the module, we are taking care of sending the registered/removed
                    events here. Otherwise it would need to happen in the module's onServerMessage,
                    onRegister or onRemoved methods, forcing every subclass to have to super these
                    methods.
                     */
                    switch( type )
                    {
                        case "Registered":
                            module.onRegister();
                            module.dispatchEvent( new KinSenceModuleEvent( KinSenceModuleEvent.REGISTERED ) );
                        break;

                        case "Removed":
                            module.onRemove();
                            module.dispatchEvent( new KinSenceModuleEvent( KinSenceModuleEvent.REMOVED ) );
                        break;
                    }

                    module.onServerMessage( type, data );
                }
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get isConnected():Boolean
        {
            return _socket.connected;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function socketConnectHandler( event:Event ):void
        {
            trace("Socket Connected");
            dispatchEvent( event.clone() );

            for each ( var module:IKinSenceModule in _modules )
            {
                sendMessage( NAME, "RegisterModule", module.name );
            }
        }


        private function socketCloseHandler( event:Event ):void
        {
            trace("Socket Closed");
            dispatchEvent( event.clone() );
        }


        private function socketErrorHandler( event:ErrorEvent ):void
        {
            trace("Socket Error: " + event.toString());
            dispatchEvent( event.clone() );
        }


        private function socketDataHandler(event:ProgressEvent): void
        {
            var response:String = _socket.readUTFBytes( _socket.bytesAvailable );
            var packets:Array = response.split( "\r\n" );

            packets[ 0 ] = _readBuffer + packets[ 0 ];

            for ( var i:int = 0; i < packets.length - 1; i++ )
            {
//                var message:Object = example.fireball.JSON.parse( packets[i] );
                var message:Object = JSON.parse( packets[i] );

                deliverMessage( message );
            }

            _readBuffer = packets[ packets.length - 1 ];
        }

    }

}