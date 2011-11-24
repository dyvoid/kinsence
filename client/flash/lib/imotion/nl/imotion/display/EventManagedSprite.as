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

package nl.imotion.display
{

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import nl.imotion.events.EventManager;


    public class EventManagedSprite extends Sprite implements IEventManagedDisplayObject
	{	
		
		public function EventManagedSprite( autoDestroy:Boolean = true ) 
		{
			if ( autoDestroy )
			{
				startEventInterest( this, Event.REMOVED_FROM_STAGE, removedFromStageHandler );
			}
		}
		
		
		private function removedFromStageHandler( e:Event ):void
		{
			destroy();
		}
		
		
		private var _eventManager:EventManager;
		protected function get eventManager():EventManager
		{
			if ( !_eventManager ) _eventManager = new EventManager();
			return _eventManager;
		}
		
		
		protected function startEventInterest( target:*, type:*, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			var targets	:Array = new Array().concat( target );
			var types	:Array = new Array().concat( type );
			
			for each ( var currTarget:IEventDispatcher in targets ) 
			{
				for each ( var currType:String in types ) 
				{
					registerListener( currTarget, currType, listener, useCapture, priority, useWeakReference );
				}
			}
		}		
		
		
		private function registerListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			eventManager.registerListener( target, type, listener, useCapture, priority, useWeakReference );
		}
		
		
		protected function stopEventInterest( target:*, type:*, listener:Function, useCapture:Boolean = false ):void
		{
			var targets	:Array = new Array().concat( target );
			var types	:Array = new Array().concat( type );
			
			for each ( var currTarget:IEventDispatcher in targets ) 
			{
				for each ( var currType:String in types ) 
				{
					unregisterListener( currTarget, currType, listener, useCapture );
				}
			}
		}
		
		
		private function unregisterListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventManager.removeListener( target, type, listener, useCapture );
		}
		
		
		public function destroy():void
		{
			if ( _eventManager != null )
			{
				_eventManager.removeAllListeners();
				_eventManager = null;
			}
		}
		
	}
	
}