using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinSence.Modules;

namespace UsMedia.KinSence
{
    public interface IKinSenceCore : IClientMessageHandler
    {
        IKinSenceModule RegisterModule( IKinSenceModule module );
        IKinSenceModule RemoveModule( string name );
        IKinSenceModule RetrieveModule( string name );

        void SendMessage( string target, string type, dynamic data );

        Runtime Nui { get; }
    }
}
