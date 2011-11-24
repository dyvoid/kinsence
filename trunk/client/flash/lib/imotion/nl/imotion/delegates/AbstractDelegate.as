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

package nl.imotion.delegates
{
    import nl.imotion.delegates.IResponder;


    /**
	 * @author Pieter van de Sluis
	 * Based on code by Thomas Reppa (www.reppa.net)
	 */
	public class AbstractDelegate implements IDelegate
	{

        // ____________________________________________________________________________________________________
        // PROPERTIES

		private var _operationName	:String;
		private var _requestData    :*;
        private var _responder:IResponder;

        protected static var defaultResponder	:IResponder;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

		public function AbstractDelegate( operationName:String = null, requestData:* = null, responder:IResponder = null )
		{
			_operationName 	= operationName;
			_requestData    = requestData;
            _responder      = responder;
		}

        // ____________________________________________________________________________________________________
        // PUBLIC
		
		public function execute():void
		{
			// override in subclass
		}

        public static function setDefaultResponder( responder:IResponder ):void
		{
			defaultResponder = responder;
		}

        public function reset():void
        {
            _operationName = null;
            _requestData = null;
            _responder = null;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get operationName():String { return _operationName; }
		public function set operationName( value:String ):void
		{
			_operationName = value;
		}


		public function get requestData():* { return _requestData; }
		public function set requestData( value:* ):void
		{
			_requestData = value;
		}


        public function get responder():IResponder
		{
			return ( _responder == null ) ? defaultResponder : _responder;
		}
		public function set responder( value:IResponder ):void
		{
			_responder = value;
		}

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


		
	}
	
}