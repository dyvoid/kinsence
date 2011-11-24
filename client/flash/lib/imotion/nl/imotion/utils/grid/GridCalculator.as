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

package nl.imotion.utils.grid
{
    import flash.geom.Point;


    /**
	* The <code>GridCalculator</code> class creates a virtual grid, that can be used to calculate individual cell positions.
	* @author Pieter van de Sluis
	*/
	public class GridCalculator
	{
		private var _nrOfCols:Number = 0;
		private var _cellWidth:Number = 0;
		private var _cellHeight:Number = 0;
		private var _margin:Number = 0;
		private var _nrOfCells:int = -1;
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		
		/**
		 * Constructs a new <code>GridCalculator</code> 
		 * @param	nrOfCols The number of columns in the grid
		 * @param	cellWidth The width of a cell in the grid
		 * @param	cellHeight The height of a cell in the grid
		 * @param	margin The margin between cells, in pixels
		 * @param	nrOfCells The total number of cells in the grid. Optional, it is only necessary if the <code>height</code> and <code>nrOfRows</code> properties are to be used.
		 */
		public function GridCalculator( nrOfCols:uint, cellWidth:Number, cellHeight:Number, margin:Number = 0, nrOfCells:int = -1 )
		{
			_nrOfCols = nrOfCols;
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_margin = margin;
			_nrOfCells = nrOfCells;
		}
		
		
		/**
		 * Gets the position of a cell as a <code>Point</code>
		 * @param	index the index of a cell
		 * @return	the position of the cell
		 */
		public function getCellPos( index:uint ):Point
		{
			if ( index < 0 || ( nrOfCells != -1 && index >= nrOfCells ) )
			{
				throw new Error( "Index is out of bounds" );
			}
			
			var cellPoint:Point = new Point();
			
			var colPos:uint = index % _nrOfCols;
			var rowPos:uint = uint( index / _nrOfCols );
			
			cellPoint.x = ( colPos == 0 ) ? _offsetX : ( this.cellWidth  + this.margin ) * colPos + _offsetX;
			cellPoint.y = ( rowPos == 0 ) ? _offsetY : ( this.cellHeight + this.margin ) * rowPos + _offsetY;
			
			return cellPoint;
		}
		
		
		/**
		 * Gets the x position of a cell
		 * @param	index the index of a cell
		 * @return	the x position of the cell
		 */
		public function getCellX ( index:uint ):Number
		{
			return this.getCellPos( index ).x;
		}
		
		
		/**
		 * Gets the y position of a cell
		 * @param	index the index of a cell
		 * @return	the y position of the cell
		 */
		public function getCellY ( index:uint ):Number
		{
			return this.getCellPos( index ).y;
		}
		
		
		/**
		 * The number of columns in the grid
		 */
		public function get nrOfCols():Number { return _nrOfCols; }
		public function set nrOfCols(value:Number):void 
		{
			_nrOfCols = value;
		}
		
		
		/**
		 * The number of rows in the grid. Can only be calculated if <code>nrOfCells</code> has been set.
		 */
		public function get nrOfRows():uint
		{
			if ( nrOfCells == -1 ) return 0;

            return Math.ceil( this.nrOfCells / this.nrOfCols );
		}
		
		/**
		 * The width of the grid
		 */
		public function get width():Number
		{
			return ( this.cellWidth + this.margin ) * this.nrOfCols - this.margin;
		}
		
		
		/**
		 * The height of the grid. Can only be calculated if <code>nrOfCells</code> has been set.
		 */
		public function get height():Number
		{
			if ( nrOfCells == -1 ) return 0;

            return ( this.cellHeight + this.margin ) * this.nrOfRows - this.margin;
		}
		
		
		/**
		 * The width of a cell in the grid
		 */		
		public function get cellWidth():Number { return _cellWidth; }
		public function set cellWidth( value:Number ):void 
		{
			_cellWidth = value;
		}
		
		
		/**
		 * The height of a cell in the grid
		 */
		public function get cellHeight():Number { return _cellHeight; }
		public function set cellHeight( value:Number ):void 
		{
			_cellHeight = value;
		}
		
		
		/**
		 * The margin between cells, in pixels
		 */
		public function get margin():Number { return _margin; }
		public function set margin( value:Number ):void 
		{
			_margin = value;
		}
		
		
		/**
		 * The total number of cells in the grid. Optional, it is only necessary if the <code>height</code> and <code>nrOfRows</code> properties are to be used.
		 */
		public function get nrOfCells():uint { return _nrOfCells; }
		public function set nrOfCells( value:uint ):void 
		{
			_nrOfCells = value;
		}
		
		
		/**
		 * The x offset of the grid
		 */
		public function get offsetX():Number { return _offsetX; }
		public function set offsetX( value:Number ):void 
		{
			_offsetX = value;
		}
		
		
		/**
		 * The y offset of the grid
		 */
		public function get offsetY():Number { return _offsetY; }
		public function set offsetY( value:Number ):void 
		{
			_offsetY = value;
		}
		
	}
	
}
