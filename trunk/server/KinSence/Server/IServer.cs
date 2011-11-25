using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;

namespace UsMedia.KinSence.Server
{
    interface IServer
    {
        void Start( IPAddress ipAddress, int port );
        void Stop();

        void SendMessage( string message );

        ServerState State { get; }
    }
}
