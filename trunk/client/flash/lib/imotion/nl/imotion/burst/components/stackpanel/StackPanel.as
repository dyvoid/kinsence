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

package nl.imotion.burst.components.stackpanel
{

    import flash.display.DisplayObject;

    import nl.imotion.burst.components.canvas.Canvas;
    import nl.imotion.burst.components.core.IBurstComponent;
    import nl.imotion.burst.components.events.BurstComponentEvent;


    public class StackPanel extends Canvas implements IBurstComponent
    {
        private var _orientation		:String;
        private var _autoUpdate			:Boolean;
        private var _margin				:Number;


        public function StackPanel( orientation:String = "vertical", autoUpdate:Boolean = false, margin:Number = 0 )
        {
            _orientation 	= ( orientation == StackPanelOrientation.HORIZONAL || orientation == StackPanelOrientation.VERTICAL ) ? orientation : StackPanelOrientation.VERTICAL;
            _autoUpdate		= autoUpdate;
            _margin			= margin;
        }


        public function get orientation():String { return _orientation; }

        public function get autoUpdate():Boolean { return _autoUpdate; }

        public function get margin():Number { return _margin; }


        override protected function onInit():void
        {
            super.onInit();

            if ( numChildren > 0 )
                onSizeChange();
        }


        override public function addChild( child:DisplayObject ):DisplayObject
        {
            try
            {
                addChildAt( child, numChildren );
            }
            catch ( e:Error )
            {
                //Catch any error, and then throw it ourselves.
                //In this way the error will seem to come from addChild rather than addChildAt
                throw new Error( e );
            }

            return child;
        }


        override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
        {
            super.addChildAt( child, index );
            registerChildListeners( child );

            forceRedraw();

            return child;
        }


        override public function removeChild( child:DisplayObject ):DisplayObject
        {
            super.removeChild( child );
            removeChildListeners( child );

            forceRedraw();

            return child;
        }


        override public function removeChildAt( index:int ):DisplayObject
        {
            try
            {
                var child:DisplayObject = getChildAt( index );
                removeChild( child );
            }
            catch ( e:Error )
            {
                //Catch any error, and then throw it ourselves.
                //In this way the error will seem to come from removeChildAt rather than removeChild or getChildAt
                throw new Error( e );
            }

            return child;
        }


        private function registerChildListeners( child:DisplayObject ):void
        {
            if ( _autoUpdate && child is IBurstComponent )
            {
                startEventInterest( child, BurstComponentEvent.SIZE_CHANGED, childSizeChangedHandler );
            }
        }


        private function removeChildListeners( child:DisplayObject ):void
        {
            if ( child is IBurstComponent )
            {
                stopEventInterest( child, BurstComponentEvent.SIZE_CHANGED, 	childSizeChangedHandler );
            }
        }


        private function distributeChildren( startChild:DisplayObject = null ):void
        {
            if ( numChildren > 0 )
            {
                var startChildIndex:uint = ( startChild != null ) ? getChildIndex( startChild ) : 0;

                var i:int = startChildIndex;

                switch ( _orientation )
                {
                    case StackPanelOrientation.HORIZONAL:
                        var xPos:Number = ( startChildIndex == 0 ) ? 0 : getChildAt( startChildIndex - 1 ).getBounds( this ).right + margin;

                        for ( i; i < numChildren; i++ )
                        {
                            var horzChild:DisplayObject = getChildAt( i );
                            var childWidth:Number = ( ( horzChild is IBurstComponent ) ? IBurstComponent( horzChild ).explicitWidth : horzChild.width ) || 0;

                            horzChild.x = xPos;

                            xPos = horzChild.x + childWidth + margin;
                        }
                        break;

                    case StackPanelOrientation.VERTICAL:
                        var yPos:Number = ( startChildIndex == 0 ) ? 0 : getChildAt( startChildIndex - 1 ).getBounds( this ).bottom + margin;

                        for ( i; i < numChildren; i++ )
                        {
                            var vertChild:DisplayObject = getChildAt( i );
                            var childHeight:Number = ( ( vertChild is IBurstComponent ) ? IBurstComponent( vertChild ).explicitHeight : vertChild.height ) || 0;

                            vertChild.y = yPos;

                            yPos = vertChild.y + childHeight + margin;
                        }
                        break;
                }
            }
        }


        override protected function onSizeChange():void
        {
            distributeChildren();

            super.onSizeChange();
        }


        private function childSizeChangedHandler( event:BurstComponentEvent ):void
        {
            event.stopPropagation();

            forceRedraw();
        }

    }

}