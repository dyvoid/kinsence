///////////////////////////////////////////////////////////////////////////////////
//
// Licensed under the MIT license
//
// Copyright (c) 2012 Pieter van de Sluis, Us Media
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// http://www.usmedia.nl
//
///////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Kinect;
using UsMedia.KinSence.Server;

namespace UsMedia.KinSence.Modules.SkeletonTracking
{
    public class SkeletonTrackingModule : AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "SkeletonTracking";
		
		private KinectSensor sensor;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public SkeletonTrackingModule() : base( NAME )
        {
			sensor = KinectSensor.KinectSensors[0];
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public override void OnRegister()
        {
            base.OnRegister();

            sensor.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>( sensor_SkeletonFrameReady );
        }

        public override void OnRemove()
        {
            base.OnRemove();

			sensor.SkeletonFrameReady -= sensor_SkeletonFrameReady;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void sensor_SkeletonFrameReady( object sender, SkeletonFrameReadyEventArgs e )
        {
            Skeleton[] skeletons = new Skeleton[0];

            // We have to make a pseudo copy of the SkeletonFrame, since we cannot change
            // the Skeletons array 
            KinSenceSkeletonFrame kinSenceSkeletonFrame = new KinSenceSkeletonFrame();

            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null)
                {
                    if (skeletonFrame.SkeletonArrayLength == 0)
                        return;

                    skeletons = new Skeleton[skeletonFrame.SkeletonArrayLength];
                    skeletonFrame.CopySkeletonDataTo(skeletons);
                    
                    kinSenceSkeletonFrame.FloorClipPlane = skeletonFrame.FloorClipPlane;
                    kinSenceSkeletonFrame.FrameNumber = skeletonFrame.FrameNumber;                   
                    kinSenceSkeletonFrame.Timestamp = skeletonFrame.Timestamp;
                }
            }

            List<Skeleton> trackedSkeletons = new List<Skeleton>();

            // Collect only skeletons that are being tracked, so we make sure we are not sending unnecessary data
            foreach (Skeleton skeleton in skeletons)
            {
                if (skeleton.TrackingState != SkeletonTrackingState.NotTracked)
                {
                    trackedSkeletons.Add(skeleton);
                }
            }
            
            if (trackedSkeletons.Count > 0)
            {
                kinSenceSkeletonFrame.Skeletons = trackedSkeletons;

                SendMessage("SkeletonTrackingUpdate", kinSenceSkeletonFrame);
            }
        }
    }
}
