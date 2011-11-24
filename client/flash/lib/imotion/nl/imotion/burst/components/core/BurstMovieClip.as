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

package nl.imotion.burst.components.core
{

    import flash.display.DisplayObject;
    import flash.events.Event;

    import nl.imotion.burst.components.events.BurstComponentEvent;
    import nl.imotion.display.EventManagedMovieClip;


    [Event(name="sizeChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	
    public class BurstMovieClip extends EventManagedMovieClip implements IBurstComponent
    {
        private var _explicitWidth	:Number;
        private var _explicitHeight	:Number;

        private var _prevWidth		:Number;
        private var _prevHeight		:Number;

        protected var hasChangedSize		:Boolean = false;


        public function BurstMovieClip()
        {
            if ( stage ) init();
            else startEventInterest( this, Event.ADDED_TO_STAGE, init );
        }


        private function init( e:Event = null ):void
        {
            stopEventInterest( this, Event.ADDED_TO_STAGE, init );

            onInit();
        }


        protected function onInit():void
        {
            startEventInterest( stage, Event.RENDER, stageRenderHandler );

            _prevWidth 	= this.width;
            _prevHeight = this.height;
        }


        private function stageRenderHandler( e:Event ):void
        {
            if ( hasChangedSize )
            {
                hasChangedSize = false;
                onSizeChange();
            }
        }


        override public function set width( value:Number ):void
        {
            if ( value != super.width )
            {
                super.width = value;
                checkSizeChange();
            }

        }


        override public function set height( value:Number ):void
        {
            if ( value != super.height )
            {
                super.height = value;
                checkSizeChange();
            }

        }


        override public function set scaleX( value:Number ):void
        {
            if ( value != super.scaleX )
            {
                super.scaleX 	= value;
                checkSizeChange();
            }

        }


        override public function set scaleY( value:Number ):void
        {
            if ( value != super.scaleY )
            {
                super.scaleY 	= value;
                checkSizeChange();
            }

        }


        override public function addChild( child:DisplayObject ):DisplayObject
        {
            super.addChild( child );

            checkSizeChange();

            return child;
        }


        override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
        {
            super.addChildAt(child, index);

            checkSizeChange();

            return child;
        }


        override public function removeChild( child:DisplayObject ):DisplayObject
        {
            super.removeChild( child );

            checkSizeChange();

            return child;
        }


        override public function removeChildAt( index:int ):DisplayObject
        {
            var child:DisplayObject = super.removeChildAt(index);

            checkSizeChange();

            return child;
        }


        protected function checkSizeChange():void
        {
            if ( this.stage && ( _prevWidth != width || _prevHeight != height )  )
            {
                forceRedraw();

                _prevWidth 	= width;
                _prevHeight = height;
            }
        }


        protected function forceRedraw():void
        {
            //TODO Create an alternative for stage.invalidate(), since it doesn't work properly on Mac

            /*if ( stage )
            {
                hasChangedSize = true;
                stage.invalidate();
            }
            else
            {*/
                onSizeChange();
            //}
        }


        protected function onSizeChange():void
        {
            dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
        }


        public function get explicitWidth():Number { return isNaN( _explicitWidth) ? this.width : _explicitWidth; }
        public function set explicitWidth( value:Number ):void
        {
            _explicitWidth = value;
        }


        public function get explicitHeight():Number { return isNaN( _explicitHeight) ? this.height : _explicitHeight; }
        public function set explicitHeight( value:Number ):void
        {
            _explicitHeight = value;
        }

    }


}