using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;

namespace UsMedia.KinSence.Messages
{
    class Message
    {
        public string Type { get; set; }
        public dynamic Data { get; set; }

        public string ToJson()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
