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

package nl.imotion.burst.parsers
{

    internal class BurstXMLMapping
    {
        private var _type:String;
        private var _itemName:String;
        private var _targetClass:Class;
        private var _defaultValue:String;
        private var _allowedValues:Array;

        public function BurstXMLMapping( type:String, itemName:String, targetClass:Class, defaultValue:String = null, allowedValues:Array = null ):void
        {
            if ( type != BurstXMLMappingType.ATTRIBUTE && type != BurstXMLMappingType.NODE )
                throw new Error( "Invalid BurstXMLMapping type.");

            _type = type;
            _itemName = itemName;
            _targetClass = targetClass;
            _defaultValue = defaultValue;
            _allowedValues = allowedValues;
        }

        public function get type():String { return _type; }

        public function get itemName():String { return _itemName; }

        public function get targetClass():Class { return _targetClass; }

        public function get defaultValue():String { return _defaultValue; }

        public function get allowedValues():Array { return _allowedValues; }

    }
	
}