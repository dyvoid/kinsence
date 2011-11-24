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
    /**
     * @author Pieter van de Sluis
     */
    public class MassResponder implements IResponder
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _resultCallbacks        :/*Function*/Array;
        private var _faultCallbacks         :/*Function*/Array;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MassResponder( resultCallbacks:/*Function*/Array = null, faultCallbacks:/*Function*/Array = null )
        {
            _resultCallbacks = resultCallbacks || [];
            _faultCallbacks = faultCallbacks || [];
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addResultCallback( callback:Function ):void
        {
            if ( callback != null && _resultCallbacks.indexOf( callback ) == -1 )
                _resultCallbacks.push( callback );
        }

        public function addFaultCallback( callback:Function ):void
        {
            if ( callback != null && _faultCallbacks.indexOf( callback ) == -1 )
                _faultCallbacks.push( callback );
        }


        public function hasResultCallback( callback:Function ):Boolean
        {
            return ( _resultCallbacks.indexOf( callback ) != -1 )
        }

        public function hasFaultCallback( callback:Function ):Boolean
        {
            return ( _faultCallbacks.indexOf( callback ) != -1 )
        }


        public function removeResultCallback( callback:Function ):void
        {
            var callbackIndex:int = _resultCallbacks.indexOf( callback );

            if ( callbackIndex != -1 )
                _resultCallbacks.splice( callbackIndex, 1 );
        }

        public function removeFaultCallback( callback:Function ):void
        {
            var callbackIndex:int = _faultCallbacks.indexOf( callback );

            if ( callbackIndex != -1 )
                _faultCallbacks.splice( callbackIndex, 1 );
        }


        public function onResult( resultData:* ):void
        {
            for each ( var callback:Function in _resultCallbacks )
            {
                if ( callback != null )
                    callback( resultData );
            }
        }

        public function onFault( faultData:* ):void
        {
            for each ( var callback:Function in _faultCallbacks )
            {
                if ( callback != null )
                    callback( faultData );
            }
        }


        public function reset():void
        {
            _resultCallbacks = [];
            _faultCallbacks  = [];
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function getResultCallbackIndex( callback:Function ):int
        {
            return _resultCallbacks.indexOf( callback );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        protected function get resultCallbacks():Array
        {
            return _resultCallbacks;
        }

        protected function set resultCallbacks( value:Array ):void
        {
            _resultCallbacks = value;
        }


        protected function get faultCallbacks():Array
        {
            return _faultCallbacks;
        }

        protected function set faultCallbacks( value:Array ):void
        {
            _faultCallbacks = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}