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

package nl.usmedia.kinsence.modules.handtracking
{
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonFrame;

    import nl.imotion.events.*;
    import flash.events.Event;

    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.KinSenceVector;


    /**
	 * @author Pieter van de Sluis
	 */
	public class HandTrackingEvent extends Event
	{
        public static const HAND_TRACKING_UPDATE:String = "HandTrackingEvent::HAND_TRACKING_UPDATE";

		private var _handSets:Array;
		
		
		public function HandTrackingEvent( type:String, handSets:Array, bubbles:Boolean=false, cancelable:Boolean=false )
		{ 
			super( type, bubbles, cancelable );
			
			_handSets = handSets;
		} 
		
		
		public override function clone():Event 
		{ 
			return new DataEvent( type, handSets, bubbles, cancelable );
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString( "HandControlEvent", "type", "handSets", "bubbles", "cancelable", "eventPhase" );
		}
		
		
		public function get handSets():Array { return _handSets; }
		
	}
	
}