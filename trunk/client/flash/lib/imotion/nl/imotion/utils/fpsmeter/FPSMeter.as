/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2011 Pieter van de Sluis
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
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.utils.fpsmeter
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;


    /**
	 * @author Pieter van de Sluis
	 */

    [Event(name="FPSMeterEvent::MEASURE_COMPLETE", type="nl.imotion.utils.fpsmeter.FPSMeterEvent")]

	public class FPSMeter extends EventDispatcher
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _framerateClip		:Sprite;
		
		private var _timeList			:Array = [];
		private var _fpsList			:Array = [];
		
		private var _fps				:uint;
		private var _numMeasurements	:uint;
		
		private var _lastTime			:Number;
		
		private var _autoStop			:Boolean = false;
		private var _isStarted			:Boolean = false;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function FPSMeter( numMeasurements:uint = 15 ) 
		{
			_numMeasurements = numMeasurements;
			
			_framerateClip = new Sprite();
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function startMeasure( autoStop:Boolean = true ):void
		{
			_autoStop  = autoStop;
			
			if ( !_isStarted )
			{
				_isStarted = true;
				
				_lastTime = getTimer();	
				
				_framerateClip.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			}
		}
		
		
		public function stopMeasure():void
		{
			if ( _isStarted )
			{
				_isStarted = false;
				
				_timeList = [];
				_fpsList  = [];
				_lastTime = NaN;
				
				_framerateClip.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		private function calcFPS():void
		{
			var newTime:uint = getTimer();
			
			var listLength:uint = _timeList.length;
			_timeList[ listLength++ ] = newTime - _lastTime;
			
			var diff:int = listLength - _numMeasurements;
			if ( diff > 0 )
			{
				_timeList.splice( 0, diff );
				listLength = _timeList.length;
			}
			
			var totalTime:uint = 0;
			for ( var i:int = 0; i < listLength; i++ ) 
			{
				totalTime += _timeList[ i ];
			}
			_fps = Math.round( 1000 / ( totalTime / listLength ) );
			
			_lastTime = newTime;
			
			if ( _autoStop )
			{
				checkStableFPS();
			}
		}
		
		
		private function checkStableFPS():void
		{
			var fpsListLength:uint = _fpsList.length;
			_fpsList[ fpsListLength++ ] = _fps;
			
			var fpsDiff:int = fpsListLength - _numMeasurements;
			if ( fpsDiff > 0 )
			{
				_fpsList.splice( 0, fpsDiff );
				fpsListLength = _fpsList.length;
			}
			
			if ( fpsListLength == _numMeasurements )
			{
				var fpsCheck:uint = _fpsList[ 0 ];
				var fpsIsStable	:Boolean = true;
				
				for ( var j:int = 1; j < fpsListLength; j++ ) 
				{
					if ( _fpsList[ j ] != fpsCheck )
					{
						fpsIsStable = false;
						break;
					}
				}
				if ( fpsIsStable )
				{
					stopMeasure();

                    dispatchEvent( new FPSMeterEvent( FPSMeterEvent.MEASURE_COMPLETE, _fps ) );
				}
			}
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get fps():uint { return _fps; }
		
		public function get numMeasurements():uint { return _numMeasurements; }
		public function set numMeasurements( value:uint ):void 
		{
			if ( value > 0 )
			{
				_numMeasurements = value;
			}
		}
		
		public function get isStarted():Boolean { return _isStarted; }
		
		public function get autoStop():Boolean { return _autoStop; }
		public function set autoStop( value:Boolean ):void 
		{
			if ( _autoStop != value )
			{
				_autoStop = value;
			
				_fpsList = [];
			}
		}
		
		public function get timePerFrame():uint
		{
			if ( _fps != 0 )
			{
				return int( 1000 / _fps );
			}
			
			return 0;
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function enterFrameHandler( e:Event ):void
		{
			calcFPS();
		}
		
	}

}