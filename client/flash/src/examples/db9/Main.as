/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2012 Pieter van de Sluis, Us Media
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://www.usmedia.nl
 */

package examples.db9
{
    import away3d.containers.ObjectContainer3D;
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.events.LoaderEvent;
    import away3d.filters.BloomFilter3D;
    import away3d.filters.DepthOfFieldFilter3D;
    import away3d.filters.MotionBlurFilter3D;
    import away3d.filters.RadialBlurFilter3D;
    import away3d.lights.DirectionalLight;
    import away3d.lights.PointLight;
    import away3d.loaders.Loader3D;
    import away3d.loaders.misc.AssetLoaderContext;
    import away3d.loaders.parsers.Parsers;
    import away3d.materials.BitmapMaterial;
    import away3d.materials.ColorMaterial;
    import away3d.materials.DefaultMaterialBase;
    import away3d.materials.MaterialLibrary;
    import away3d.materials.SkyBoxMaterial;
    import away3d.materials.methods.EnvMapAmbientMethod;
    import away3d.materials.methods.EnvMapDiffuseMethod;
    import away3d.materials.methods.FresnelEnvMapMethod;
    import away3d.materials.methods.RimLightMethod;
    import away3d.materials.methods.SoftShadowMapMethod;
    import away3d.materials.utils.CubeMap;
    import away3d.primitives.PrimitiveBase;
    import away3d.primitives.SkyBox;
    import away3d.primitives.WireframeSphere;

    import com.greensock.TweenMax;
    import com.greensock.easing.Quint;

    import examples.db9.texttospeech.TextToSpeech;

    import flash.events.ErrorEvent;

    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    import nl.usmedia.kinsence.KinSence;
    import nl.usmedia.kinsence.transformsmooth.TransformSmoothParameters;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Vector3D;
    import flash.net.URLRequest;

    import nl.usmedia.kinsence.modules.events.KinSenceModuleEvent;
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent;
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingModule;
    import nl.usmedia.kinsence.modules.handtracking.hands.HandData;
    import nl.usmedia.kinsence.modules.handtracking.hands.Hands;
    import nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingEvent;
    import nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingModule;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.Joint;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.JointType;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.JointTrackingState;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonPoint;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.Skeleton;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonTrackingState;
    import nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionEvent;
    import nl.usmedia.kinsence.modules.speechrecognition.SpeechRecognitionModule;

    import nl.imotion.utils.range.Range;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1000",height="600",frameRate="31")]
    public class Main extends Sprite
    {

        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _autoRotate:Boolean = false;

        private var _kinSence:KinSence;

        private var _skeletonTracking:SkeletonTrackingModule;
        private var _speechRecognition:SpeechRecognitionModule;
        private var _handTracking:HandTrackingModule;

        private var _xRangeKinect:Range = new Range( -2.2, 2.2 );
        private var _yRangeKinect:Range = new Range( 2.2, -2.2 );
        private var _zRangeKinect:Range = new Range( 4, 0 );

        private var _xRangeStage:Range = new Range( 0, 1000 );
        private var _yRangeStage:Range = new Range( 0, 600 );
        private var _zRangeStage:Range = new Range( 0, 2 );

        private var _xRangeCamera:Range = new Range( -1500, 1500 );
        private var _yRangeCamera:Range = new Range( 1500, -1500 );
        private var _zRangeCamera:Range = new Range( -1400, -200 );

        private var _headTracker:Shape;
        private var _leftHandTracker:Shape;
        private var _rightHandTracker:Shape;

        private var _view:View3D;

        private var _light1:PointLight;
        private var _light2:PointLight;
        private var _light3:PointLight;

        private var _tts:TextToSpeech = new TextToSpeech();

        private var _mainObject:Loader3D;
        private var _skyBoxCubeMap:CubeMap;
        private var _skybox:SkyBox;
        private var _skyboxSide:BitmapData;
        private var _skyboxTopBottom:BitmapData;
        private var _skyLight:DirectionalLight;

        private var _localDir:String;

        [Embed("../../../assets/car/Skybox_Side.png")]
        private var SkyboxSide:Class;

        [Embed("../../../assets/car/Skybox_TopBottom.png")]
        private var SkyboxTopBottom:Class;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Main()
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.stageFocusRect = false;

            stage.addEventListener( Event.RESIZE, resizeHandler );

            var url:String = this.loaderInfo.loaderURL;

            //the directory separator depends on the type of flash player
            var splitChar:String;
            if ( url.indexOf ( 'file:///' ) > -1 || url.indexOf ( 'http://' ) > -1 || url.indexOf ( 'https://' ) > -1 ) splitChar = '/';
            else splitChar = '\\';

            //split the url by the separator, remove the name of the file (last item)
            var parts:Array = url.split ( splitChar );
            parts.pop();

            _localDir = parts.join("/") + "/";

            initKinSence();
            initAway3D();
            initObjects();

            _headTracker = new Shape();
            _headTracker.x = stage.stageWidth * 0.5;
            _headTracker.y = stage.stageHeight * 0.5;
            _headTracker.graphics.beginFill( 0xFFCC33, 0.25 );
            _headTracker.graphics.drawCircle( 0, 0, 20 );
            _headTracker.graphics.endFill();

            _leftHandTracker = new Shape();
            _leftHandTracker.x = stage.stageWidth * 0.5;
            _leftHandTracker.y = stage.stageHeight * 0.5;
            _leftHandTracker.graphics.beginFill( 0x00ff00, 0.25 );
            _leftHandTracker.graphics.drawCircle( 0, 0, 20 );
            _leftHandTracker.graphics.endFill();

            _rightHandTracker = new Shape();
            _rightHandTracker.x = stage.stageWidth * 0.5;
            _rightHandTracker.y = stage.stageHeight * 0.5;
            _rightHandTracker.graphics.beginFill( 0x0000ff, 0.25 );
            _rightHandTracker.graphics.drawCircle( 0, 0, 20 );
            _rightHandTracker.graphics.endFill();

//            this.addChild( _headTracker );
//            this.addChild( _leftHandTracker );
//            this.addChild( _rightHandTracker );
        }


        private function resizeHandler( event:Event ):void
        {
            _view.width  = stage.stageWidth;
            _view.height = stage.stageHeight;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function initKinSence():void
        {
            _kinSence = new KinSence();
            _kinSence.addEventListener( Event.CONNECT, connectSuccessHandler );
            _kinSence.addEventListener( IOErrorEvent.IO_ERROR, connectErrorHandler );
            _kinSence.addEventListener( SecurityErrorEvent.SECURITY_ERROR, connectErrorHandler );

            _skeletonTracking = new SkeletonTrackingModule();
            _skeletonTracking.addEventListener( SkeletonTrackingEvent.SKELETON_TRACKING_UPDATE, skeletonTrackingUpdateHandler );
            _kinSence.registerModule( _skeletonTracking );

            _speechRecognition = new SpeechRecognitionModule();
            _speechRecognition.addEventListener( SpeechRecognitionEvent.SPEECH_RECOGNIZED, speechRecognizedHandler );
            _speechRecognition.addEventListener( KinSenceModuleEvent.REGISTERED, speechRecognitionModuleRegisteredEvent );
            _kinSence.registerModule( _speechRecognition );

            _handTracking = new HandTrackingModule();
            _handTracking.addEventListener( HandTrackingEvent.HAND_TRACKING_UPDATE, handTrackingUpdateHandler );
            _kinSence.registerModule( _handTracking );

//            _kinSence.connect( "127.0.0.1", 3000 );
              _kinSence.connect( "192.168.1.6", 3000 );
        }


        private function initAway3D():void
        {
            // Setup the view
			_view = new View3D();
            _view.backgroundColor = 0xdddddd;
			_view.antiAlias = 4;
			addChild(_view);

            _view.camera.z = -750;
            _view.camera.lookAt(new Vector3D());

			// Setup lights
            _light1 = new PointLight();
			_light1.color = 0xFFFFFF; // white
			_light1.x = 500;
			_light1.z = -500;
			_light1.radius = 95;
			_light1.fallOff = 1800;
			_view.scene.addChild(_light1);

            _light2 = new PointLight();
			_light2.color = 0xFFFFFF; // red
			_light2.x = -500;
			_light2.z = -500;
			_light2.radius = 95;
			_light2.fallOff = 1800;
			_view.scene.addChild(_light2);

            _light3 = new PointLight();
			_light3.color = 0xFFFFFF; // white
            _light3.y = 500;
			_light3.z = 1500;
            _light3.specular = 8;
			_light3.radius = 95;
			_light3.fallOff = 1800;
			_view.scene.addChild(_light3);

            _skyLight = new DirectionalLight();
            _skyLight.color = 0xffffff;
            _skyLight.y = 500;
            _skyLight.specular = 1.2;
            _skyLight.diffuse = .8;
            _skyLight.castsShadows = true;
            _skyLight.lookAt(new Vector3D());
            _view.scene.addChild(_skyLight);
        }


        private function initObjects():void
        {
            var reflectMap:BitmapData = new ChromeBlurred();

            var shadowMethod:SoftShadowMapMethod = new SoftShadowMapMethod( _skyLight );

            _skyboxSide = Bitmap( new SkyboxSide() ).bitmapData;
            _skyboxTopBottom = Bitmap( new SkyboxTopBottom() ).bitmapData;

            _skyBoxCubeMap = new CubeMap( _skyboxSide, _skyboxSide, _skyboxTopBottom, _skyboxTopBottom, _skyboxSide, _skyboxSide );
            _skybox = new SkyBox( _skyBoxCubeMap );
            _view.scene.addChild(_skybox);

            Parsers.enableAllBundled();

            _mainObject = new Loader3D();
            _mainObject.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
            _mainObject.addEventListener(LoaderEvent.DATA_LOADED, onResourceDataLoaded);
            _mainObject.scale(100);
            _mainObject.rotationY = -90;
            var context:AssetLoaderContext = new AssetLoaderContext(true, _localDir + "car");
            _mainObject.load( new URLRequest( _localDir + "car/db9.3ds" ), context );
            _view.scene.addChild(_mainObject);

            _view.camera.lookAt( _mainObject.position );
            _view.camera.y = 200;

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function onResourceDataLoaded( e:LoaderEvent ):void
        {
            trace("DATA LOADED");
        }


        private function onResourceComplete( event:LoaderEvent ):void
        {
            trace("RESOURCE COMPLETE");

//            stage.displayState = StageDisplayState.FULL_SCREEN;

            applyMaterial( _mainObject );
        }


        private var _bodyMat:ColorMaterial;


        private function applyMaterial( objectContainer3D: ObjectContainer3D ):void
        {
            var mesh:Mesh;
            for ( var j:int = 0; j < objectContainer3D.numChildren; ++j )
            {
                mesh = Mesh( objectContainer3D.getChildAt( j ) );

                var material:DefaultMaterialBase = mesh.material as DefaultMaterialBase;

                if ( mesh.name != "Floor" )
                {
                    material.lights = [_light1, _light2, _light3, _skyLight ];
                    material.bothSides = false;
                    material.shadowMethod = new SoftShadowMapMethod( _skyLight );
                }
                else
                {
                    var floorMat:BitmapMaterial = material as BitmapMaterial;
                    floorMat.ambientColor = 0xffffff;
                    floorMat.ambient = 1;
                    floorMat.alphaBlending = true;
                }
            }

            var blackMat:ColorMaterial = MaterialLibrary.getInstance().getMaterial( "Black" ) as ColorMaterial;
            blackMat.specular = 0;
            blackMat.gloss = 255;

            _bodyMat = MaterialLibrary.getInstance().getMaterial( "BodyColor" ) as ColorMaterial;
            
            applyFresnel( "BodyColor", 1.5 );
            applyFresnel( "Windows" );
            applyFresnel( "Light covers" );
        }


        private function applyFresnel( materialName:String, fresnelPower:Number = 1 ):void
        {
             var mat:ColorMaterial = MaterialLibrary.getInstance().getMaterial( materialName ) as ColorMaterial;

             var fresnelEnvMapMethod:FresnelEnvMapMethod = new FresnelEnvMapMethod( _skyBoxCubeMap );
             fresnelEnvMapMethod.fresnelPower = fresnelPower;
             fresnelEnvMapMethod.normalReflectance = 0.1;
             mat.addMethod( fresnelEnvMapMethod );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function connectSuccessHandler( event:Event ):void
        {
            _kinSence.setTransformSmoothParameters( new TransformSmoothParameters( 0.3, 1, 0.5, 0.4, 0.5 ) );

//            _tts.say( "connected to server" );
        }


        private function connectErrorHandler( e:ErrorEvent ):void
        {
            _autoRotate = true;
        }


        private function enterFrameHandler( e:Event ):void
        {
            if ( _autoRotate )
            {
                _mainObject.rotationY += 1.15;
            }
            
            _view.camera.lookAt( new Vector3D() );

            _view.render();
        }
        

        private function speechRecognitionModuleRegisteredEvent( e:KinSenceModuleEvent ):void
        {
            var phrases:Array = [
                "color black",
                "color white",
                "color red",
                "color green",
                "color blue",
                "color yellow",
                "color orange",
                "color pink",
                "color brown"
            ];

            _speechRecognition.configure( phrases, "start listening", "stop listening" );
        }


        private function skeletonTrackingUpdateHandler( e:SkeletonTrackingEvent ):void
        {
            for each ( var skeletonData:Skeleton in e.skeletonFrame.skeletons)
            {
                if ( skeletonData.trackingState == SkeletonTrackingState.TRACKED )
                {
                    var joint:Joint;
                    var position:SkeletonPoint;

                    joint = skeletonData.getJointByID( JointType.HEAD );

                    if ( joint.trackingState != JointTrackingState.NOT_TRACKED )
                    {
                        position = joint.position;

                        _headTracker.x = _xRangeKinect.translate( position.x, _xRangeStage );
                        _headTracker.y = _yRangeKinect.translate( position.y, _yRangeStage );
                        _headTracker.scaleX =
                        _headTracker.scaleY = _zRangeKinect.translate( position.z, _zRangeStage );

                        _view.camera.x = _xRangeKinect.translate( position.x, _xRangeCamera );
                        _view.camera.y = _yRangeKinect.translate( position.y, _yRangeCamera );
                        _view.camera.z = _zRangeKinect.translate( position.z, _zRangeCamera );
                    }
                }
            }
        }


        private function speechRecognizedHandler( e:SpeechRecognitionEvent ):void
        {
            trace( "Speech recognized: \"" + e.result.text + "\"::Confidence: " + e.result.confidence );

            if ( e.result.confidence > 0.9 )
            {
                var color:uint;

                switch( e.result.text )
                {
                    case "color black":
                        color = 0x000000;
                    break;

                    case "color white":
                        color = 0xffffff;
                    break;

                    case "color red":
                        color = 0xbb0000;
                    break;

                    case "color green":
                        color = 0x009900;
                    break;

                    case "color blue":
                        color = 0x000088;
                    break;

                    case "color yellow":
                        color = 0xcccc00;
                    break;

                    case "color orange":
                        color = 0xFF6633;
                    break;

                    case "color pink":
                        color = 0xFF33CC;
                    break;

                    case "color brown":
                        color = 0x94540F;
                    break;

                    case "start listening":
                        _tts.say( "voice control activated" );
                        return;
                    break;

                    case "stop listening":
                        _tts.say( "voice control deactivated" );
                        return;
                    break;

                    default:
                        return;
                }

                _tts.say( "setting the color to " + e.result.text.substr( 6 ) );
                TweenMax.to( _bodyMat, 2, { hexColors: { color: color }, ease: Quint.easeInOut } );
            }
        }


        private function handTrackingUpdateHandler( e:HandTrackingEvent ):void
        {
            if ( e.handSets.length > 0 )
            {
                var handSet:Hands = e.handSets[ 0 ];

                var leftHand:HandData = handSet.left;
                var rightHand:HandData = handSet.right;

                _leftHandTracker.x = leftHand.ratioX * stage.stageWidth;
                _leftHandTracker.y = leftHand.ratioY * stage.stageHeight;
                _leftHandTracker.scaleX =
                _leftHandTracker.scaleY = leftHand.ratioZ;

                _rightHandTracker.x = rightHand.ratioX * stage.stageWidth;
                _rightHandTracker.y = rightHand.ratioY * stage.stageHeight;
                _rightHandTracker.scaleX =
                _rightHandTracker.scaleY = rightHand.ratioZ;

                if ( rightHand.ratioY < 0.7 && rightHand.ratioZ > 0.5 )
                {
                    _mainObject.rotationY = rightHand.ratioX * 360;
                }

                if ( leftHand.ratioY < 0.7 && leftHand.ratioZ > 0.5 )
                {
                    var brightness:Number = 1 - leftHand.ratioY + 0.5;

                    updateLighting( brightness );
                }
            }
        }


        private function updateLighting( brightness:Number ):void
        {
            _mainObject.scaleX =
                    _mainObject.scaleY =
                            _mainObject.scaleZ = brightness * 150;
        }

    }
}