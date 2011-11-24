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
    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:09:12
     */
    public class Gene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _propName:String;

        private var _baseValue:Number;

        private var _mutationEffect:Number;

        private var _limitMethod:String;

        private var _momentum:Number = 0;
        private var _momentumEffect:Number = 0.5;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Gene( propName:String, mutationEffect:Number = 1, limitMethod:String = "bounce", baseValue:Number = NaN )
        {
            _propName = propName;
            _mutationEffect = mutationEffect;
            _limitMethod = limitMethod;
            _baseValue = ( !isNaN( baseValue ) ) ? baseValue : Math.random();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function mutate( globalMutationEffect:Number = 1, mutation:Number = NaN, updateMomentum:Boolean = false ):*
        {
            if ( globalMutationEffect != 0 )
            {
                mutation = ( !isNaN( mutation ) ) ? mutation : Math.random() * 2 - 1;

                var newVal:Number = _baseValue + ( mutation * _mutationEffect * globalMutationEffect  ) + _momentum;

                if ( newVal < -1 ) newVal = -1;
                if ( newVal >  2 ) newVal =  2;

                if ( newVal < 0 || newVal > 1 )
                {
                    switch ( _limitMethod )
                    {
                        case LimitMethod.BOUNCE:
                            newVal = ( newVal < 0 ) ? -newVal : 1 - ( newVal - 1 );
                        break;

                        case LimitMethod.WRAP:
                            newVal = ( newVal < 0 ) ?  1 + newVal : newVal - 1;
                        break;

                        case LimitMethod.CUT_OFF:
                            newVal = ( newVal < 0 ) ? 0 : 1;
                        break;
                    }
                }

                if ( updateMomentum )
                    _momentum = ( newVal - _baseValue ) * _momentumEffect;

                _baseValue = Math.round( newVal * 1000000 ) / 1000000;
            }

            return getPropValue();
        }


        public function getPropValue():*
        {
            throw new Error( "This method should be overridden in a subclass" );
        }


        public function reset( baseValue:Number = NaN ):void
        {
            _baseValue  = ( !isNaN( baseValue) ) ? baseValue : Math.random();
            _momentum   = 0;
        }


        public function clone():Gene
        {
            return new Gene( _propName,_mutationEffect, _limitMethod, _baseValue );
        }


        public function toXML():XML
        {
            var xml:XML = <gene type="gene" propName={propName} baseValue={baseValue} mutationEffect={mutationEffect} limitMethod={limitMethod} />;

            return xml;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS
        

        public function get propName():String
        {
            return _propName;
        }


        public function get baseValue():Number
        {
            return _baseValue;
        }


        public function set baseValue( value:Number ):void
        {
            _baseValue = value;
        }


        public function get mutationEffect():Number
        {
            return _mutationEffect;
        }

        public function set mutationEffect( value:Number ):void
        {
            _mutationEffect = value;
        }


        public function get limitMethod():String
        {
            return _limitMethod;
        }


        public function set limitMethod( value:String ):void
        {
            _limitMethod = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}