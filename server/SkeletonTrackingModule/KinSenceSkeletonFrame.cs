using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;

namespace UsMedia.KinSence.Modules.SkeletonTracking
{
    class KinSenceSkeletonFrame
    {
        public Vector FloorClipPlane;
        public int FrameNumber;
        public Vector NormalToGravity;
        public SkeletonFrameQuality Quality;
        public List<SkeletonData> Skeletons;
        public long TimeStamp;
    }
}
