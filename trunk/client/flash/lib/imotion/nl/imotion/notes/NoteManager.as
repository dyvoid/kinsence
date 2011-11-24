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

package nl.imotion.notes
{
    import flash.utils.Dictionary;


    /**
	 * @author Pieter van de Sluis
	 */
	public class NoteManager 
	{
		private var listeners:Dictionary = new Dictionary();
		
		
		public function NoteManager() { }
		
		
		public function registerListener( type:String, listener:Function ):void
		{
			noteDispatcher.addNoteListener( type, listener );
			
			listeners[ type ] = listener;
		}
		
		
		public function removeListener( type:String, listener:Function ):void
		{
			var f:Function = listeners[ type ];
			
			if ( f != null && f == listener )
			{
				noteDispatcher.removeNoteListener( type, listener );
				
				delete listeners[ type ];
			}
		}
		
		
		public function removeAllListeners():void
		{
			for ( var type:String in listeners ) 
			{
				removeListener( type, listeners[ type ] );
			}
		}
		
		
		private function get noteDispatcher():NoteDispatcher
		{
			return NoteDispatcher.getInstance();
		}
	}
	
}