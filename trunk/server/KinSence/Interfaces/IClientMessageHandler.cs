using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UsMedia.KinSence.Messages;

namespace UsMedia.KinSence.Interfaces
{
    public interface IClientMessageHandler
    {
        void OnClientMessage( string type, dynamic data );
    }
}
