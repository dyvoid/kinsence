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

package nl.imotion.utils.asyncprocessor
{
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import flash.utils.getTimer;

    import nl.imotion.utils.fpsmeter.FPSMeter;
    import nl.imotion.utils.fpsmeter.FPSMeterEvent;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="AsyncProcessorEvent::FPS_MEASURE_START", type="nl.imotion.utils.asyncprocessor.AsyncProcessorEvent")]
    [Event(name="AsyncProcessorEvent::FPS_MEASURE_COMPLETE", type="nl.imotion.utils.asyncprocessor.AsyncProcessorEvent")]

    public class AsyncProcessor extends EventDispatcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _priority               :Number = 1;

        private var _totalTimeAllocation    :Number = 0;
        private var _timeError              :Number = 0;

        private var _processTimer           :Timer;

        private var _fps                    :uint;
        private var _fpsMeter               :FPSMeter;

        private var _processes              :Vector.<Function>;

        private var _isReady                :Boolean = false;
        private var _isRunning              :Boolean = false;
        private var _isMeasuringFPS         :Boolean = false;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AsyncProcessor( priority:Number = 1, fps:uint = 0 )
        {
            init( priority, fps );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addProcess( process:Function ):void
        {
            var numProcesses:uint = _processes.length;

            for ( var i:int = 0; i < numProcesses; i++ )
            {
                if ( _processes[ i ] == process )
                    return;
            }

            _processes.push( process );
        }


        public function removeProcess( process:Function ):void
        {
            var numProcesses:uint = _processes.length;

            for ( var i:int = 0; i < numProcesses; i++ )
            {
                if ( _processes[ i ] == process )
                {
                    _processes.splice( i, 1 );
                    return;
                }
            }
        }


        public function removeAllProcesses():void
        {
            _processes.length = 0;
            stop();
        }


        public function start():void
        {
            if ( _isRunning ) return;

            _isRunning = true;
            _processTimer.addEventListener( TimerEvent.TIMER, processTimerTickHandler );
            _processTimer.start();
        }


        public function stop():void
        {
            if ( !_isRunning ) return;

            _isRunning = false;
            _processTimer.removeEventListener( TimerEvent.TIMER, processTimerTickHandler );
            _processTimer.stop();
            _timeError = 0;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init( priority:Number, fps:int = -1 ):void
        {
            _priority = priority;
            _fps = fps;

            _processes = new Vector.<Function>();
            _processTimer = new Timer( 0 );

            if ( _fps != 0 )
            {
                updateAllocation();
            }
            else
            {
                startFPSMeasurement();
            }
        }


        private function updateAllocation():void
        {
            var timePerFrame:Number = 1000 / _fps;

            _processTimer.delay  = timePerFrame;
            _totalTimeAllocation = timePerFrame * _priority;

            _isReady = true;
        }


        private function process():void
        {
            var startTime:int = getTimer();

            if ( _timeError < _totalTimeAllocation )
            {
                var numProcesses:uint = _processes.length;
                var processTimeAllocation:Number = ( _totalTimeAllocation - _timeError ) / numProcesses;

                for ( var i:int = 0; i < numProcesses; i++ )
                {
                    var processStartTime:int = getTimer();

                    do
                    {
                        if ( !_isRunning )
                        {
                            // The AsyncProcessor has been stopped while processing
                            return;
                        }

                        _processes[ i ]();
                    }
                    while ( ( getTimer() - processStartTime ) < processTimeAllocation );
                }
            }

            _timeError += ( getTimer() - startTime ) - _totalTimeAllocation;
            if ( _timeError < 0 )
                _timeError = 0;
        }


        private function startFPSMeasurement():void
        {
            _fpsMeter = new FPSMeter( 30 );
            _fpsMeter.addEventListener( FPSMeterEvent.MEASURE_COMPLETE, fpsMeasureCompleteHandler );
            _fpsMeter.startMeasure();
            
            _isMeasuringFPS = true;

            dispatchEvent( new AsyncProcessorEvent( AsyncProcessorEvent.FPS_MEASURE_START ) );
        }
        

        private function endFPSMeasurement():void
        {
            _fpsMeter.stopMeasure();
            _fpsMeter.removeEventListener( FPSMeterEvent.MEASURE_COMPLETE, fpsMeasureCompleteHandler );
            _fpsMeter = null;

            _isMeasuringFPS = false;

            dispatchEvent( new AsyncProcessorEvent( AsyncProcessorEvent.FPS_MEASURE_COMPLETE ) );

            if ( _isRunning )
                _processTimer.start();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get isRunning():Boolean
        {
            return _isRunning;
        }


        public function get isReady():Boolean
        {
            return _isReady;
        }


        public function get fps():uint { return _fps; }
        public function set fps( value:uint ):void
        {
            if ( _fps == value || value == 0 ) return;

            _fps = value;
            updateAllocation();

            if ( _isMeasuringFPS )
                endFPSMeasurement();
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function fpsMeasureCompleteHandler( e:FPSMeterEvent ):void
        {
            if ( e.fps == 0 )
            {
                _fpsMeter.startMeasure();
                return;
            }

            _fps = e.fps;
            updateAllocation();
            endFPSMeasurement();
        }

        private function processTimerTickHandler( e:TimerEvent ):void
        {
            if ( _isReady )
                process();
        }

    }
    
}