using System;
using System.Text;
using System.Net.Sockets;
using System.Threading;
using System.Net;
using UsMedia.KinSence.Messages;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace UsMedia.KinSence.Server
{
    class TcpServer
    {

        // ____________________________________________________________________________________________________
        // PROPERTIES

        private TcpListener tcpListener;
        private Thread listenThread;
        private TcpClient tcpClient;
        private NetworkStream clientStream;
        private String readBuffer = "";
        private TcpServerState state = TcpServerState.Stopped;

        public event EventHandler<StateChangedEventArgs> StateChanged;
        public event EventHandler<DataReceivedEventArgs> DataReceived;
        public event EventHandler ClientConnected;
        public event EventHandler ClientDisconnected;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public TcpServer()
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public void Start(IPAddress ipAddress, int port)
        {
            if ( listenThread != null )
            {
                listenThread.Abort();
                tcpListener.Stop();
            }

            tcpListener = new TcpListener(ipAddress, port);
            listenThread = new Thread( new ThreadStart( ListenForClients ) );
            listenThread.Start();

            SetState( TcpServerState.Waiting );

            System.Diagnostics.Debug.WriteLine( "Server started" );
        }


        public virtual void Stop()
        {
            listenThread.Abort();
            tcpListener.Stop();

            SetState( TcpServerState.Stopped );

            System.Diagnostics.Debug.WriteLine( "Server stopped" );
        }


        public virtual void SendMessage( string message )
        {
            if ( state == TcpServerState.Connected && clientStream.CanWrite && tcpClient.Connected )
            {
                message += "\r\n";

                ASCIIEncoding encoder = new ASCIIEncoding();
                byte[] buffer = encoder.GetBytes( message );

                try
                {
                    clientStream.Write( buffer, 0, buffer.Length );
                    clientStream.Flush();
                }
                catch ( InvalidOperationException )
                {
                    System.Diagnostics.Debug.WriteLine( "Message send attempt failed" );
                }
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private void ListenForClients()
        {
            tcpListener.Start();

            while ( true )
            {
                //blocks until a client has connected to the server
                TcpClient client = tcpListener.AcceptTcpClient();

                //create a thread to handle communication 
                //with connected client
                Thread clientThread = new Thread( new ParameterizedThreadStart( HandleClientCommunication ) );
                clientThread.Start( client );
            }
        }


        private void HandleClientCommunication( object client )
        {
            tcpClient = (TcpClient)client;
            clientStream = tcpClient.GetStream();

            System.Diagnostics.Debug.WriteLine( "Client connected:" + tcpClient );
            OnClientConnected();

            byte[] message = new byte[ 4096 ];
            int bytesRead;

            SetState( TcpServerState.Connected );

            while ( true )
            {
                bytesRead = 0;

                try
                {
                    //blocks until a client sends a message
                    bytesRead = clientStream.Read( message, 0, 4096 );
                }
                catch
                {
                    //a socket error has occured
                    break;
                }

                if ( bytesRead == 0 )
                {
                    //the client has disconnected from the server
                    break;
                }

                //message has successfully been received
                ASCIIEncoding encoder = new ASCIIEncoding();
                String data = encoder.GetString( message, 0, bytesRead );
                OnDataReceived( data );
            }

            tcpClient.Close();
            clientStream.Close();
            tcpListener.Start();
            OnClientDisconnected();

            SetState( TcpServerState.Waiting );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void OnClientConnected()
        {
            EventHandler handler = ClientConnected;

            if ( handler != null )
            {
                handler( this, EventArgs.Empty );
            }
        }


        protected virtual void OnClientDisconnected()
        {
            EventHandler handler = ClientDisconnected;

            if ( handler != null )
            {
                handler( this, EventArgs.Empty );
            }
        }


        protected virtual void OnDataReceived( string data )
        {
            string[] packets = Regex.Split( data, "\r\n" );

            packets[ 0 ] = readBuffer + packets[ 0 ];

            for ( int i = 0; i < packets.Length - 1; i++ )
            {
                EventHandler<DataReceivedEventArgs> handler = DataReceived;

                if ( handler != null )
                {
                    var args = new DataReceivedEventArgs() { Message = packets[ i ] };
                    handler( this, args );
                }
            }

            readBuffer = packets[ packets.Length - 1 ];
        }


        protected virtual void OnStateChanged()
        {
            EventHandler<StateChangedEventArgs> handler = StateChanged;

            if ( handler != null )
            {
                var args = new StateChangedEventArgs() { State = state };
                handler( this, args );
            }
        }


        protected void SetState( TcpServerState state )
        {
            if ( this.state == state )
                return;

            this.state = state;
            OnStateChanged();
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public TcpServerState State { get { return state; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS        


    }

}