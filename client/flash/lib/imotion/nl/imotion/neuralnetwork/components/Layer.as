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
    public class Layer
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _neurons			:/*Neuron*/Array = [];

        private var _numNeurons		:uint;
        private var _inputLayer			:Layer;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Layer( numNeurons:uint, inputLayer:Layer = null )
        {
            init ( numNeurons, inputLayer );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function calcValues():Array
        {
            var result:Array = [];

            var neuronsLength:uint = _neurons.length;
            for ( var i:int = 0; i < neuronsLength; i++ )
            {
                result.push( _neurons[ i ].calcActivation() );
            }

            return result;
        }


        public function setValues( values:Array ):void
        {
            if ( values.length != _neurons.length )
                throw new Error( "Number of input values do not match the amount of neurons in the layer" );

            for ( var i:int = 0; i < _neurons.length; i++ )
            {
                _neurons[ i ].value = values[ i ];
            }
        }


        public function toXML():XML
        {
            var xml:XML = <layer />;

            for ( var i:int = 0; i < _neurons.length; i++ )
            {
                xml.appendChild( _neurons[ i ].toXML() );
            }

            return xml;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get neurons():/*Neuron*/Array { return _neurons; }

        public function get numNeurons():uint { return _numNeurons; }

        public function get inputLayer():Layer { return _inputLayer; }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init( numNeurons:uint, inputLayer:Layer = null ):void
        {
            _numNeurons = numNeurons;
            _inputLayer	= inputLayer;

            for ( var i:uint = 0; i < _numNeurons; i++ )
            {
                var neuron:Neuron = new Neuron();

                if ( _inputLayer )
                {
                    for ( var j:uint = 0; j < _inputLayer.neurons.length; j++ )
                    {
                        neuron.synapses[ neuron.synapses.length ] = new Synapse( _inputLayer.neurons[ j ], neuron );
                    }
                }

                _neurons [ _neurons.length ] = neuron;
            }
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
	

}