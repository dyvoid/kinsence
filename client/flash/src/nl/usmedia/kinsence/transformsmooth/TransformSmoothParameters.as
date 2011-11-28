/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2012 Pieter van de Sluis, Us Media
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
 * http://www.usmedia.nl
 */

package nl.usmedia.kinsence.transformsmooth
{
    /**
     * @author Pieter van de Sluis
     */
    public class TransformSmoothParameters
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var correction:Number;
        public var jitterRadius:Number;
        public var maxDeviationRadius:Number;
        public var prediction:Number;
        public var smoothing:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TransformSmoothParameters( correction:Number = 0.5, jitterRadius:Number = 0.05,
                                                   maxDeviationRadius:Number = 0.04, prediction:Number = 0.5,
                                                   smoothing:Number = 0.5 )
        {
            this.correction = correction;
            this.jitterRadius = jitterRadius;
            this.maxDeviationRadius = maxDeviationRadius;
            this.prediction = prediction;
            this.smoothing = smoothing;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


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