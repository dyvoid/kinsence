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

package nl.imotion.burst
{

    import flash.display.DisplayObject;
    import flash.utils.Dictionary;

    import nl.imotion.burst.parsers.IBurstParser;
    import nl.imotion.burst.parsers.ParserPool;


    public class Burst
    {

        protected var bindMap:Dictionary 	= new Dictionary();

        protected var parserPool:ParserPool	= new ParserPool();


        public function Burst()
        {

        }


        public function parse( xml:XML ):DisplayObject
        {
            var binding:BurstBinding = bindMap[ xml.name() ];

            if ( binding )
            {
                var parser:IBurstParser = parserPool.getParser( binding.parserClass );

                return parser.create( xml, this, binding.targetClass );
            }

            return null;
        }


        public function bindParser( nodeName:String, parserClass:Class, targetClass:Class = null ):void
        {
            bindMap[ nodeName ] = new BurstBinding( parserClass, targetClass );
        }


        public function hasBinding( nodeName:String ):Boolean
        {
            return ( bindMap[ nodeName ] != null );
        }


        public function removeBinding( nodeName:String ):Boolean
        {
            if ( hasBinding( nodeName ) )
            {
                delete bindMap[ nodeName ];
                return true;
            }
            return false;
        }


        public function purge():void
        {
            bindMap = new Dictionary();
            parserPool.purge();
        }

    }
    
}