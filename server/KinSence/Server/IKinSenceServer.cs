using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;

namespace UsMedia.KinSence.Server
{
    interface IKinSenceServer
    {
        event EventHandler<StateChangedEventArgs> StateChanged;
        event EventHandler<DataReceivedEventArgs> DataReceived;
        event EventHandler ClientConnected;
        event EventHandler ClientDisconnected;

        void Start( IPAddress ipAddress, int port );
        void Stop();

        void SendMessage( string message );

        ServerState State { get; }
    }
}
