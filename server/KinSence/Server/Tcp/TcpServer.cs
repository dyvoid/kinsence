﻿///////////////////////////////////////////////////////////////////////////////////
//
// Licensed under the MIT license
//
// Copyright (c) 2012 Pieter van de Sluis, Us Media
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// http://www.usmedia.nl
//
///////////////////////////////////////////////////////////////////////////////////


using System;
using System.Text;
using System.Net.Sockets;
using System.Threading;
using System.Net;
using UsMedia.KinSence.Messages;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace UsMedia.KinSence.Server.Tcp
{
    // Code is largely based on this example:
    // http://www.switchonthecode.com/tutorials/csharp-tutorial-simple-threaded-tcp-server

    class TcpServer : IKinSenceServer
    {

        // ____________________________________________________________________________________________________
        // PROPERTIES

        private TcpListener tcpListener;
        private Thread listenThread;
        private TcpClient tcpClient;
        private NetworkStream clientStream;
        private String readBuffer = "";
        private ServerState state = ServerState.Stopped;

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

        public virtual void Start( IPAddress ipAddress, int port )
        {
            if ( listenThread != null )
            {
                listenThread.Abort();
                tcpListener.Stop();
            }

            SetState( ServerState.Waiting );

            tcpListener = new TcpListener(ipAddress, port);
            listenThread = new Thread( new ThreadStart( ListenForClients ) );
            listenThread.Start();            

            System.Diagnostics.Debug.WriteLine( "Server started" );
        }


        public virtual void Stop()
        {
            listenThread.Abort();
            tcpListener.Stop();

            SetState( ServerState.Stopped );

            System.Diagnostics.Debug.WriteLine( "Server stopped" );
        }


        public virtual void SendMessage( string message )
        {
            if ( state == ServerState.Connected && clientStream.CanWrite && tcpClient.Connected )
            {
                message += "\r\n";

                ASCIIEncoding encoder = new ASCIIEncoding();
                byte[] buffer = encoder.GetBytes( message );

                try
                {
                    clientStream.Write( buffer, 0, buffer.Length );
                    clientStream.Flush();
                }
                catch
                {
                    System.Diagnostics.Debug.WriteLine( "Message send attempt failed" );
                }
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private void ListenForClients()
        {
            try
            {
                tcpListener.Start();
            }
            catch
            {
                System.Windows.MessageBox.Show( "Unable to set up server on this IP address" );
                Stop();
                return;
            }
            

            while ( true )
            {
                //blocks until a client has connected to the server
                TcpClient client = tcpListener.AcceptTcpClient();

                System.Diagnostics.Debug.WriteLine( "Client connected:" + client );
                OnClientConnected();

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

            byte[] message = new byte[ 4096 ];
            int bytesRead;

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

            System.Diagnostics.Debug.WriteLine( "Client disconnected" );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void OnClientConnected()
        {
            SetState( ServerState.Connected );

            EventHandler handler = ClientConnected;

            if ( handler != null )
            {
                handler( this, EventArgs.Empty );
            }
        }


        protected virtual void OnClientDisconnected()
        {
            SetState( ServerState.Waiting );

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


        protected void SetState( ServerState state )
        {
            if ( this.state == state )
                return;

            this.state = state;
            OnStateChanged();
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public ServerState State { get { return state; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS        


    }

}