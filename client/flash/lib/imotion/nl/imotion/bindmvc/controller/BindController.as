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

package nl.imotion.bindmvc.controller
{

    import flash.display.DisplayObject;

    import nl.imotion.bindmvc.core.BindComponent;
    import nl.imotion.bindmvc.model.IBindModel;
    import nl.imotion.notes.NoteManager;


    public class BindController extends BindComponent implements IBindController
    {

        protected var defaultView:DisplayObject;
        protected var defaultModel:IBindModel;


        public function BindController( defaultView:DisplayObject, defaultModel:IBindModel = null )
        {
            this.defaultView 	= defaultView;
            this.defaultModel 	= defaultModel;
        }


        protected function startNoteInterest( type:String, listener:Function ):void
        {
            noteManager.registerListener( type, listener );
        }


        protected function stopNoteInterest( type:String, listener:Function ):void
        {
            noteManager.removeListener( type, listener );
        }


        override public function destroy():void
        {
            defaultView 	= null;
            defaultModel 	= null;

            if ( _noteManager != null )
            {
                _noteManager.removeAllListeners();
                _noteManager = null;
            }

            super.destroy();
        }


        private var _noteManager:NoteManager;
        protected function get noteManager():NoteManager
        {
            if ( !_noteManager ) _noteManager = new NoteManager();
            return _noteManager;
        }

    }
	
}