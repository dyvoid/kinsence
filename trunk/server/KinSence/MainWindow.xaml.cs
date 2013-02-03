/////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2012, Pieter van de Sluis, Us Media
// All rights reserved. 
// http://www.usmedia.nl
//
// Portions of this code are taken from the Skeletal Viewer sample 
// application that is part of the official Kinect SDK. 
//
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
using Microsoft.Kinect;
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

    public partial class MainWindow : Window
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        /// <summary>
        /// Width of output drawing
        /// </summary>
        private const float RenderWidth = 640.0f;

        /// <summary>
        /// Height of our output drawing
        /// </summary>
        private const float RenderHeight = 480.0f;

        /// <summary>
        /// Thickness of drawn joint lines
        /// </summary>
        private const double JointThickness = 3;

        /// <summary>
        /// Thickness of body center ellipse
        /// </summary>
        private const double BodyCenterThickness = 10;

        /// <summary>
        /// Thickness of clip edge rectangles
        /// </summary>
        private const double ClipBoundsThickness = 10;

        /// <summary>
        /// Brush used to draw skeleton center point
        /// </summary>
        private readonly Brush centerPointBrush = Brushes.Blue;

        /// <summary>
        /// Brush used for drawing joints that are currently tracked
        /// </summary>
        private readonly Brush trackedJointBrush = new SolidColorBrush(Color.FromArgb(255, 68, 192, 68));

        /// <summary>
        /// Brush used for drawing joints that are currently inferred
        /// </summary>        
        private readonly Brush inferredJointBrush = Brushes.Yellow;

        /// <summary>
        /// Pen used for drawing bones that are currently tracked
        /// </summary>
        private readonly Pen trackedBonePen = new Pen(Brushes.Green, 6);

        /// <summary>
        /// Pen used for drawing bones that are currently inferred
        /// </summary>        
        private readonly Pen inferredBonePen = new Pen(Brushes.Gray, 1);

        /// <summary>
        /// Drawing group for skeleton rendering output
        /// </summary>
        private DrawingGroup drawingGroup;

        /// <summary>
        /// Drawing image that we will display
        /// </summary>
        private DrawingImage imageSource;

        private ColorImageFormat lastImageFormat = ColorImageFormat.Undefined;
        private byte[] rawPixelData;
        private byte[] pixelData;
        private WriteableBitmap outputImage;

        KinSenceCore kinectCore;
        KinectSensor sensor;
        IKinSenceServer server;

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

            sensor = kinectCore.Sensor;

            server = kinectCore.Server;
            server.StateChanged += new EventHandler<StateChangedEventArgs>( server_StateChanged );

            tfVersion.Content = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();

            // Create the drawing group we'll use for drawing
            this.drawingGroup = new DrawingGroup();

            // Create an image source that we can use in our image control
            this.imageSource = new DrawingImage(this.drawingGroup);

            // Display the drawing using our image control
            SkeletonImage.Source = this.imageSource;
        }

        /// <summary>
        /// Draws a skeleton's bones and joints
        /// </summary>
        /// <param name="skeleton">skeleton to draw</param>
        /// <param name="drawingContext">drawing context to draw to</param>
        private void DrawBonesAndJoints(Skeleton skeleton, DrawingContext drawingContext)
        {
            // Render Torso
            this.DrawBone(skeleton, drawingContext, JointType.Head, JointType.ShoulderCenter);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderLeft);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.ShoulderRight);
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderCenter, JointType.Spine);
            this.DrawBone(skeleton, drawingContext, JointType.Spine, JointType.HipCenter);
            this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipLeft);
            this.DrawBone(skeleton, drawingContext, JointType.HipCenter, JointType.HipRight);

            // Left Arm
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderLeft, JointType.ElbowLeft);
            this.DrawBone(skeleton, drawingContext, JointType.ElbowLeft, JointType.WristLeft);
            this.DrawBone(skeleton, drawingContext, JointType.WristLeft, JointType.HandLeft);

            // Right Arm
            this.DrawBone(skeleton, drawingContext, JointType.ShoulderRight, JointType.ElbowRight);
            this.DrawBone(skeleton, drawingContext, JointType.ElbowRight, JointType.WristRight);
            this.DrawBone(skeleton, drawingContext, JointType.WristRight, JointType.HandRight);

            // Left Leg
            this.DrawBone(skeleton, drawingContext, JointType.HipLeft, JointType.KneeLeft);
            this.DrawBone(skeleton, drawingContext, JointType.KneeLeft, JointType.AnkleLeft);
            this.DrawBone(skeleton, drawingContext, JointType.AnkleLeft, JointType.FootLeft);

            // Right Leg
            this.DrawBone(skeleton, drawingContext, JointType.HipRight, JointType.KneeRight);
            this.DrawBone(skeleton, drawingContext, JointType.KneeRight, JointType.AnkleRight);
            this.DrawBone(skeleton, drawingContext, JointType.AnkleRight, JointType.FootRight);

            // Render Joints
            foreach (Joint joint in skeleton.Joints)
            {
                Brush drawBrush = null;

                if (joint.TrackingState == JointTrackingState.Tracked)
                {
                    drawBrush = this.trackedJointBrush;
                }
                else if (joint.TrackingState == JointTrackingState.Inferred)
                {
                    drawBrush = this.inferredJointBrush;
                }

                if (drawBrush != null)
                {
                    drawingContext.DrawEllipse(drawBrush, null, this.SkeletonPointToScreen(joint.Position), JointThickness, JointThickness);
                }
            }
        }

        /// <summary>
        /// Maps a SkeletonPoint to lie within our render space and converts to Point
        /// </summary>
        /// <param name="skelpoint">point to map</param>
        /// <returns>mapped point</returns>
        private Point SkeletonPointToScreen(SkeletonPoint skelpoint)
        {
            // Convert point to depth space.  
            // We are not using depth directly, but we do want the points in our 640x480 output resolution.
            DepthImagePoint depthPoint = this.sensor.CoordinateMapper.MapSkeletonPointToDepthPoint(skelpoint, DepthImageFormat.Resolution640x480Fps30);
            return new Point(depthPoint.X, depthPoint.Y);
        }

        /// <summary>
        /// Draws a bone line between two joints
        /// </summary>
        /// <param name="skeleton">skeleton to draw bones from</param>
        /// <param name="drawingContext">drawing context to draw to</param>
        /// <param name="jointType0">joint to start drawing from</param>
        /// <param name="jointType1">joint to end drawing at</param>
        private void DrawBone(Skeleton skeleton, DrawingContext drawingContext, JointType jointType0, JointType jointType1)
        {
            Joint joint0 = skeleton.Joints[jointType0];
            Joint joint1 = skeleton.Joints[jointType1];

            // If we can't find either of these joints, exit
            if (joint0.TrackingState == JointTrackingState.NotTracked ||
                joint1.TrackingState == JointTrackingState.NotTracked)
            {
                return;
            }

            // Don't draw if both points are inferred
            if (joint0.TrackingState == JointTrackingState.Inferred &&
                joint1.TrackingState == JointTrackingState.Inferred)
            {
                return;
            }

            // We assume all drawn bones are inferred unless BOTH joints are tracked
            Pen drawPen = this.inferredBonePen;
            if (joint0.TrackingState == JointTrackingState.Tracked && joint1.TrackingState == JointTrackingState.Tracked)
            {
                drawPen = this.trackedBonePen;
            }

            drawingContext.DrawLine(drawPen, this.SkeletonPointToScreen(joint0.Position), this.SkeletonPointToScreen(joint1.Position));
        }


        private void ConvertBayerToRgb32(int width, int height)
        {
            // Demosaic using a basic nearest-neighbor algorithm, operating on groups of four pixels.
            for (int y = 0; y < height; y += 2)
            {
                for (int x = 0; x < width; x += 2)
                {
                    int firstRowOffset = (y * width) + x;
                    int secondRowOffset = firstRowOffset + width;

                    // Cache the Bayer component values.
                    byte red = rawPixelData[firstRowOffset + 1];
                    byte green1 = rawPixelData[firstRowOffset];
                    byte green2 = rawPixelData[secondRowOffset + 1];
                    byte blue = rawPixelData[secondRowOffset];

                    // Adjust offsets for RGB.
                    firstRowOffset *= 4;
                    secondRowOffset *= 4;

                    // Top left
                    pixelData[firstRowOffset] = blue;
                    pixelData[firstRowOffset + 1] = green1;
                    pixelData[firstRowOffset + 2] = red;

                    // Top right
                    pixelData[firstRowOffset + 4] = blue;
                    pixelData[firstRowOffset + 5] = green1;
                    pixelData[firstRowOffset + 6] = red;

                    // Bottom left
                    pixelData[secondRowOffset] = blue;
                    pixelData[secondRowOffset + 1] = green2;
                    pixelData[secondRowOffset + 2] = red;

                    // Bottom right
                    pixelData[secondRowOffset + 4] = blue;
                    pixelData[secondRowOffset + 5] = green2;
                    pixelData[secondRowOffset + 6] = red;
                }
            }
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
            sensor.Stop();
            server.Stop();
            Environment.Exit( 0 );
        }


        /// <summary>
        /// Event handler for Kinect sensor's SkeletonFrameReady event
        /// </summary>
        /// <param name="sender">object sending the event</param>
        /// <param name="e">event arguments</param>
        private void sensor_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            Skeleton[] skeletons = new Skeleton[0];

            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null)
                {
                    skeletons = new Skeleton[skeletonFrame.SkeletonArrayLength];
                    skeletonFrame.CopySkeletonDataTo(skeletons);
                }
            }

            using (DrawingContext dc = this.drawingGroup.Open())
            {
                // Draw a transparent background to set the render size
                dc.DrawRectangle(Brushes.Black, null, new Rect(0.0, 0.0, RenderWidth, RenderHeight));

                if (skeletons.Length != 0)
                {
                    foreach (Skeleton skel in skeletons)
                    {
                        if (skel.TrackingState == SkeletonTrackingState.Tracked)
                        {
                            this.DrawBonesAndJoints(skel, dc);
                        }
                        else if (skel.TrackingState == SkeletonTrackingState.PositionOnly)
                        {
                            dc.DrawEllipse(
                            this.centerPointBrush,
                            null,
                            this.SkeletonPointToScreen(skel.Position),
                            BodyCenterThickness,
                            BodyCenterThickness);
                        }
                    }
                }

                // prevent drawing outside of our render area
                this.drawingGroup.ClipGeometry = new RectangleGeometry(new Rect(0.0, 0.0, RenderWidth, RenderHeight));
            }
        }


        private void senser_ColorFrameReady(object sender, ColorImageFrameReadyEventArgs e)
        {
            using (ColorImageFrame imageFrame = e.OpenColorImageFrame())
            {
                if (imageFrame != null)
                {
                    // We need to detect if the format has changed.
                    bool haveNewFormat = this.lastImageFormat != imageFrame.Format;
                    bool convertToRgb = false;
                    int bytesPerPixel = imageFrame.BytesPerPixel;

                    if (imageFrame.Format == ColorImageFormat.RawBayerResolution640x480Fps30 ||
                        imageFrame.Format == ColorImageFormat.RawBayerResolution1280x960Fps12)
                    {
                        convertToRgb = true;
                        bytesPerPixel = 4;
                    }

                    if (haveNewFormat)
                    {
                        if (convertToRgb)
                        {
                            this.rawPixelData = new byte[imageFrame.PixelDataLength];
                            this.pixelData = new byte[bytesPerPixel * imageFrame.Width * imageFrame.Height];
                        }
                        else
                        {
                            this.pixelData = new byte[imageFrame.PixelDataLength];
                        }
                    }

                    if (convertToRgb)
                    {
                        imageFrame.CopyPixelDataTo(this.rawPixelData);
                        ConvertBayerToRgb32(imageFrame.Width, imageFrame.Height);
                    }
                    else
                    {
                        imageFrame.CopyPixelDataTo(this.pixelData);
                    }

                    // A WriteableBitmap is a WPF construct that enables resetting the Bits of the image.
                    // This is more efficient than creating a new Bitmap every frame.
                    if (haveNewFormat)
                    {
                        PixelFormat format = PixelFormats.Bgr32;
                        if (imageFrame.Format == ColorImageFormat.InfraredResolution640x480Fps30)
                        {
                            format = PixelFormats.Gray16;
                        }

                       ColorImage.Visibility = Visibility.Visible;
                        this.outputImage = new WriteableBitmap(
                            imageFrame.Width,
                            imageFrame.Height,
                            96,  // DpiX
                            96,  // DpiY
                            format,
                            null);

                        this.ColorImage.Source = this.outputImage;
                    }

                    this.outputImage.WritePixels(
                        new Int32Rect(0, 0, imageFrame.Width, imageFrame.Height),
                        this.pixelData,
                        imageFrame.Width * bytesPerPixel,
                        0);

                    this.lastImageFormat = imageFrame.Format;
                }
            }
        }


        private void server_StateChanged( object sender, StateChangedEventArgs e )
        {
            Dispatcher.CurrentDispatcher.BeginInvoke( new Action( () =>
            {
                indicatorRed.Visibility = ( e.State == ServerState.Stopped ) ? Visibility.Visible : Visibility.Hidden;
                indicatorOrange.Visibility = ( e.State == ServerState.Waiting ) ? Visibility.Visible : Visibility.Hidden;
                indicatorGreen.Visibility = ( e.State == ServerState.Connected ) ? Visibility.Visible : Visibility.Hidden;
            } ) );
        }


        private void startButton_Click( object sender, RoutedEventArgs e )
        {
            IPAddress ipAddress;
            int port;

            try
            {
                ipAddress = IPAddress.Parse( inIPAddress.Text );
            }
            catch ( Exception )
            {
                MessageBox.Show( "IP Address is invalid" );
                return;
            }

            try
            {
                port = Convert.ToInt16( inPort.Text );

                if ( port > 65535 )
                    throw new Exception();
            }
            catch ( Exception )
            {
                MessageBox.Show( "Port is invalid" );
                return;
            }

            server.Start( ipAddress, port );

            stopButton.IsEnabled = true;
            startButton.IsEnabled =
            inIPAddress.IsEnabled =
            inPort.IsEnabled = false;
        }


        private void stopButton_Click( object sender, RoutedEventArgs e )
        {
            server.Stop();

            stopButton.IsEnabled = false;
            startButton.IsEnabled =
            inIPAddress.IsEnabled =
            inPort.IsEnabled = true;
        }


        private void videoStreamsToggle_Checked( object sender, RoutedEventArgs e )
        {
            sensor.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(sensor_SkeletonFrameReady);
            sensor.ColorFrameReady += new EventHandler<ColorImageFrameReadyEventArgs>(senser_ColorFrameReady );
        }


        private void videoStreamsToggle_Unchecked( object sender, RoutedEventArgs e )
        {
            sensor.SkeletonFrameReady -= sensor_SkeletonFrameReady;
            sensor.ColorFrameReady -= senser_ColorFrameReady;

            ColorImage.Source = null;
            SkeletonImage.Source = null;
        }

        private void inIPAddress_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

    }

}
