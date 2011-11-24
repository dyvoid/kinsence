using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;

namespace UsMedia.KinSence.Modules.HandTracking
{
    class HandData
    {
        public JointTrackingState TrackingState;

        public double RatioX;
        public double RatioY;
        public double RatioZ;
    }
}
