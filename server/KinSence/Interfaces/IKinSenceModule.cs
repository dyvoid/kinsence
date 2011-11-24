using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinSence.Interfaces
{
    public interface IKinSenceModule : IClientMessageHandler
    {
        void OnRegister();
        void OnRemove();

        IKinSenceCore Core { get; set; }

        String Name { get; }

    }
}
