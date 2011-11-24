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

package nl.imotion.burst.parsers
{
    import flash.display.BlendMode;
    import flash.display.DisplayObject;

    import nl.imotion.burst.Burst;


    /**
     * @author Pieter van de Sluis
     */
    public class DisplayObjectParser extends BurstParser implements IBurstParser
    {
        private const DEFAULT_TARGET_CLASS:Class = DisplayObject;


        public function DisplayObjectParser()
        {
            initMappings();
        }


        protected function initMappings():void
        {
            addAttributeMapping( "x", Number );
            addAttributeMapping( "y", Number );
            addAttributeMapping( "width", Number );
            addAttributeMapping( "height", Number );
            addAttributeMapping( "scaleX", Number );
            addAttributeMapping( "scaleY", Number );
            addAttributeMapping( "alpha", Number );
            addAttributeMapping( "blendMode", String, null, [ BlendMode.ADD, BlendMode.ALPHA, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT ] );
            addAttributeMapping( "cacheAsBitmap", Boolean );
            addAttributeMapping( "rotation", Number );
            addAttributeMapping( "visible", Boolean );
        }


        override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
        {
            targetClass = targetClass || DEFAULT_TARGET_CLASS;

            var d:DisplayObject = new targetClass();

            applyMappings( d, xml );

            return d;
        }

    }

}