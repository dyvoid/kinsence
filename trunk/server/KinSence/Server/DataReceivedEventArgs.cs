using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinSence.Messages
{
    class DataReceivedEventArgs : EventArgs
    {
        public string Message { get; set; }
    }
}
