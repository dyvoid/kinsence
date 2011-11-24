using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinSence.Util;

namespace UsMedia.KinSence.Modules.HandTracking
{
    public class HandTrackingModule : AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "HandTracking";

        private double armLength = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public HandTrackingModule() : base( NAME )
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

        private HandData CreateHandData( Joint shoulderJoint, Joint elbowJoint, Joint handJoint )
        {
            HandData handData = new HandData();

            if ( shoulderJoint.TrackingState != JointTrackingState.NotTracked &&
                 elbowJoint.TrackingState != JointTrackingState.NotTracked &&
                 handJoint.TrackingState != JointTrackingState.NotTracked )
            {
                armLength = 0;
                armLength += Math.Abs( CalcVectorDistance( shoulderJoint.Position, elbowJoint.Position ) );
                armLength += Math.Abs( CalcVectorDistance( elbowJoint.Position, handJoint.Position ) );
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

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void processSkeletons( SkeletonData[] skeletons )
        {
            List<Hands> handsCollection = new List<Hands>();

            foreach ( SkeletonData data in skeletons )
            {
                if ( data.TrackingState == SkeletonTrackingState.Tracked )
                {
                    Hands hands = new Hands();
                    hands.SkeletonTrackingID = data.TrackingID;
                    hands.SkeletonUserIndex = data.UserIndex;

                    hands.Left = CreateHandData( data.Joints[ JointID.ShoulderLeft ],
                        data.Joints[ JointID.ElbowLeft ],
                        data.Joints[ JointID.HandLeft ] );
                    hands.Left.TrackingState = data.Joints[ JointID.HandLeft ].TrackingState;

                    hands.Right = CreateHandData( data.Joints[ JointID.ShoulderRight ],
                        data.Joints[ JointID.ElbowRight ],
                        data.Joints[ JointID.HandRight ] );
                    hands.Right.TrackingState = data.Joints[ JointID.HandRight ].TrackingState;

                    double maxDistance = armLength * 2 + CalcVectorDistance(data.Joints[JointID.ShoulderLeft].Position, data.Joints[JointID.ShoulderRight].Position);
                    double distance = CalcVectorDistance(data.Joints[JointID.HandLeft].Position, data.Joints[JointID.HandRight].Position);
                    hands.DistanceRatio = distance / maxDistance;
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


        protected double CalcVectorDistance( Vector vector1, Vector vector2 )
        {
            return Math.Sqrt( Math.Pow( vector2.X - vector1.X, 2 ) +
                Math.Pow( vector2.Y - vector1.Y, 2 ) +
                Math.Pow( vector2.Z - vector1.Z, 2 ) );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void nui_SkeletonFrameReady( object sender, SkeletonFrameReadyEventArgs e )
        {
            processSkeletons( e.SkeletonFrame.Skeletons );
        }

    }

}
