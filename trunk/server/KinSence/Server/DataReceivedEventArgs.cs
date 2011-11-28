using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinSence.Server
{
    class DataReceivedEventArgs : EventArgs
    {
        public string Message { get; set; }
    }
}
