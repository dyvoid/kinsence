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
    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:32:52
     */
    public class NumberGene extends Gene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _minVal:Number;
        private var _maxVal:Number;

        private var _totalRange:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function NumberGene( propName:String, minVal:Number, maxVal:Number, mutationEffect:Number = 1, limitMethod:String = "bounce", baseValue:Number = NaN ):void
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
            return _minVal + baseValue * _totalRange;
        }


        override public function clone():Gene
        {
            return new NumberGene( propName, _minVal, _maxVal, mutationEffect, limitMethod, baseValue );
        }


        override public function toXML():XML
        {
            var xml:XML = super.toXML();
            
            xml[ "@type" ]      = "Number";
            xml[ "@minVal" ]    = minVal.toPrecision( 21 );
            xml[ "@maxVal" ]    = maxVal.toPrecision( 21 );

            return xml;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function updateTotalRange():void
        {
            _totalRange = _maxVal  - _minVal;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        public function get minVal():Number
        {
            return _minVal;
        }


        public function set minVal( value:Number ):void
        {
            _minVal = value;
            updateTotalRange();
        }


        public function get maxVal():Number
        {
            return _maxVal;
        }


        public function set maxVal( value:Number ):void
        {
            _maxVal = value;
            updateTotalRange();
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}