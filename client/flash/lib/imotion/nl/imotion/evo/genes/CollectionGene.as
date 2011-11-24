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

package nl.imotion.evo.genes
{
    import flash.utils.getQualifiedClassName;


    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:26:57
     */
    public class CollectionGene extends UintGene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _collection:Array;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function CollectionGene( propName:String, collection:Array, mutationEffect:Number, limitMethod:String = "wrap", baseValue:Number = NaN )
        {
            _collection = collection;

            super( propName, 0, _collection.length - 1, mutationEffect, limitMethod, baseValue );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function getPropValue():*
        {
            return _collection[ super.getPropValue() as uint ];
        }



        override public function clone():Gene
        {
            return new CollectionGene( propName, _collection, mutationEffect, limitMethod, baseValue );
        }


        override public function toXML():XML
        {
            var xml:XML = super.toXML();

            delete xml[ "@minVal" ];
            delete xml[ "@maxVal" ];
            xml[ "@type" ]       = "Collection";

            for each ( var item:* in _collection )
            {
                var classRef:String = getQualifiedClassName( item );

                xml.appendChild( <item classRef={classRef}>{item}</item> );
            }

            return xml;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}