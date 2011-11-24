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

package nl.imotion.events
{
    import flash.events.IEventDispatcher;


    final internal class EventListener
	{
		private var _target:IEventDispatcher;
		private var _type:String;
		private var _listener:Function;
		private var _useCapture			:Boolean;
		
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
		
		public function EventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false )
		{
            _target 			= target;
			_type 				= type;
			_listener			= listener;
			_useCapture			= useCapture;
		}
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                G E T T E R S / S E T T E R S     |
        //__________________________________________________________________________________________________________________|
		
		public function get target():IEventDispatcher { return _target; }
		
		public function get type():String { return _type; }
		
		public function get listener():Function { return _listener; }
		
		public function get useCapture():Boolean { return _useCapture; }
		
		public function equals( eventListener:EventListener ):Boolean
		{
			return ( eventListener.target == _target && eventListener.type == _type && eventListener.listener == _listener && eventListener.useCapture == _useCapture );
		}
	}
}