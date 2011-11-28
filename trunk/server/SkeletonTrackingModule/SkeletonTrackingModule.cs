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
