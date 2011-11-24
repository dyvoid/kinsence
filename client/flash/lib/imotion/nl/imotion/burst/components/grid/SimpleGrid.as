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

package nl.imotion.burst.components.grid
{
    import flash.display.DisplayObject;
    import flash.geom.Point;

    import nl.imotion.burst.components.canvas.Canvas;
    import nl.imotion.burst.components.core.IBurstComponent;


    /**
     * @author Pieter van de Sluis
     */
    public class SimpleGrid extends Canvas implements IBurstComponent
    {
        private var _nrOfCols		:uint;
        private var _cellWidth		:Number;
        private var _cellHeight		:Number;
        private var _margin			:Number;


        public function SimpleGrid( nrOfCols:uint, cellWidth:Number, cellHeight:Number, margin:Number = 0 )
        {
            _nrOfCols 		= nrOfCols;
            _cellWidth		= cellWidth;
            _cellHeight		= cellHeight;
            _margin			= margin;
        }


        override public function addChild( child:DisplayObject ):DisplayObject
        {
            super.addChild( child );

            distributeChildren();

            return child;
        }


        override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
        {
            super.addChildAt( child, index );

            distributeChildren();

            return child;
        }


        override public function removeChild( child:DisplayObject ):DisplayObject
        {
            super.removeChild( child );

            distributeChildren();

            return child;
        }


        override public function removeChildAt( index:int ):DisplayObject
        {
            var child:DisplayObject = super.removeChildAt( index );

            distributeChildren();

            return child;
        }


        protected function distributeChildren():void
        {
            for ( var i:int = 0; i < numChildren; i++ )
            {
                var cellPos:Point = getCellPos( i );

                var child:DisplayObject = getChildAt( i );
                child.x = cellPos.x;
                child.y = cellPos.y;
            }

            checkSizeChange();
        }


        /**
         * Gets the position of a cell as a <code>Point</code>
         * @param	index the index of a cell
         * @return	the position of the cell
         */
        public function getCellPos( index:uint ):Point
        {
            if ( index < 0 || index > numChildren )
            {
                return null;
            }

            var cellPoint:Point = new Point();

            var colPos:uint = index % _nrOfCols;
            var rowPos:uint = uint( index / _nrOfCols );

            cellPoint.x = ( _cellWidth  + _margin ) * colPos;
            cellPoint.y = ( _cellHeight + _margin ) * rowPos;

            return cellPoint;
        }


        override public function get width():Number
        {
            return ( _nrOfCols * ( _cellWidth + _margin ) - _margin );
        }
        override public function set width( value:Number ):void
        {
            // do nothing, deny setting of the width
        }

        public function get nrOfCols():uint { return _nrOfCols; }

        public function set nrOfCols(value:uint):void
        {
            if ( _nrOfCols != value )
            {
                _nrOfCols = value;
                distributeChildren();
            }
        }

        public function get nrOfRows():uint
        {
            return uint( numChildren / _nrOfCols ) + 1;
        }


        public function get cellWidth():Number { return _cellWidth; }

        public function set cellWidth(value:Number):void
        {
            if ( _cellWidth != value )
            {
                _cellWidth = value;
                distributeChildren();
            }
        }

        public function get cellHeight():Number { return _cellHeight; }

        public function set cellHeight(value:Number):void
        {
            if ( _cellHeight != value )
            {
                _cellHeight = value;
                distributeChildren();
            }
        }

        public function get margin():Number { return _margin; }

        public function set margin(value:Number):void
        {
            if ( _margin != value )
            {
                _margin = value;
                distributeChildren();
            }
        }
    }

}