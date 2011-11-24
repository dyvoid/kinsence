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

package nl.imotion.bindmvc.core
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    import nl.imotion.bindmvc.controller.IBindController;
    import nl.imotion.bindmvc.model.IBindModel;


    /**
     * @author Pieter van de Sluis
     */
    public class BindMVCCore
    {
        protected static var allowInstantiation:Boolean = false;
        protected static var instance:BindMVCCore;

        private var _isStarted	:Boolean = false;

        protected var bindMap	:Dictionary = new Dictionary();
        protected var boundMap	:Dictionary = new Dictionary();

        protected var modelMap	:Dictionary = new Dictionary();


        public function BindMVCCore()
        {
            if ( !allowInstantiation )
            {
                throw new Error( "Instantiation failed: Use BindMVCCore.getInstance() Singleton factory method instead of constructor." );
            }
        }


        public static function getInstance():BindMVCCore
        {
            if ( instance == null )
            {
                allowInstantiation = true;
                instance = new BindMVCCore();
                allowInstantiation = false;
            }
            return instance;
        }


        public function startup( base:DisplayObject ):void
        {
            if ( _isStarted )
            {
                throw new Error( "BindMVCCore has already been started." );
            }

            base.addEventListener( Event.ADDED_TO_STAGE, 	 addedToStageHandler, true );
            base.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler, true );

            _isStarted = true;
        }


        public function bind( viewClass:Class, controllerClass:Class ):void
        {
            checkStartup();

            bindMap[ viewClass ] = controllerClass;
        }


        public function unbind( viewClass:Class, controllerClass:Class ):void
        {
            checkStartup();

            if ( bindMap[ viewClass ] == controllerClass )
            {
                delete bindMap[ viewClass ];
            }
        }


        public function registerModel( model:IBindModel ):IBindModel
        {
            modelMap[ model.name ] = model;

            return model;
        }


        public function retrieveModel( modelName:String ):IBindModel
        {
            return modelMap[ modelName ];
        }


        public function removeModel( modelName:String ):IBindModel
        {
            var model:IBindModel = modelMap[ modelName ];

            if ( model )
            {
                delete modelMap[ modelName ];
            }

            return model;
        }


        private function addedToStageHandler( e:Event ):void
        {
            onChildAddedToStage( e.target as DisplayObject );
        }


        protected function onChildAddedToStage( child:DisplayObject ):void
        {
            if ( boundMap[ child ] == null )
            {
                const viewClass:Class = getDefinitionByName( getQualifiedClassName( child ) ) as Class;

                if ( bindMap[ viewClass ] )
                {
                    var controllerClass:Class = bindMap[ viewClass ];
                    var controller:IBindController = new controllerClass( child );

                    boundMap[ child ] = controller;
                }
            }
        }


        private function removedFromStageHandler( e:Event ):void
        {
            onChildRemovedFromStage( e.target as DisplayObject );
        }


        protected function onChildRemovedFromStage( child:DisplayObject ):void
        {
            var controller:IBindController = boundMap[ child ];

            if ( controller )
            {
                controller.destroy();

                delete boundMap[ child ];
            }
        }


        private function checkStartup():void
        {
            if ( !_isStarted )
            {
                throw new Error( "BindMVCCore has not been initiated properly. Use the startup method to enable binding." );
            }
        }


        public function get isStarted():Boolean { return _isStarted; }

    }
	
}