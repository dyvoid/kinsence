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
	/**
	 * @author Pieter van de Sluis
	 */
	public class ValidatorGroup implements IValidator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validators		:/*IValidator*/Array = [];
		private var _operatorMethod :String = ValidatorGroupOperator.AND;
        
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function ValidatorGroup() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function addValidator( validator:Validator ):Validator
		{
			_validators.push( validator );
			
			return validator;
		}
		
		
		public function removeValidator( validator:Validator ):Validator
		{
			for ( var i:int = _validators.length - 1; i >= 0; i-- ) 
			{
				if ( _validators[ i ] == validator )
				{
					return _validators.splice( i, 1 )[ 0 ];
				}
			}
			
			return null;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get isValid():Boolean
		{
			var __isValid:Boolean = ( _operatorMethod != ValidatorGroupOperator.OR );
			
			for ( var i:int = 0; i < _validators.length; i++ ) 
			{
				var validatorIsValid:Boolean = _validators[ i ].isValid;
				
				switch( _operatorMethod )
				{
					case ValidatorGroupOperator.AND:
						if ( !validatorIsValid )
							return false;
					break;
					
					case ValidatorGroupOperator.OR:
						__isValid = __isValid || validatorIsValid;
					break;
				}
			}
			
			return __isValid;
		}
		
		
		public function get errors():/*ValidatorError*/Array
		{
			var errors:/*ValidatorError*/Array = [];
			
			if ( !isValid )
			{
				for ( var i:int = 0; i < _validators.length; i++ ) 
				{
					errors = errors.concat( _validators[ i ].errors );
				}
			}
			
			return errors;
		}
		
		
		public function get operatorMethod():String { return _operatorMethod; }
		
		public function set operatorMethod( value:String ):void 
		{
			_operatorMethod = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
	}

}