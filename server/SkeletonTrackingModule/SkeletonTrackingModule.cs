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

        void nui_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            SendMessage( "SkeletonTrackingUpdate", e.SkeletonFrame );
        }
    }
}
