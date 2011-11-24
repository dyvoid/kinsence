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

package nl.imotion.neuralnetwork.components
{


    /**
     * @author Pieter van de Sluis
     */
    public class Neuron
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _synapses		:/*Synapse*/Array = [];

        private var _value			:Number;
        private var _error			:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Neuron() { }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function calcActivation():Number
        {
            var synapsesLength:uint = _synapses.length;

            if ( synapsesLength == 0 )
                throw new Error( "Unable to calculate a value. Neuron has no synapses connected to it" );

            _value = 0;

            for ( var i:int = 0; i < synapsesLength; i++ )
            {
                _value += _synapses[ i ].getOutput();
            }

            _value = getSigmoid( _value );

            return _value;
        }


        public function toXML():XML
        {
            var xml:XML = <neuron />;

            for ( var i:int = 0; i < _synapses.length; i++ )
            {
                xml.appendChild( _synapses[ i ].toXML() );
            }

            return xml;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get synapses():/*Synapse*/Array { return _synapses; }

        public function get value():Number { return _value; }
        public function set value(value:Number):void
        {
            _value = value;
        }

        public function get error():Number { return _error; }
        public function set error(value:Number):void
        {
            _error = value;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // PRIVATE

        private function getSigmoid( value:Number ):Number
        {
            return 1 / ( 1 + Math.exp( -value ) );
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }

}