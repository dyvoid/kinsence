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
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import nl.imotion.delegates.events.AsyncDelegateEvent;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="AsyncDelegateEvent::RESULT", type="nl.imotion.delegates.events.AsyncDelegateEvent")]
    [Event(name="AsyncDelegateEvent::FAULT", type="nl.imotion.delegates.events.AsyncDelegateEvent")]

    public class AsyncDelegate extends AbstractDelegate implements IEventDispatcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        protected static var globalOperationID  :uint = 0;

        private var _eventDispatcher        :EventDispatcher;

        private var _responseData           :*;

        private var _autoRemoveCallbacks    :Boolean = true;
        private var _isExecuting            :Boolean = false;

        private var _operationID            :int = -1;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AsyncDelegate( operationName:String = null, requestData:* = null, resultCallbacks:/*Function*/Array = null, faultCallbacks:/*Function*/Array = null )
        {
            super( operationName, requestData, new MassResponder( resultCallbacks, faultCallbacks ) );

            _eventDispatcher = new EventDispatcher();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function execute():void
        {
            _isExecuting = true;

            _operationID = globalOperationID++;
            _responseData = null;
            
            super.execute();
        }


        /*public static function create( operationName:String = null, requestData:* = null, resultCallbacks:*//*Function*//*Array = null, faultCallbacks:*//*Function*//*Array = null ):AsyncDelegate
        {
            var delegate:AsyncDelegate = new AsyncDelegate( operationName, requestData, resultCallbacks, faultCallbacks );
            delegate.execute();

            return delegate;
        }*/


        public function addResultCallback( callback:Function ):void
        {
           massResponder.addResultCallback( callback );
        }


        public function addFaultCallback( callback:Function ):void
        {
            massResponder.addFaultCallback( callback );
        }


        public function removeResultCallback( callback:Function ):void
        {
            massResponder.removeResultCallback( callback );
        }

        public function removeFaultCallback( callback:Function ):void
        {
            massResponder.removeFaultCallback( callback );
        }


        override public function reset():void
        {
            if ( _isExecuting ) return;

            super.reset();

            _responseData = null;
            _operationID  = -1;
            massResponder.reset();
        }


        public function dispatchEvent( event:Event ):Boolean
        {
            return _eventDispatcher.dispatchEvent( event );
        }


        public function hasEventListener( type:String ):Boolean
        {
            return _eventDispatcher.hasEventListener( type );
        }


        public function willTrigger( type:String ):Boolean
        {
            return _eventDispatcher.willTrigger( type );
        }


        public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
        {
            _eventDispatcher.removeEventListener( type, listener, useCapture );
        }


        public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
        {
            _eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function get massResponder():MassResponder
        {
            return responder as MassResponder;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function onResult( resultData:* ):void
        {
            _responseData = resultData;

            dispatchEvent( new AsyncDelegateEvent( AsyncDelegateEvent.RESULT, resultData ) );

            massResponder.onResult( resultData );

            if ( _autoRemoveCallbacks )
                massResponder.reset();
        }


        protected function onFault( faultData:* ):void
        {
            _responseData = faultData;

            dispatchEvent( new AsyncDelegateEvent( AsyncDelegateEvent.FAULT, faultData ) );

            massResponder.onFault( faultData );

            if ( _autoRemoveCallbacks )
                massResponder.reset();
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get responseData():*
        {
            return _responseData;
        }


        public function get autoRemoveCallbacks():Boolean
        {
            return _autoRemoveCallbacks;
        }


        public function set autoRemoveCallbacks( value:Boolean ):void
        {
            _autoRemoveCallbacks = value;
        }


        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }


        public function get operationID():uint
        {
            return _operationID;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}