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
    import flash.events.Event;


    /**
	 * @author Pieter van de Sluis
	 */
	public class DataEvent extends Event 
	{
		private var _data:Object;
		
		
		public function DataEvent( type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false ) 
		{ 
			super( type, bubbles, cancelable );
			
			_data = data;			
		} 
		
		
		public override function clone():Event 
		{ 
			return new DataEvent( type, data, bubbles, cancelable );
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString( "DataEvent", "type", "data", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		
		public function get data():Object { return _data; }
		
	}
	
}