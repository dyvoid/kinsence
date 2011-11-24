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

package nl.imotion.evo.evolvers
{
    import nl.imotion.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:07:02
     */
    public class Evolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _previousGenome     :Genome;
        private var _genome             :Genome;

        private var _mutationEffect     :Number = 1;

        private var _fitness            :Number = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Evolver( genome:Genome = null )
        {
            _genome = genome;

            init();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        public function init():Evolver
        {
            return this;
        }


        public function mutate():Genome
        {
            genome.mutate( mutationEffect );

            return genome;
        }


        public function reward( fitness:Number ):Genome
        {
            _previousGenome = _genome.clone();

            _fitness = fitness;

            return _genome;
        }


        public function punish( fitness:Number ):Genome
        {
            if ( _previousGenome )
                _genome = _previousGenome.clone();

            return _genome;
        }


        public function clone():Evolver
        {
            var evolver:Evolver     = new Evolver();

            if ( _previousGenome)
                evolver.previousGenome  = _previousGenome.clone();

            if ( _genome )
                evolver.genome          = _genome.clone();
            
            evolver.fitness         = fitness;
            evolver.mutationEffect       = mutationEffect;

            return evolver;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get genome():Genome
        {
            return _genome;
        }


        public function set genome( value:Genome ):void
        {
            _genome = value;
        }


        public function get previousGenome():Genome
        {
            return _previousGenome;
        }

        public function set previousGenome( value:Genome ):void
        {
            _previousGenome = value;
        }


        public function get mutationEffect():Number
        {
            return _mutationEffect;
        }


        public function set mutationEffect( value:Number ):void
        {
            _mutationEffect = value;
        }


        public function get fitness():Number
        {
            return _fitness;
        }


        public function set fitness( value:Number ):void
        {
            _fitness = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}