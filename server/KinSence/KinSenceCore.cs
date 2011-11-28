using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinSence.Server;
using UsMedia.KinSence.Messages;
using UsMedia.KinSence.Modules;
using UsMedia.KinSence.Util;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using System.Reflection;
using System.Windows;
using System.IO;
using UsMedia.KinSence.Server.Tcp;

namespace UsMedia.KinSence
{
    class KinSenceCore : IKinSenceCore
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "Core";

        private Runtime nui;
        private IKinSenceServer server;

        private Dictionary<string, IKinSenceModule> activeModules;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public KinSenceCore()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public virtual IKinSenceModule RegisterModule( IKinSenceModule module )
        {
            if ( activeModules.ContainsKey( module.Name ) )
                return null;

            activeModules.Add( module.Name, module );

            module.Core = this;
            module.OnRegister();

            SendMessage( module.Name, "Registered", null );

            return module;
        }


        public virtual IKinSenceModule RemoveModule( string name )
        {
            if ( !activeModules.ContainsKey( name ) )
                return null;

            IKinSenceModule module = activeModules[ name ];

            activeModules.Remove( name );

            module.OnRemove();

            SendMessage( name, "Removed", null );

            return module;
        }


        public virtual IKinSenceModule RetrieveModule( string name )
        {
            if ( !activeModules.ContainsKey( name ) )
                return null;

            return activeModules[ name ];
        }


        public virtual void SetElevationAngle( int elevationAngle )
        {
            nui.NuiCamera.ElevationAngle = elevationAngle;
        }


        public virtual void SetTransformSmooth( bool isEnabled )
        {
            nui.SkeletonEngine.TransformSmooth = isEnabled;
        }


        public virtual void SetTransformSmoothParameters( TransformSmoothParameters smoothParameters )
        {
            nui.SkeletonEngine.SmoothParameters = smoothParameters;
        }


        public virtual void SendMessage( string target, string type, dynamic data )
        {
            if ( server.State == ServerState.Connected )
            {
                Message message = new Message { Type = target + "." + type, Data = data };
                server.SendMessage( message.ToJson() );
            }
        }


        public virtual void OnClientMessage( string type, dynamic data )
        {
            switch ( type )
            {
                case "RegisterModule":
                    string moduleName = data as string;

                    Assembly assembly;

                    try
                    {
                        assembly = Assembly.LoadFrom( moduleName + ".dll" );
                    }
                    catch ( Exception )
                    {
                        return;
                    }
                    
                    if ( assembly != null )
                    {
                        string className = "UsMedia.KinSence.Modules." + moduleName + "." + moduleName + "Module";
                        IKinSenceModule module = assembly.CreateInstance( className ) as IKinSenceModule;

                        if ( module != null )
                        {
                            RegisterModule( module );
                        }
                    }
                    break;

                case "RemoveModule":
                    RemoveModule( data as String );
                    break;

                case "SetElevationAngle":
                    SetElevationAngle( Convert.ToInt32( data ) );
                    break;

                case "SetTransformSmooth":
                    SetTransformSmooth( Convert.ToBoolean( data ) );
                    break;

                case "SetTransformSmoothParameters":
                    TransformSmoothParameters smoothParams = new TransformSmoothParameters();

                    smoothParams.Correction = (float) data.Correction;
                    smoothParams.JitterRadius = (float) data.JitterRadius;
                    smoothParams.MaxDeviationRadius = (float) data.MaxDeviationRadius;
                    smoothParams.Prediction = (float) data.Prediction;
                    smoothParams.Smoothing = (float) data.Smoothing;

                    SetTransformSmoothParameters( smoothParams );
                    break;
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private void init()
        {
            try
            {
                nui = Runtime.Kinects[ 0 ];
            }
            catch ( Exception )
            {
                System.Windows.MessageBox.Show( "Kinect device was not found. Please make sure the device is plugged in." );
                return;
            }

            try
            {
                nui.Initialize( RuntimeOptions.UseSkeletalTracking | RuntimeOptions.UseColor );
            }
            catch ( Exception )
            {
                System.Windows.MessageBox.Show( "Runtime initialization failed. Please make sure Kinect device is plugged in." );
                return;
            }

            try
            {
                nui.VideoStream.Open( ImageStreamType.Video, 2, ImageResolution.Resolution640x480, ImageType.Color );
            }
            catch ( Exception )
            {
                System.Windows.MessageBox.Show( "Failed to open stream. Please make sure to specify a supported image type and resolution." );
                return;
            }

            activeModules = new Dictionary<string, IKinSenceModule>();

            server = new TcpServer();
            server.DataReceived += new EventHandler<DataReceivedEventArgs>( server_DataReceived );
        }


        private void DeliverClientMessage( Message message )
        {
            string messageType = (String) message.Type;
            string[] messageTypeArr = messageType.Split( '.' );

            string target = messageTypeArr[ 0 ];
            string type = messageTypeArr[ 1 ];
            object data = message.Data;

            if ( target == NAME )
            {
                OnClientMessage( type, data );
            }
            else
            {
                IKinSenceModule module = RetrieveModule( messageTypeArr[ 0 ] );

                if ( module != null )
                {
                    module.OnClientMessage( messageTypeArr[ 1 ], data );
                }
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public Runtime Nui { get { return nui; } }
        public IKinSenceServer Server { get { return server; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void server_DataReceived( object sender, DataReceivedEventArgs e )
        {
            /*object messageObject = JsonConvert.DeserializeObject(e.Message);

            Message message = new Message();
           // message.Type = messageObject.Type as String;
           // message.Data = messageObject.Data as dynamic;

            DeliverClientMessage( message );*/

            DeliverClientMessage( JsonConvert.DeserializeObject<Message>( e.Message ) );
        }

    }

}
