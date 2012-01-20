/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2012 Pieter van de Sluis, Us Media
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
 * http://www.usmedia.nl
 */

package nl.usmedia.kinsence.modules.speechrecognition
{
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonFrame;

    import nl.imotion.events.*;
    import flash.events.Event;


    /**
	 * @author Pieter van de Sluis
	 */
	public class SpeechRecognitionEvent extends Event
	{
        public static const ACTIVATED       :String = "SpeechRecognitionEvent::ACTIVATED";
        public static const DEACTIVATED     :String = "SpeechRecognitionEvent::DEACTIVATED";

        public static const SPEECH_DETECTED                 :String = "SpeechRecognitionEvent::SPEECH_DETECTED";
        public static const SPEECH_HYPOTHIZED               :String = "SpeechRecognitionEvent::SPEECH_HYPOTHIZED";
        public static const SPEECH_RECOGNIZED               :String = "SpeechRecognitionEvent::SPEECH_RECOGNIZED";
        public static const SPEECH_RECOGNITION_REJECTED     :String = "SpeechRecognitionEvent::SPEECH_RECOGNITION_REJECTED";

		private var _result:SpeechRecognitionResult;
		
		
		public function SpeechRecognitionEvent( type:String, result:SpeechRecognitionResult, bubbles:Boolean=false, cancelable:Boolean=false )
		{ 
			super( type, bubbles, cancelable );
			
			_result = result;
		} 
		
		
		public override function clone():Event 
		{ 
			return new SpeechRecognitionEvent( type, result, bubbles, cancelable );
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString( "SpeechRecognitionEvent", "type", "result", "bubbles", "cancelable", "eventPhase" );
		}
		
		
		public function get result():SpeechRecognitionResult { return _result; }
		
	}
	
}