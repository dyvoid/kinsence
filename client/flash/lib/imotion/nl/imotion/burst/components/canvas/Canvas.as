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

package nl.imotion.burst.components.canvas
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;

    import nl.imotion.burst.components.core.BurstSprite;
    import nl.imotion.burst.components.core.IBurstComponent;
    import nl.imotion.burst.components.events.BurstComponentEvent;


    /**
     * @author Pieter van de Sluis
     */
    public class Canvas extends BurstSprite implements IBurstComponent
    {
        private var _padding: uint = 0;

        protected var backgroundContainer	:Sprite;
        protected var childContainer		:BurstSprite = new BurstSprite();


        public function Canvas( padding:uint = 0, backgroundColor:Number = NaN )
        {
            init( padding, backgroundColor );
        }


        private function init( padding:uint = 0, backgroundColor:Number = NaN ):void
        {
            super.addChild( childContainer  );

            this.padding = padding;
            if ( !isNaN( backgroundColor ) )
                this.backgroundColor = backgroundColor;

            startEventInterest( childContainer, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );
        }


        private function sizeChangedHandler( e:BurstComponentEvent ):void
        {
            e.stopPropagation();

            checkSizeChange();
        }


        override protected function onSizeChange():void
        {
            updateBackgroundSize();

            super.onSizeChange();
        }


        protected function updateBackgroundSize():void
        {
            if ( backgroundContainer )
            {
                backgroundContainer.x		= childContainer.getBounds( this ).x - padding;
                backgroundContainer.y		= childContainer.getBounds( this ).y - padding;
                backgroundContainer.width 	= childContainer.width  + ( _padding * 2 );
                backgroundContainer.height 	= childContainer.height + ( _padding * 2 );
            }
        }

        public function set backgroundColor( value:Number ):void
        {
            if ( !backgroundContainer )
            {
                backgroundContainer = super.addChildAt( new Sprite(), 0 ) as Sprite;
            }

            var g:Graphics = backgroundContainer.graphics;
            g.beginFill( value );
            g.drawRect( 0, 0, 1, 1 );

            updateBackgroundSize();
        }


        public function get padding():uint { return _padding; }

        public function set padding( value:uint ):void
        {
            if ( _padding != value )
            {
                _padding			=
                childContainer.x	=
                childContainer.y 	= value;
            }
        }


        override public function addChild( child:DisplayObject ):DisplayObject
        {
            childContainer.addChild(child);

            if ( child is IBurstComponent )
                startEventInterest( child, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );

            updateBackgroundSize();
            return child;
        }

        override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
        {
            childContainer.addChildAt(child, index);

            if ( child is IBurstComponent )
                startEventInterest( child, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );

            updateBackgroundSize();
            return child;
        }

        override public function removeChild( child:DisplayObject ):DisplayObject
        {
            if ( child != childContainer )
            {
                childContainer.removeChild(child);

                if ( child is IBurstComponent )
                    stopEventInterest( child, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );

                updateBackgroundSize();

            }

            return child;
        }

        override public function removeChildAt( index:int ):DisplayObject
        {
            var child:DisplayObject = childContainer.removeChildAt(index);

            if ( child is IBurstComponent )
                stopEventInterest( child, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );

            updateBackgroundSize();
            return child;
        }

        override public function getChildAt(index:int):DisplayObject
        {
            return childContainer.getChildAt(index);
        }

        override public function contains(child:DisplayObject):Boolean
        {
            return childContainer.contains(child);
        }

        override public function get numChildren():int { return childContainer.numChildren; }

        override public function getChildIndex(child:DisplayObject):int
        {
            return childContainer.getChildIndex(child);
        }


        override public function get width():Number
        {
            return childContainer.width + ( _padding * 2 );
        }


        override public function get height():Number
        {
            return childContainer.height + ( _padding * 2 );
        }

    }
		
}