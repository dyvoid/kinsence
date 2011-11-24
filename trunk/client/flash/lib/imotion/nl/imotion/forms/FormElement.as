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

package nl.imotion.forms
{
    import nl.imotion.forms.validators.IValidator;
    import nl.imotion.forms.validators.Validator;
    import nl.imotion.forms.validators.ValidatorGroup;
    import nl.imotion.forms.validators.ValidatorGroupOperator;


    /**
	 * @author Pieter van de Sluis
	 */
	public class FormElement implements IFormElement
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validatorGroup		:ValidatorGroup		= new ValidatorGroup();
		
		private var _value:String = "";
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function FormElement() 
		{
			_validatorGroup.operatorMethod = ValidatorGroupOperator.AND;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function validate():Boolean
        {
            return changeValidState( isValid );
        }
		
		
		public function changeValidState( isValid:Boolean ):Boolean
		{
			// override in subclass
			
			return isValid;
		}
		
		
		public function addValidator( validator:Validator ):IValidator
		{
			validator.target = this;
			
			return _validatorGroup.addValidator( validator );
		}
		
		
		public function removeValidator( validator:Validator ):IValidator
		{
			validator = _validatorGroup.removeValidator( validator );
			
			if ( validator )
				validator.target = null;
			
			return validator;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		// public
		
		public function get value():* { return _value; }
		
		public function set value( value:* ):void
		{
			_value = value;
		}
		
		
		public function get isValid():Boolean
        {
            return _validatorGroup.isValid;
        }
		
		
		public function get errors():/*ValidatorError*/Array
		{
			return _validatorGroup.errors;
		}
		
		public function get validatorGroup():ValidatorGroup { return _validatorGroup; }
		
		public function set validatorGroup( value:ValidatorGroup ):void 
		{
			_validatorGroup = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}