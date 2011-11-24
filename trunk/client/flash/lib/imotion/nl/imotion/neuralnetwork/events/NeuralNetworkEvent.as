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

package nl.imotion.neuralnetwork.events
{
    import flash.events.Event;

    import nl.imotion.neuralnetwork.training.TrainingResult;


    /**
     * @author Pieter van de Sluis
     */
    public class NeuralNetworkEvent extends Event
    {
        public static const TRAINING_EPOCH_COMPLETE		:String = "NeuralNetworkEvent::trainingEpochComplete";
        public static const TRAINING_COMPLETE			:String = "NeuralNetworkEvent::trainingComplete";

        private var _trainingResult		:TrainingResult;


        public function NeuralNetworkEvent( type:String, trainingResult:TrainingResult, bubbles:Boolean=false, cancelable:Boolean=false )
        {
            super(type, bubbles, cancelable);

            _trainingResult = trainingResult;
        }


        public override function clone():Event
        {
            return new NeuralNetworkEvent( type, trainingResult, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString("NeuralNetworkEvent", "type", "trainingResult", "bubbles", "cancelable", "eventPhase");
        }


        public function get trainingResult():TrainingResult { return _trainingResult; }

    }

}