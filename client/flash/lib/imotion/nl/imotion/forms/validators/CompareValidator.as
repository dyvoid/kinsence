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

package nl.imotion.forms.validators
{
    import nl.imotion.forms.IFormElement;


    /**
	 * @author Pieter van de Sluis
	 */
	public class CompareValidator extends Validator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _compare	:*;
		private var _compareTo	:*;
		private var _operator	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function CompareValidator( compare:*, compareTo:*, operator:String = "==" ) 
		{
			_compare	= compare;
			_compareTo	= compareTo;
			_operator 	= operator;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		override public function get isValid():Boolean 
		{
			var compareValue:*   = ( _compare   is IFormElement ) ? IFormElement( _compare   ).value : _compare;
			var compareToValue:* = ( _compareTo is IFormElement ) ? IFormElement( _compareTo ).value : _compareTo;
			
			switch( _operator )
			{
				case "==":
					return compareValue == compareToValue;
					
				case "!=":
					return compareValue != compareToValue;
					
				case "<":
					return compareValue <  compareToValue;
					
				case ">":
					return compareValue >  compareToValue;
					
				case "<=":
					return compareValue <= compareToValue;
					
				case ">=":
					return compareValue >= compareToValue;
			}
			
			return false;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get compare():* { return _compare; }
		
		public function set compare(value:*):void 
		{
			_compare = value;
		}
		
		public function get compareTo():* { return _compareTo; }
		
		public function set compareTo(value:*):void 
		{
			_compareTo = value;
		}
		
		public function get operator():String { return _operator; }
		
		public function set operator(value:String):void 
		{
			_operator = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
	}

}