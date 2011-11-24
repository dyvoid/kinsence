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

package nl.imotion.commands
{
	
	/**
	* @author	Pieter van de Sluis
	*/

	public class CommandStack
	{
		private var _stack		:Array  = [];
		private var _index		:int	= -1;
		private var _maxLength	:uint;
		
		
		/*
		 * Constructs a new CommandStack
		 * @param	maxLength	The maximum length of the stack. 0 is unlimited (default).
		 */
		public function CommandStack( maxLength:uint = 0 )
		{
			_maxLength = maxLength;
		}
		
		
		/**
		 * Removes commands from the stack, if the max length of the stack has been reached
		 */
		private function enforceMaxLength():void
		{
			if ( _maxLength != 0 && _stack.length > _maxLength )
			{
				_stack.splice( _stack.length - _maxLength );
				
				_index = _stack.length - 1;
			}
		}
		
		
		/**
		 * Clears the stack
		 */
		public function clear():void
		{
			_stack  = [];
			_index = -1;
		}
		
		
		/**
		 * Adds a command to the stack
		 * @param	command		the command
		 */
		public function addCommand( command:ICommand ):void
		{
			_stack[ _index++ ] = command;
			_stack.splice( _index );
			
			enforceMaxLength();
		}
		
		
		private function doSingleUndo():void
		{
			IUndoableCommand( _stack[ --_index ] ).undo();
		}
		
		
		/**
		 * Undos a number of steps in stack
		 * @param	nrOfSteps	the number of steps to undo
		 */
		public function undo( nrOfSteps:uint = 1 ):void
		{
			if ( _stack.length > 0 )
			{
				nrOfSteps = Math.min( nrOfSteps, index + 1 );
				
				for ( var i:int = 0; i < nrOfSteps; i++ ) 
				{
					doSingleUndo();
				}
			}
		}
		
		
		private function doSingleRedo():void
		{
			if ( index < _stack.length )
			{
				IRedoableCommand( _stack[ ++_index ] ).redo();
			}
		}
		
		
		/**
		 * Redos a number of steps in stack
		 * @param	nrOfSteps	the number of steps to redo
		 */
		public function redo( nrOfSteps:uint = 1 ):void
		{
			if ( _stack.length > 0 )
			{
				nrOfSteps = Math.min( nrOfSteps, _stack.length - index );
				
				for ( var i:int = 0; i < nrOfSteps; i++ ) 
				{
					doSingleRedo();
				}
			}
		}
		
		
		/**
		 * The current index of the stack
		 */
		public function get index():int { return _index; }
		
		
		/**
		 * The length of the stack
		 */
		public function get length():uint { return _stack.length; }
		
	}
}
