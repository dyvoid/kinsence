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
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;

    import nl.imotion.forms.validators.IValidator;
    import nl.imotion.forms.validators.Validator;
    import nl.imotion.forms.validators.ValidatorError;
    import nl.imotion.forms.validators.ValidatorGroup;
    import nl.imotion.utils.reflector.AccessType;
    import nl.imotion.utils.reflector.PropertyDefinition;
    import nl.imotion.utils.reflector.Reflector;


    public class Form implements IFormElement
    {
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
        private var _elements           :Dictionary 		= new Dictionary();
		private var _validatorGroup		:ValidatorGroup		= new ValidatorGroup();
        
        private var _numElements        :uint = 0;
        private var _autoTabIndex       :Boolean = true;
        
        private var _valueObjectClass   :Class;
		
        // ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
        public function Form( valueObjectClass:Class = null, autoTabIndex:Boolean = true ) 
        {
            _valueObjectClass   = ( valueObjectClass ) ? valueObjectClass : Object;
            _autoTabIndex       = autoTabIndex;
        }
        
		// ____________________________________________________________________________________________________
		// PUBLIC
		
        public function registerElement( element:IFormElement, elementName:String ):IFormElement
		{
			_elements[ elementName ] = element;
            
            if ( _autoTabIndex && element is InteractiveObject )
                InteractiveObject( element ).tabIndex = _numElements;
                
			_numElements++;
            
            return element;
		}
        
        
        public function removeElement( elementName:String ):IFormElement
        {
            var element:IFormElement = retrieveElement( elementName );
			
			if ( element )
			{
				delete _elements[ elementName ];
                _numElements--;
				return element;
			}
			return null;
        }
        
        
        public function retrieveElement( elementName:String ):IFormElement
        {
            return _elements[ elementName ];
        }
        
		
		public function addValidator( validator:Validator ):IValidator
		{
			return _validatorGroup.addValidator( validator );
		}
		
		
		public function removeValidator( validator:Validator ):IValidator
		{
			return _validatorGroup.removeValidator( validator );
		}
		
		
		public function validate():Boolean
        {
            var formIsValid:Boolean = true;
            
            for each ( var element:IFormElement in _elements )
            {
                if ( !element.validate() && formIsValid )
                    formIsValid = false;
            }
            
			if ( formIsValid )
				formIsValid = _validatorGroup.isValid;
			
            return formIsValid;
        }
		
        
        public function getValidElements():/*IFormElement*/Array
        {
            return getElementsByValidState( true );
        }
        
        
        public function getInvalidElements():/*IFormElement*/Array
        {
            return getElementsByValidState( false );
        }
        
        
        public function populate( object:Object ):Object
        {
            for ( var elementName:String in _elements ) 
            {
                try 
                {
                    object[ elementName ] = IFormElement( _elements[ elementName ] ).value;
                }
                catch ( e:Error )
                {
                    //throw new Error( "Object property is incompatible with IFormElement value" ); 
                }
            }
            
            return object;
        }     
        
        
        public function destroy():void
        {
            _elements       = new Dictionary();
			_validatorGroup		= new ValidatorGroup();
            _numElements    = 0;
        }
        
        
        public function changeValidState( isValid:Boolean ):Boolean
        {
            return isValid;
        }
        
        // ____________________________________________________________________________________________________
		// GETTERS/SETTERS
		
		// public
		
        public function get value():*
        {
            return populate( new _valueObjectClass() );
        }
        
		
        public function set value( value:* ):void
        {
            var props:/*PropertyDefinition*/Array = Reflector.getProperties( value, AccessType.READ );
            
            for ( var i:int = 0; i < props.length; i++ ) 
            {
                var prop:PropertyDefinition = props[ i ] as PropertyDefinition;
                var element:IFormElement = IFormElement( _elements[ prop.name ] );
                
                if ( element )
                {
					try 
					{
						element.value = value[ prop.name ];
					}
					catch ( e:Error )
					{
						throw new Error( "IFormElement value is incompatible with Object property value" ); 
					}
                }
            }
        }
        
        
        public function get isValid():Boolean
        {
            for each ( var element:IFormElement in _elements )
            {				
                if ( !element.isValid )
                    return false;
            }
			
            return _validatorGroup.isValid;
        }
        
		
		public function get errors():/*ValidatorError*/Array
		{
			var errors:/*ValidatorError*/Array = [];

			for each ( var element:IFormElement in _elements )
			{
				errors = errors.concat( element.errors );
			}
			
			errors = errors.concat( _validatorGroup.errors );
			
			for ( var i:int = errors.length - 1; i > 0; i-- ) 
			{
				for (var j:int = 0; j < i; j++) 
				{
					if ( errors[ i ].isEqual( errors[ j ] ) )
					{
						errors.splice( i, 1 );
							break;
					}
				}
			}
			
			return errors;
		}
        
        public function get numElements():uint { return _numElements; }
        
        public function get autoTabIndex():Boolean { return _autoTabIndex; }
        
        public function set autoTabIndex(value:Boolean):void 
        {
            _autoTabIndex = value;
        }
        
        public function get valueObjectClass():Class { return _valueObjectClass; }
        
        public function set valueObjectClass(value:Class):void 
        {
            _valueObjectClass = value;
        }
		
		
		// protected
		
		protected function get elements():Dictionary { return _elements; }
		
		protected function set elements(value:Dictionary):void 
		{
			_elements = value;
		}
		
		protected function get validatorGroup():ValidatorGroup { return _validatorGroup; }
		
		protected function set validatorGroup(value:ValidatorGroup):void 
		{
			_validatorGroup = value;
		}
		
        // ____________________________________________________________________________________________________
		// PROTECTED
		
        protected function getElementsByValidState( validState:Boolean ):/*IFormElement*/Array
        {
            var result:/*IFormElement*/Array = [];
            
            for each ( var element:IFormElement in _elements ) 
            {
                if ( element.isValid == validState )
                    result[ result.length ] = element
            }
            
            return result;
        }
        
        
    }
	
}