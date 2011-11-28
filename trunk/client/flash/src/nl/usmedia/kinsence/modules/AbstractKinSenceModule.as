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

package nl.usmedia.kinsence.modules
{
    import flash.events.EventDispatcher;

    import nl.usmedia.kinsence.interfaces.IKinSenceCore;

    import nl.usmedia.kinsence.interfaces.IKinSenceModule;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="KinSenceModuleEvent::REGISTERED", type="nl.usmedia.kinsence.modules.events.KinSenceModuleEvent")]
    [Event(name="KinSenceModuleEvent::REMOVED", type="nl.usmedia.kinsence.modules.events.KinSenceModuleEvent")]

    public class AbstractKinSenceModule extends EventDispatcher implements IKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _name       :String;
        private var _core       :IKinSenceCore;
        
        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AbstractKinSenceModule( name:String )
        {
            _name = name;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function onRegister():void { }

        public function onRemove():void { }

        public function onServerMessage( type:String, data:* ):void { }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function sendMessage( type:String, data:* = null ):void
        {
            _core.sendMessage( _name, type, data );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get core():IKinSenceCore
        {
            return _core;
        }

        public function set core( value:IKinSenceCore ):void
        {
            _core = value;
        }
        

        public function get name():String
        {
            return _name;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}