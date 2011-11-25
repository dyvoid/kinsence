package examples.fireball
{
    import examples.db9.texttospeech.TextToSpeech;

    import flash.display.Bitmap;

    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.errors.IOError;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SampleDataEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.Sound;
    import flash.system.SecurityPrivilege;
    import flash.text.TextField;

    import nl.imotion.utils.fpsmeter.FPSMeter;

    import nl.imotion.utils.range.Range;

    import nl.usmedia.kinsence.KinSence;
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent;
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingModule;
    import nl.usmedia.kinsence.modules.handtracking.hands.Hands;
    import nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingEvent;
    import nl.usmedia.kinsence.modules.skeletontracking.SkeletonTrackingModule;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.JointID;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.KinSenceVector;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonData;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonTrackingState;
    import nl.usmedia.kinsence.transformsmooth.TransformSmoothParameters;

    import org.casalib.math.Percent;

    import org.casalib.util.ColorUtil;


    /**
     * @author Pieter van de Sluis
     */
    [SWF(backgroundColor="#000000",frameRate="31")]
    public class Main extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var colorLayer:Sprite;
        public var fpsText:TextField;

        private var _kinSence:KinSence;
        private var _handTracking:HandTrackingModule;
        private var _tts:TextToSpeech;

        private var _bounds:Range = new Range( 0.4, 0.1 );

        private var _minColor:uint = 0xFF000000;
        private var _maxColor:uint = 0xFFA8EBFF;

        private var _minColorTransform:ColorTransform;
        private var _maxColorTransform:ColorTransform;

        private var _intensity:Number = 0;
        private var _intensityTarget:Number = 0;

        private var _fpsMeter:FPSMeter;

        private var _cloudMap1:BitmapData;
        private var _cloudMap2:BitmapData;

        private var _cloudWidth:Number = 75;
        private var _cloudHeight:Number = 75;

        private var _cloudsOffset1:Number = 0;
        private var _cloudsOffset2:Number = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Main()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private var _noiseMap:BitmapData;

        private var _clouds1:Bitmap;
        private var _clouds2:Bitmap;


        private function init():void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.stageFocusRect = false;

            _minColorTransform = new ColorTransform();
            _minColorTransform.color = _minColor;

            _maxColorTransform = new ColorTransform();
            _maxColorTransform.color = _maxColor;

            _tts = new TextToSpeech();

            _kinSence = new KinSence();
            _kinSence.addEventListener( Event.CONNECT, connectHandler );
            _kinSence.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            _kinSence.connect( "127.0.0.1", 3000 );
//            _kinSence.connect( "192.168.1.7", 3000 );

            _handTracking = new HandTrackingModule();
            _handTracking.addEventListener( HandTrackingEvent.HAND_TRACKING_UPDATE, handTrackingUpdateHandler );
            _kinSence.registerModule( _handTracking );

            var audio:Sound = new Sound();
            audio.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
            audio.play();

            colorLayer = new Sprite();
            colorLayer.graphics.beginFill( _maxColor );
            colorLayer.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
            colorLayer.cacheAsBitmap = true;
//            this.addChild( colorLayer );

//            _cloudWidth = stage.stageWidth;
//            _cloudHeight = stage.stageHeight;

            _noiseMap = new BitmapData( _cloudWidth, _cloudHeight * 5, false );
            _noiseMap.perlinNoise( _cloudWidth, _cloudHeight, 16, Math.random() * uint.MAX_VALUE, true, true, 7, true );
            _noiseMap.colorTransform( _noiseMap.rect, new ColorTransform( 1.25, 1.25, 1.25 ) );
//            _noiseMap.colorTransform( _noiseMap.rect, new ColorTransform( 15, 15, 15, 1, 5, 5, 5 ) );
            _noiseMap.draw( _noiseMap, null, null, BlendMode.OVERLAY );

            _cloudMap1 = new BitmapData( _cloudWidth, _cloudHeight, true, 0x00000000 );
            _cloudMap2 = new BitmapData( _cloudWidth, _cloudHeight, true, 0x00000000 );

            _clouds1 = new Bitmap( _cloudMap1, "auto", false );
//            _clouds1.blendMode = BlendMode.ADD;
            _clouds1.width = stage.stageWidth;
            _clouds1.height = stage.stageHeight;
            this.addChild( _clouds1 );

            _clouds2 = new Bitmap( _cloudMap2, "auto", false );
            _clouds2.blendMode = BlendMode.ADD;
            _clouds2.width = stage.stageWidth;
            _clouds2.height = stage.stageHeight;
            this.addChild( _clouds2 );

            fpsText = new TextField();
            fpsText.textColor = 0xffffff;
            this.addChild(fpsText);

            _fpsMeter = new FPSMeter();
            _fpsMeter.startMeasure(false);

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function ioErrorHandler( e:IOErrorEvent ):void
        {
            trace( "connect error" );

            _intensityTarget = 1;
        }


        private function connectHandler( event:Event ):void
        {
            _kinSence.setElevationAngle( 0 );
            _kinSence.setTransformSmooth( true );
            _kinSence.setTransformSmoothParameters( new TransformSmoothParameters( 0.3, 1, 0.5, 0.4, 0.5 ) );

            trace( "connected" );

            _tts.say( "connected to server" );
        }


        private function calcVectorDistance( vector1:KinSenceVector, vector2:KinSenceVector ):Number
        {
            return Math.sqrt(
                Math.pow( vector2.x - vector1.x, 2 ) +
                Math.pow( vector2.y - vector1.y, 2 ) +
                Math.pow( vector2.z - vector1.z, 2 ) );
        }


        private var amplitudePhase:Number = 0;
        private var position:Number = 0;

        private var stepLength:Number = 0.001;
        private var stepRange:Range = new Range( 0.00001, 0.001 );

        private var frequency:Number = 0;
        private var freqRange:Range = new Range( 240, 340 );

        private function sampleDataHandler(e:SampleDataEvent):void
        {
            const AMP_MULTIPLIER:Number = 1;
            const BASE_FREQ:int = 340;
            const SAMPLING_RATE:int = 44100;
            const TWO_PI:Number = 2 * Math.PI;
            const TWO_PI_OVER_SR:Number = TWO_PI / SAMPLING_RATE;

            stepLength = stepRange.getValueFromRelativePos( _intensity );
            frequency = freqRange.getValueFromRelativePos( _intensity );

            var sample:Number;
            for ( var i:int=0; i<4096; i++ )
            {
                var phase:Number = position / 44100 * Math.PI * 2;
                position ++;

//                sample = Math.sin( ( i + e.position ) * TWO_PI_OVER_SR * frequency );
                sample = Math.sin(phase*frequency) - Math.floor(Math.sin(phase*frequency) + 1/2);
//                sample = Math.abs(sample)

                sample += (Math.random()*2-1 ) * 0.25;
                sample = sample * 0.6;

                amplitudePhase = ( amplitudePhase + stepLength ) % 2;
                var amp:Number = ( Math.sin( Math.PI * amplitudePhase ) + 1 ) * 0.5;

                e.data.writeFloat( sample * _intensity * AMP_MULTIPLIER * amp );
                e.data.writeFloat( sample * _intensity * AMP_MULTIPLIER * amp );
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handTrackingUpdateHandler( e:HandTrackingEvent ):void
        {
            if ( e.handSets.length > 0 )
            {
                var handSet:Hands = e.handSets[ 0 ];

                _intensityTarget = _bounds.getRelativePosFromValue( handSet.distanceRatio );
                trace(handSet.distanceRatio);
            }
        }


        private function enterFrameHandler( e:Event ):void
        {
            fpsText.text = _fpsMeter.fps.toString();
            
            _intensity += ( _intensityTarget - _intensity ) / 20;

            _clouds1.alpha = _intensity;
            _clouds2.alpha = _intensity;

            var shiftAmount:Number = Math.floor( _intensity * ( _cloudHeight / 3 ) );
            _cloudsOffset1 = ( _cloudsOffset1 + shiftAmount ) % _noiseMap.height;

            shiftAmount = Math.floor( _intensity * ( _cloudHeight / 2 ) );
            _cloudsOffset2 = ( _cloudsOffset2 + shiftAmount ) % _noiseMap.height;

            drawToBitmapData( _cloudMap1, _maxColor, _cloudsOffset1 );
            drawToBitmapData( _cloudMap2, _maxColor, _cloudsOffset2 );
        }


        private function drawToBitmapData( bitmapData:BitmapData, color:uint, offset:uint ):void
        {
            var zeroPoint:Point = new Point();

            var wrapAmount:Number = ( offset > _noiseMap.height - _cloudHeight ) ? offset + _cloudHeight - _noiseMap.height : 0;

            bitmapData.fillRect( bitmapData.rect, color );
            bitmapData.copyChannel( _noiseMap, new Rectangle(0, offset, _cloudWidth, _cloudHeight - wrapAmount ), zeroPoint, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA );

            if ( wrapAmount != 0 )
            {
                bitmapData.copyChannel( _noiseMap, new Rectangle(0, 0, _cloudWidth, wrapAmount ), new Point( 0, _cloudHeight - wrapAmount ), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA );
            }
        }

    }

}