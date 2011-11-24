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
    import flash.text.TextField;

    import nl.imotion.forms.IFormElement;


    /**
	 * @author Pieter van de Sluis
	 */
	public class Validator implements IValidator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _target					:*;
		private var _defaultErrorMessage	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Validator() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC		
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS		
		
		public function get isValid():Boolean
		{
			return true;
		}
		
		
		public function get errors():/*ValidatorError*/Array
		{
			if ( _defaultErrorMessage && !isValid )
			{
				return [ new ValidatorError( this, _defaultErrorMessage ) ];
			}
			else
			{
				return [ ];
			}
		}
		
		
		public function get target():* { return _target; }
		
		public function set target( value:* ):void 
		{
			_target = value;
		}
		
		
		public function get defaultErrorMessage():String { return _defaultErrorMessage; }
		
		public function set defaultErrorMessage(value:String):void 
		{
			_defaultErrorMessage = value;
		}
		
		
		protected function get value():*
		{
			if ( _target )
			{
				switch ( true )
				{
					case _target is IFormElement:
						return IFormElement( _target ).value;
					
					case _target is TextField:
						return TextField( _target ).text;
						
					default:
						return _target;
				}
			}
			else
			{
				throw new Error( "target has not been set");
			}
		}
		
	}

}