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
    public class Exercise
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _patterns			:Array = [];

        private var _maxEpochs			:uint;
        private var _maxError   		:Number;

        private var _useAsync           :Boolean = true;

        private var _index				:uint = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Exercise( maxEpochs:uint = 0, maxError:Number = 0, useAsync:Boolean = true )
        {
            _maxEpochs		= maxEpochs;
            _maxError		= maxError;
            _useAsync       = useAsync
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addPatterns( inputPattern:Array, targetPattern:Array ):void
        {
            _patterns.push( new ExercisePatterns( inputPattern, targetPattern ) );
        }


        public function next():ExercisePatterns
        {
            return _patterns[ _index++ ];
        }


        public function reset():void
        {
            _index = 0;
        }


        public function hasNext():Boolean
        {
            return ( _index < _patterns.length );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get maxEpochs():uint { return _maxEpochs; }
        public function set maxEpochs(value:uint):void
        {
            _maxEpochs = value;
        }

        public function get maxError():Number { return _maxError; }
        public function set maxError(value:Number):void
        {
            _maxError = value;
        }

        public function get useAsync():Boolean { return _useAsync; }
        public function set useAsync( value:Boolean ):void
        {
            _useAsync = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }

}