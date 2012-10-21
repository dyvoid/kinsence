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
using UsMedia.KinSence.Util;

namespace UsMedia.KinSence.Modules.HandTracking
{
    public class HandTrackingModule : AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "HandTracking";

        private KinectSensor sensor;

        private double armLength = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public HandTrackingModule() : base( NAME )
        {
            sensor = KinectSensor.KinectSensors[0];
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public override void OnRegister()
        {
            base.OnRegister();

            sensor.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(nui_SkeletonFrameReady);
        }


        public override void OnRemove()
        {
            base.OnRemove();

            sensor.SkeletonFrameReady -= nui_SkeletonFrameReady;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void processSkeletons( Skeleton[] skeletons )
        {
            List<Hands> handsCollection = new List<Hands>();

            foreach ( Skeleton data in skeletons )
            {
                if ( data.TrackingState == SkeletonTrackingState.Tracked )
                {
                    Hands hands = new Hands();
                    hands.SkeletonTrackingID = data.TrackingId;

                    hands.Left = CreateHandData( data.Joints[ JointType.ShoulderLeft ],
                        data.Joints[JointType.ElbowLeft],
                        data.Joints[JointType.HandLeft]);
                    hands.Left.TrackingState = data.Joints[JointType.HandLeft].TrackingState;

                    hands.Right = CreateHandData(data.Joints[JointType.ShoulderRight],
                        data.Joints[JointType.ElbowRight],
                        data.Joints[JointType.HandRight]);
                    hands.Right.TrackingState = data.Joints[JointType.HandRight].TrackingState;

                    double maxHandsDistance = armLength * 2 + CalcSkeletonPointDistance(data.Joints[JointType.ShoulderLeft].Position, data.Joints[JointType.ShoulderRight].Position);
                    double handsDistance = CalcSkeletonPointDistance(data.Joints[JointType.HandLeft].Position, data.Joints[JointType.HandRight].Position);
                    hands.DistanceRatio = handsDistance / maxHandsDistance;
                    if (hands.DistanceRatio > 1)
                        hands.DistanceRatio = 1;

                    handsCollection.Add( hands );
                }
            }

            if ( handsCollection.Count > 0 )
            {
                SendMessage( "HandTrackingUpdate", handsCollection );
            }
        }


        protected HandData CreateHandData( Joint shoulderJoint, Joint elbowJoint, Joint handJoint )
        {
            HandData handData = new HandData();

            if ( shoulderJoint.TrackingState != JointTrackingState.NotTracked &&
                 elbowJoint.TrackingState != JointTrackingState.NotTracked &&
                 handJoint.TrackingState != JointTrackingState.NotTracked )
            {
                armLength = 0;
                armLength += Math.Abs( CalcSkeletonPointDistance( shoulderJoint.Position, elbowJoint.Position ) );
                armLength += Math.Abs( CalcSkeletonPointDistance( elbowJoint.Position, handJoint.Position ) );
            }

            Range xRange = new Range( 0.8 * -armLength, armLength );
            Range yRange = new Range( armLength, -armLength );
            Range zRange = new Range( 0.1, armLength );

            double dx = handJoint.Position.X - shoulderJoint.Position.X;
            double dy = handJoint.Position.Y - shoulderJoint.Position.Y;
            double dz = shoulderJoint.Position.Z - handJoint.Position.Z;

            handData.RatioX = xRange.GetRelativePosFromValue( dx );
            handData.RatioY = yRange.GetRelativePosFromValue( dy );
            handData.RatioZ = zRange.GetRelativePosFromValue( dz );

            return handData;
        }


        protected double CalcSkeletonPointDistance( SkeletonPoint point1, SkeletonPoint point2 )
        {
            return Math.Sqrt( Math.Pow( point2.X - point1.X, 2 ) +
                Math.Pow( point2.Y - point1.Y, 2 ) +
                Math.Pow( point2.Z - point1.Z, 2 ) );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void nui_SkeletonFrameReady( object sender, SkeletonFrameReadyEventArgs e )
        {
            Skeleton[] skeletons = new Skeleton[0];

            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null)
                {
                    if (skeletonFrame.SkeletonArrayLength == 0)
                        return;

                    skeletons = new Skeleton[skeletonFrame.SkeletonArrayLength];
                    skeletonFrame.CopySkeletonDataTo(skeletons);
                }
            }

            processSkeletons(skeletons);
        }

    }

}
