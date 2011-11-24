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

package nl.imotion.evo.genes
{
    import flash.sampler._getInvocationCount;


    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:29:02
     */
    public class IntGene extends Gene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _minVal:int;
        private var _maxVal:int;

        private var _totalRange:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function IntGene( propName:String, minVal:int, maxVal:int, mutationEffect:Number = 1, limitMethod:String = "bounce", baseValue:Number = NaN ):void
        {
            _minVal = minVal;
            _maxVal = maxVal;

            updateTotalRange();

            super( propName, mutationEffect, limitMethod, baseValue );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function getPropValue():*
        {
            var n:Number = baseValue * _totalRange;
            //Optimized Math.floor()
            var ni:int = n;
            ni = ( n < 0 && n != ni ) ? ni - 1 : ni;

            return _minVal + ni;
        }


        override public function clone():Gene
        {
            return new IntGene( propName, _minVal, _maxVal, mutationEffect, limitMethod, baseValue );
        }


        override public function toXML():XML
        {
            var xml:XML = super.toXML();

            xml[ "@type" ]      = "int";
            xml[ "@minVal" ]    = minVal;
            xml[ "@maxVal" ]    = maxVal;

            return xml;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function updateTotalRange():void
        {
            _totalRange = _maxVal + 0.999999999999998 - _minVal;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get minVal():int
        {
            return _minVal;
        }


        public function set minVal( value:int ):void
        {
            _minVal = value;
            updateTotalRange();
        }


        public function get maxVal():int
        {
            return _maxVal;
        }


        public function set maxVal( value:int ):void
        {
            _maxVal = value;
            updateTotalRange();
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}