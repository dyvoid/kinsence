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

package nl.imotion.utils.range
{
	
	/**
	 * The <code>Range</code> class allows calculations on values within a range and translation to other ranges
	 * @author Pieter van de Sluis
	 */
	public class Range
	{
		private var _boundary1		:Number;
		private var _boundary2		:Number;
		
		
		/**
		 * Translates a value within a range to a value in a target range.
		 * The input value is automatically constrained to the boundaries of the source range.
		 * @param	value the value that is to be translated
		 * @param	sourceBoundary1 the first boundary value of the source range
		 * @param	sourceBoundary2 the second boundary value of the source range
		 * @param	targetBoundary1 the first boundary value of the target range
		 * @param	targetBoundary2 the second boundary value of the target range
		 * @return	the translated value
		 */
		public static function translateValue( value:Number, sourceBoundary1:Number, sourceBoundary2:Number, targetBoundary1:Number = 0, targetBoundary2:Number = 1 ):Number
		{
			return new Range( sourceBoundary1, sourceBoundary2 ).translate( value, new Range( targetBoundary1, targetBoundary2 ) );
		}
		
		
		/**
		 * Constructs a new <code>Range</code>
		 * @param	boundary1 the first boundary value of the range
		 * @param	boundary2 the second boundary value of the range
		 */
		public function Range( boundary1:Number, boundary2:Number )
		{
			_boundary1 = boundary1;
			_boundary2 = boundary2;
		}
		
		
		/**
		 * Translates a value in the range to a relative position (0-1).
		 * The input value is automatically constrained to the boundaries of the range.
		 * @param	value a value within the range
		 * @return	the relative position within the range
		 */
		public function getRelativePosFromValue( value:Number ):Number
		{
			value = constrain( value );
			
			return Math.abs( value - _boundary1 ) / rangeSize;
		}
		
		
		/**
		 * Translates a relative position (0-1) to a value within the range.
		 * The input value is automatically constrained to 0-1.
		 * @param	relativePos the relative position
		 * @return	the value within the range
		 */
		public function getValueFromRelativePos( relativePos:Number ):Number
		{
			relativePos = constrainTo( relativePos, 0, 1 );
			
			var result	:Number;
			
			if ( _boundary2 > _boundary1 )
			{
				result	= _boundary1 + ( relativePos * rangeSize );
			}
			else
			{
				result	= _boundary1 - ( relativePos * rangeSize );
			}
			
			return result;
		}
		
		
		/**
		 * Translates a value within this range to a value in a target range
		 * @param	value a value within the boundaries of this range
		 * @param	targetRange the target range that the value should be translated to
		 * @return	the translated value
		 */
		public function translate( value:Number, targetRange:Range ):Number
		{
			return targetRange.getValueFromRelativePos( getRelativePosFromValue( value ) );
		}
		
		
		/**
		 * Constrains a value to the boundaries of the range
		 * @param	value the value that should be constrained
		 * @return	the constrained value
		 */
		public function constrain( value:Number ):Number
		{
			if ( _boundary2 > _boundary1 )
			{
				return constrainTo( value, _boundary1, _boundary2 );
			}
			else
			{
				return constrainTo( value, _boundary2, _boundary1 );
			}
		}
		
		
		/**
		 * Constrains a value to an upper and lower limit
		 * @param	value the value that should be constrained
		 * @param	lower the lower limit
		 * @param	upper the upper limit
		 * @return	the constrained value
		 */
		private function constrainTo( value:Number, lower:Number, upper:Number ):Number
		{
			if (value > upper) return upper;
			if (value < lower) return lower;
			return value;
		}
		
		
		/**
		 * The total size of the range
		 */
		public function get rangeSize():Number
		{
			var c:Number = (_boundary2 - _boundary1);
			return c > 0 ? c : -c;
		}
		
		
		/**
		 * The first boundary of the range
		 */
		public function get boundary1():Number { return _boundary1; }
		public function set boundary1( value:Number ):void
		{
			_boundary1 = value;
		}
		
		
		/**
		 * The second boundary of the range
		 */
		public function get boundary2():Number { return _boundary2; }
		public function set boundary2( value:Number ):void
		{
			_boundary2 = value;
		}

	}
}