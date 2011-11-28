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

package nl.usmedia.kinsence.modules.events
{

    import flash.events.Event;


    /**
     * Package:    nl.usmedia.kinsence.modules.events
     * Class:      KinectModuleEvent
     *
     * @author     pieter.van.de.sluis
     * @since      10/28/11
     */
    public class KinSenceModuleEvent extends Event
    {

        // EVENT TYPES
        public static const REGISTERED:String = "KinSenceModuleEvent::REGISTERED";
        public static const REMOVED:String = "KinSenceModuleEvent::REMOVED";

        // EVENT DATA


        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function KinSenceModuleEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( type, bubbles, cancelable );
        }


        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        public override function clone():Event
        {
            return new KinSenceModuleEvent( type, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString( "KinectModuleEvent", "type", "bubbles", "cancelable", "eventPhase" );
        }


        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S



    }
}