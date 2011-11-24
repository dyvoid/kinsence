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
    import away3d.materials.methods.SoftShadowMapMethod;
    import away3d.materials.utils.CubeMap;
    import away3d.primitives.PrimitiveBase;
    import away3d.primitives.SkyBox;
    import away3d.primitives.WireframeSphere;

    import com.greensock.TweenMax;
    import com.greensock.easing.Quint;

    import examples.db9.texttospeech.TextToSpeech;

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
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.JointID;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.JointTrackingState;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.KinSenceVector;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonData;
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

        public static const NUM_CUBES   :uint = 400;

//        public static const kinectlessMode :Boolean = true;
        public static const kinectlessMode :Boolean = false;

        private var _autoRotate:Boolean = false;

        private var _kinSence:KinSence;

        private var _skeletonTracking:SkeletonTrackingModule;
        private var _speechRecognition:SpeechRecognitionModule;
        private var _handTracking:HandTrackingModule;

        private var _xRangeKinect:Range = new Range( -2.2, 2.2 );
        private var _yRangeKinect:Range = new Range( 2.2, -2.2 );
        private var _zRangeKinect:Range = new Range( 4, 0 );

        private var _xRangeStage:Range = new Range( 0, 900 );
        private var _yRangeStage:Range = new Range( 0, 680 );
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

        private var cube:PrimitiveBase;
        private var _carMat:ColorMaterial;

        private var _tts:TextToSpeech = new TextToSpeech();
        private var skyLight:DirectionalLight;

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

            initKinectClient();
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
            this.addChild( _leftHandTracker );
            this.addChild( _rightHandTracker );
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

        private function initKinectClient():void
        {
            _kinSence = new KinSence();
            _kinSence.addEventListener( Event.CONNECT, connectHandler );

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

            if ( !kinectlessMode )
            {
//                _kinSence.connect( "127.0.0.1", 3000 );
                _kinSence.connect( "192.168.1.7", 3000 );
            }
        }


        private function connectHandler( event:Event ):void
        {
            _kinSence.setElevationAngle( 10 );
            _kinSence.setTransformSmooth( true );
            _kinSence.setTransformSmoothParameters( new TransformSmoothParameters( 0.3, 1, 0.5, 0.4, 0.5 ) );

//            _tts.say( "connected to server" );
        }

        private function initAway3D():void
        {
            // Setup the view
			_view = new View3D();
            _view.backgroundColor = 0xdddddd;
			_view.antiAlias = 16;
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

            skyLight = new DirectionalLight();
            skyLight.color = 0xffffff;
            skyLight.y = 500;
            skyLight.specular = 1.2;
            skyLight.diffuse = .8;
            skyLight.castsShadows = true;
            skyLight.lookAt(new Vector3D(0,0,0));
            _view.scene.addChild(skyLight);
        }


        private var _mainObject:Loader3D;


        private var _skyBoxCubeMap:CubeMap;


        private var _skybox:SkyBox;


        private var _skyboxSide:BitmapData;


        private var _skyboxTopBottom:BitmapData;


        private function initObjects():void
        {
            var reflectMap:BitmapData = new ChromeBlurred();

            var shadowMethod:SoftShadowMapMethod = new SoftShadowMapMethod( skyLight );

			// Create primitives material
            _carMat = new ColorMaterial( 0x999999, 1 ); // medium gray
            _carMat.glossMap = reflectMap;
//            _carMat.gloss = 0.001;
            _carMat.ambientColor = 0xffffff;
//            _carMat.ambient = 0.4;
            _carMat.specularMap = reflectMap;
			_carMat.lights = [_light1, _light2, _light3, skyLight]; // setup the material to use lights
//			_carMat.lights = [ _light2, skyLight]; // setup the material to use lights
            _carMat.bothSides = false;
            _carMat.shadowMethod = shadowMethod;
//            _carMat.shadowMethod = new FilteredShadowMapMethod(skyLight);

            var sphere:WireframeSphere = new WireframeSphere(1000,26,24,0x444444, 3);
//            _view.scene.addChild(sphere);

            /*for ( var i:int = 0; i < NUM_CUBES; i++ )
            {
                var orb:Orb = new Orb();
                _view.scene.addChild( orb );
            }*/


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
//            var context:AssetLoaderContext = new AssetLoaderContext(true, "F:/Projects/Flash/Kinect/flash/assets/apache/maps");
//            _mainObject.load( new URLRequest( "../assets/apache/apache.3ds" ), context );
            var context:AssetLoaderContext = new AssetLoaderContext(true, _localDir + "car");
            _mainObject.load( new URLRequest( _localDir + "car/db9.3ds" ), context );
            _view.scene.addChild(_mainObject);

            var bloomFilter:BloomFilter3D = new BloomFilter3D( 25, 25, 0.01, 0.1 )
            var dofFilter:DepthOfFieldFilter3D = new DepthOfFieldFilter3D(5, 5);
//            dofFilter.focusDistance = 500;
            dofFilter.range = 300;
            dofFilter.focusTarget = _mainObject;
            var motionBlurFilter:MotionBlurFilter3D = new MotionBlurFilter3D(0.6);
            var radialBlurFilter:RadialBlurFilter3D = new RadialBlurFilter3D( 0.25, 1 )
//            _view.filters3d = [ dofFilter ];

            _view.camera.lookAt( _mainObject.position );
            _view.camera.y = 200;

            addEventListener( Event.ENTER_FRAME, onEnterFrame );
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
//                mesh.geometry.subGeometries[0].autoDeriveVertexNormals = true;
//                mesh.material = _carMat;

                var reflectMap:BitmapData = new ChromeBlurred();

                var material:DefaultMaterialBase = mesh.material as DefaultMaterialBase;

                if ( mesh.name != "Floor" )
                {
                    material.lights = [_light1, _light2, _light3, skyLight ];
//                  material.glossMap = reflectMap;
//                  material.gloss = 200;
//                    material.specular = 1;
//                    material.specularMap = reflectMap;
                    material.bothSides = false;
                    material.shadowMethod = new SoftShadowMapMethod( skyLight );
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
            _bodyMat.gloss = 130;
            _bodyMat.specular = 1;
            _bodyMat.lights = [_light1, _light2, _light3, skyLight];
//            _bodyMat.lights = null;

            var envMapAmbientMethod:EnvMapAmbientMethod = new EnvMapAmbientMethod( _skyBoxCubeMap );
//            _bodyMat.ambientMethod = envMapAmbientMethod;

            var envMapDiffuseMethod:EnvMapDiffuseMethod = new EnvMapDiffuseMethod( _skyBoxCubeMap );
//            _bodyMat.diffuseMethod = envMapDiffuseMethod;

//            _bodyMat.addMethod( new RimLightMethod(0xffffff, 1, 6, RimLightMethod.ADD ) );
            
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


        private function onEnterFrame( e:Event ):void
        {
            if ( kinectlessMode || _autoRotate )
            {
//                _mainObject.rotationX += 1.15;
                _mainObject.rotationY += 1.15;
//              _mainObject.rotationZ += 1.15;
            }

//            _light1.x -= 1;
//            _light2.x += 1;

//            _view.camera.z += 1;
//            _view.camera.y += 1;
            _view.camera.lookAt( new Vector3D(0,0,0) );

//            _kinSence.fakeIt( TestData.next() );

            _view.render();
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

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
                "color brown",
                "start auto rotate",
                "stop auto rotate"
            ];

            _speechRecognition.configure( phrases, "start listening", "stop listening" );
        }


        private function skeletonTrackingUpdateHandler( e:SkeletonTrackingEvent ):void
        {
            for each ( var skeletonData:SkeletonData in e.skeletonFrame.skeletons)
            {
                if ( skeletonData.trackingState == SkeletonTrackingState.Tracked )
                {
                    var joint:Joint;
                    var position:KinSenceVector;

                    joint = skeletonData.getJointByID( JointID.HEAD );

                    if ( joint.trackingState != JointTrackingState.NotTracked )
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

                    case "start auto rotate":
                        _tts.say( "auto rotate activated" );
                        _autoRotate = true;
                        return;

                    case "stop auto rotate":
                        _tts.say( "auto rotate deactivated" );
                        _autoRotate = false;
                        return;

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

                _rightHandTracker.x = rightHand.ratioX * stage.stageWidth;
                _rightHandTracker.y = rightHand.ratioY * stage.stageHeight;

//                _rightHandTracker.scaleX =
//                _rightHandTracker.scaleY = rightHand.ratioZ;

                if ( rightHand.ratioY < 0.7 && rightHand.ratioZ > 0.5 )
                {
                    _mainObject.rotationY = rightHand.ratioX * 360;
//                    _mainObject.rotationX = rightHand.ratioY * 360;
//                cube.rotationY = Math.PI * rightHand.ratioY;
                }

                if ( leftHand.ratioY < 0.7 && leftHand.ratioZ > 0.5 )
                {
                    /*var brightness:Number = 1 - leftHand.ratioY + 0.5;

                    updateLighting( brightness );*/
                }

            }
        }


        private function updateLighting( brightness:Number ):void
        {
            var newSky:BitmapData = Bitmap( new SkyboxSide() ).bitmapData;
            var colorTransForm:ColorTransform = new ColorTransform( brightness, brightness, brightness );
            newSky.colorTransform( _skyboxSide.rect, colorTransForm );

            _skyBoxCubeMap = new CubeMap( newSky, newSky, _skyboxTopBottom, _skyboxTopBottom, newSky, newSky );
            SkyBoxMaterial( _skybox.material ).cubeMap = _skyBoxCubeMap;
        }

    }
}