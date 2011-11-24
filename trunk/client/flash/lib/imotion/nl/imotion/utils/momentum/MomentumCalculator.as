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

package nl.imotion.utils.momentum
{


    /**
     * @author Pieter van de Sluis
     * Date: 22-sep-2010
     * Time: 20:06:05
     */
    public class MomentumCalculator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _samples        :Array = [];
        private var _maxNumSamples  :uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MomentumCalculator( maxNumSamples:uint = 5 )
        {
            _maxNumSamples = maxNumSamples;
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addSample( sample:Number ):void
        {
            var numSamples:uint = numSamples;

            _samples[ numSamples ] = sample;

            var diff:int = _maxNumSamples - ( numSamples + 1 );
            
            if ( diff < 0 )
            {
                _samples.splice( 0, Math.abs( diff ) );
            }
        }


        public function reset():void
        {
            _samples = [];
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get momentum():Number
        {
            var numSamples:uint = numSamples;

            if ( numSamples == 1 )
            {
                return _samples[ 0 ];
            }
            else if ( numSamples > 0 )
            {
                var momentum:Number = 0;

                for ( var i:int = 0; i < numSamples - 1; i++ )
                {
                    momentum += _samples[ i + 1 ] - _samples[ i ];
                }
                
                return momentum;
            }

            return NaN;
        }


        public function get numSamples():uint
        {
            return _samples.length;    
        }


        public function get isReady():Boolean
        {
            return ( _samples.length == _maxNumSamples );
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}