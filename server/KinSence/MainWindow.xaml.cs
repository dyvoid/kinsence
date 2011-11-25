/////////////////////////////////////////////////////////////////////////
//
// This module contains code to do Kinect NUI initialization and
// processing and also to display NUI streams on screen.
//
// Copyright © Microsoft Corporation.  All rights reserved.  
// This code is licensed under the terms of the 
// Microsoft Kinect for Windows SDK (Beta) from Microsoft Research 
// License Agreement: http://research.microsoft.com/KinectSDK-ToU
//
/////////////////////////////////////////////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Research.Kinect.Nui;
using Newtonsoft.Json;
using UsMedia.KinSence.Modules;
using UsMedia.KinSence.Messages;
using UsMedia.KinSence.Server;
using System.Threading;
using System.Windows.Threading;
using System.Net;
using UsMedia.KinSence.Server.Tcp;


namespace UsMedia.KinSence
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        KinSenceCore kinectCore;
        Runtime nui;
        TcpServer server;

        Dictionary<JointID,Brush> jointColors = new Dictionary<JointID, Brush>() 
        { 
            {JointID.HipCenter, new SolidColorBrush(Color.FromRgb(169, 176, 155))},
            {JointID.Spine, new SolidColorBrush(Color.FromRgb(169, 176, 155))},
            {JointID.ShoulderCenter, new SolidColorBrush(Color.FromRgb(168, 230, 29))},
            {JointID.Head, new SolidColorBrush(Color.FromRgb(200, 0,   0))},
            {JointID.ShoulderLeft, new SolidColorBrush(Color.FromRgb(79,  84,  33))},
            {JointID.ElbowLeft, new SolidColorBrush(Color.FromRgb(84,  33,  42))},
            {JointID.WristLeft, new SolidColorBrush(Color.FromRgb(255, 126, 0))},
            {JointID.HandLeft, new SolidColorBrush(Color.FromRgb(215,  86, 0))},
            {JointID.ShoulderRight, new SolidColorBrush(Color.FromRgb(33,  79,  84))},
            {JointID.ElbowRight, new SolidColorBrush(Color.FromRgb(33,  33,  84))},
            {JointID.WristRight, new SolidColorBrush(Color.FromRgb(77,  109, 243))},
            {JointID.HandRight, new SolidColorBrush(Color.FromRgb(37,   69, 243))},
            {JointID.HipLeft, new SolidColorBrush(Color.FromRgb(77,  109, 243))},
            {JointID.KneeLeft, new SolidColorBrush(Color.FromRgb(69,  33,  84))},
            {JointID.AnkleLeft, new SolidColorBrush(Color.FromRgb(229, 170, 122))},
            {JointID.FootLeft, new SolidColorBrush(Color.FromRgb(255, 126, 0))},
            {JointID.HipRight, new SolidColorBrush(Color.FromRgb(181, 165, 213))},
            {JointID.KneeRight, new SolidColorBrush(Color.FromRgb(71, 222,  76))},
            {JointID.AnkleRight, new SolidColorBrush(Color.FromRgb(245, 228, 156))},
            {JointID.FootRight, new SolidColorBrush(Color.FromRgb(77,  109, 243))}
        };

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public MainWindow()
        {
            InitializeComponent();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC



        // ____________________________________________________________________________________________________
        // PRIVATE

        private void Init()
        {
            kinectCore = new KinSenceCore();

            nui = kinectCore.Nui;

            server = kinectCore.Server;
            server.StateChanged += new EventHandler<StateChangedEventArgs>( server_StateChanged );
        }


        private Point GetDisplayPosition( Joint joint )
        {
            float depthX, depthY;
            nui.SkeletonEngine.SkeletonToDepthImage( joint.Position, out depthX, out depthY );
            depthX = depthX * 320; //convert to 320, 240 space
            depthY = depthY * 240; //convert to 320, 240 space
            int colorX, colorY;
            ImageViewArea iv = new ImageViewArea();
            
            nui.NuiCamera.GetColorPixelCoordinatesFromDepthPixel( ImageResolution.Resolution640x480, iv, (int)depthX, (int)depthY, (short)0, out colorX, out colorY );

            return new Point( (int)( skeleton.Width * colorX / 640.0 ), (int)( skeleton.Height * colorY / 480 ) );
        }


        private Polyline GetBodySegment( Microsoft.Research.Kinect.Nui.JointsCollection joints, Brush brush, params JointID[] ids )
        {
            PointCollection points = new PointCollection( ids.Length );
            for ( int i = 0; i < ids.Length; ++i )
            {
                points.Add( GetDisplayPosition( joints[ ids[ i ] ] ) );
            }

            Polyline polyline = new Polyline();
            polyline.Points = points;
            polyline.Stroke = brush;
            polyline.StrokeThickness = 5;
            return polyline;
        }


        private void DrawSkeletons( SkeletonFrame skeletonFrame )
        {
            int iSkeleton = 0;
            Brush[] brushes = new Brush[ 6 ];
            brushes[ 0 ] = new SolidColorBrush( Color.FromRgb( 255, 0, 0 ) );
            brushes[ 1 ] = new SolidColorBrush( Color.FromRgb( 0, 255, 0 ) );
            brushes[ 2 ] = new SolidColorBrush( Color.FromRgb( 64, 255, 255 ) );
            brushes[ 3 ] = new SolidColorBrush( Color.FromRgb( 255, 255, 64 ) );
            brushes[ 4 ] = new SolidColorBrush( Color.FromRgb( 255, 64, 255 ) );
            brushes[ 5 ] = new SolidColorBrush( Color.FromRgb( 128, 128, 255 ) );

            skeleton.Children.Clear();
            foreach ( SkeletonData data in skeletonFrame.Skeletons )
            {
                if ( SkeletonTrackingState.Tracked == data.TrackingState )
                {
                    // Draw bones
                    Brush brush = brushes[ iSkeleton % brushes.Length ];
                    skeleton.Children.Add( GetBodySegment( data.Joints, brush, JointID.HipCenter, JointID.Spine, JointID.ShoulderCenter, JointID.Head ) );
                    skeleton.Children.Add( GetBodySegment( data.Joints, brush, JointID.ShoulderCenter, JointID.ShoulderLeft, JointID.ElbowLeft, JointID.WristLeft, JointID.HandLeft ) );
                    skeleton.Children.Add( GetBodySegment( data.Joints, brush, JointID.ShoulderCenter, JointID.ShoulderRight, JointID.ElbowRight, JointID.WristRight, JointID.HandRight ) );
                    skeleton.Children.Add( GetBodySegment( data.Joints, brush, JointID.HipCenter, JointID.HipLeft, JointID.KneeLeft, JointID.AnkleLeft, JointID.FootLeft ) );
                    skeleton.Children.Add( GetBodySegment( data.Joints, brush, JointID.HipCenter, JointID.HipRight, JointID.KneeRight, JointID.AnkleRight, JointID.FootRight ) );

                    // Draw joints
                    foreach ( Joint joint in data.Joints )
                    {
                        Point jointPos = GetDisplayPosition( joint );
                        Line jointLine = new Line();
                        jointLine.X1 = jointPos.X - 3;
                        jointLine.X2 = jointLine.X1 + 6;
                        jointLine.Y1 = jointLine.Y2 = jointPos.Y;
                        jointLine.Stroke = jointColors[ joint.ID ];
                        jointLine.StrokeThickness = 6;
                        skeleton.Children.Add( jointLine );
                    }
                }

                iSkeleton++;
            } // for each skeleton
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void Window_Loaded( object sender, EventArgs e )
        {
            Init();
        }


        void Window_Closed( object sender, EventArgs e )
        {
            nui.Uninitialize();
            server.Stop();
            Environment.Exit( 0 );
        }


        private void nui_SkeletonFrameReady( object sender, SkeletonFrameReadyEventArgs e )
        {
            DrawSkeletons( e.SkeletonFrame );
        }


        private void nui_ColorFrameReady( object sender, ImageFrameReadyEventArgs e )
        {
            // 32-bit per pixel, RGBA image
            PlanarImage Image = e.ImageFrame.Image;
            video.Source = BitmapSource.Create(
                Image.Width, Image.Height, 96, 96, PixelFormats.Bgr32, null, Image.Bits, Image.Width * Image.BytesPerPixel );
        }


        private void server_StateChanged( object sender, StateChangedEventArgs e )
        {
            Dispatcher.CurrentDispatcher.BeginInvoke( DispatcherPriority.Normal,
            new ThreadStart( delegate()
            {
                indicatorRed.Visibility     = ( e.State == ServerState.Stopped )   ? Visibility.Visible : Visibility.Hidden;
                indicatorOrange.Visibility  = ( e.State == ServerState.Waiting )   ? Visibility.Visible : Visibility.Hidden;
                indicatorGreen.Visibility   = ( e.State == ServerState.Connected ) ? Visibility.Visible : Visibility.Hidden;
            } ) );
        }


        private void startButton_Click(object sender, RoutedEventArgs e)
        {
            server.Start(IPAddress.Parse(inIPAddress.Text), Convert.ToInt16(inPort.Text));

            stopButton.IsEnabled = true;
            startButton.IsEnabled =
            inIPAddress.IsEnabled =
            inPort.IsEnabled = false;
        }


        private void stopButton_Click(object sender, RoutedEventArgs e)
        {
            server.Stop();

            stopButton.IsEnabled = false;
            startButton.IsEnabled =
            inIPAddress.IsEnabled =
            inPort.IsEnabled = true;
        }


        private void videoStreamsToggle_Checked( object sender, RoutedEventArgs e )
        {
            nui.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>( nui_SkeletonFrameReady );
            nui.VideoFrameReady += new EventHandler<ImageFrameReadyEventArgs>( nui_ColorFrameReady );
        }


        private void videoStreamsToggle_Unchecked( object sender, RoutedEventArgs e )
        {
            nui.SkeletonFrameReady -= nui_SkeletonFrameReady;
            nui.VideoFrameReady -= nui_ColorFrameReady;

            video.Source = null;
            skeleton.Children.Clear();
        }

    }

}
