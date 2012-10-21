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

package nl.usmedia.kinsence.modules.handtracking
{
    import nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent;

    import nl.usmedia.kinsence.modules.AbstractKinSenceModule;
    import nl.usmedia.kinsence.modules.handtracking.hands.Hands;
    import nl.usmedia.kinsence.modules.skeletontracking.skeleton.SkeletonPoint;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="HandTrackingEvent::HAND_TRACKING_UPDATE", type="nl.usmedia.kinsence.modules.handtracking.HandTrackingEvent")]

    public class HandTrackingModule extends AbstractKinSenceModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "HandTracking";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function HandTrackingModule()
        {
            super( NAME );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function onServerMessage( type:String, data:* ):void
        {
            switch( type )
            {
                case "HandTrackingUpdate":
                    var handSets:Array = data;

                    var arr:Array = [];

                    for each ( var handsObject:Object in handSets )
                    {
                        var hands:Hands = new Hands();
                        hands.fromObject( handsObject );
                        arr.push( hands );
                    }

                    dispatchEvent( new HandTrackingEvent( HandTrackingEvent.HAND_TRACKING_UPDATE, arr ) );
                break;
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}