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
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinSence.Server;

namespace UsMedia.KinSence.Modules.SkeletonTracking
{
    public class SkeletonTrackingModule : AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "SkeletonTracking";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public SkeletonTrackingModule() : base( NAME )
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public override void OnRegister()
        {
            base.OnRegister();

            Nui.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>( nui_SkeletonFrameReady );
        }

        public override void OnRemove()
        {
            base.OnRemove();

            Nui.SkeletonFrameReady -= nui_SkeletonFrameReady;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void nui_SkeletonFrameReady( object sender, SkeletonFrameReadyEventArgs e )
        {
            List<SkeletonData> skeletonsList = new List<SkeletonData>();
            
            // Collect only skeletons that are being tracked, so we make sure we are not sending unnecessary data
            foreach ( SkeletonData skeletonData in e.SkeletonFrame.Skeletons )
            {
                if ( skeletonData.TrackingState != SkeletonTrackingState.NotTracked )
                {
                    skeletonsList.Add( skeletonData );
                }
            }

            if ( skeletonsList.Count > 0 )
            {
                // We have to make a pseudo copy of the SkeletonFrame, since we cannot change
                // the Skeletons array and we cannot instantiate a new SkeletonFrame ourselves 
                // (it does not have a constructor).
                KinSenceSkeletonFrame skeletonFrame = new KinSenceSkeletonFrame();
                skeletonFrame.FloorClipPlane = e.SkeletonFrame.FloorClipPlane;
                skeletonFrame.FrameNumber = e.SkeletonFrame.FrameNumber;
                skeletonFrame.NormalToGravity = e.SkeletonFrame.NormalToGravity;
                skeletonFrame.Quality = e.SkeletonFrame.Quality;
                skeletonFrame.Skeletons = skeletonsList;
                skeletonFrame.TimeStamp = e.SkeletonFrame.TimeStamp;

                SendMessage( "SkeletonTrackingUpdate", skeletonFrame );
            }            
        }
    }
}
