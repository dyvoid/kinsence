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

package nl.imotion.neuralnetwork.training
{


    /**
     * @author Pieter van de Sluis
     */
    public class TrainingResult
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _startError		:Number;
        private var _endError		:Number;
        private var _epochs			:uint;
        private var _trainingTime   :uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TrainingResult( startError:Number = NaN, endError:Number = NaN, epochs:uint = 0, trainingTime:uint = 0 ):void
        {
            _startError 	= startError;
            _endError		= endError;
            _epochs 		= epochs;
            _trainingTime   = trainingTime;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get startError():Number { return _startError; }
        public function set startError( value:Number ):void
        {
            _startError = value;
        }

        public function get endError():Number { return _endError; }
        public function set endError( value:Number ):void
        {
            _endError = value;
        }

        public function get errorChange():Number
        {
            if ( !isNaN( _startError ) && !isNaN( _endError ) )
            {
                return _endError - _startError;
            }
            return 0;
        }

        public function get epochs():uint { return _epochs; }
        public function set epochs( value:uint ):void
        {
            _epochs = value;
        }


        public function get trainingTime():uint { return _trainingTime; }
        public function set trainingTime( value:uint ):void
        {
            _trainingTime = value;
        }
    }

}