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

package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class SkeletonData
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var joints:Vector.<Joint>;
        public var position:KinSenceVector;
        public var quality:uint;
        public var trackingID:int;
        public var trackingState:uint;
        public var userIndex:int;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SkeletonData()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            joints = new Vector.<Joint>();
            for each ( var jointObject:Object in object.Joints )
            {
                var joint:Joint = new Joint();
                joint.fromObject( jointObject );
                joints[ joints.length ] = joint;
            }

            position = new KinSenceVector();
            position.fromObject( object.Position );

            quality = uint( object.Quality );

            trackingID = object.TrackingID;

            trackingState = object.TrackingState;

            userIndex = object.UserIndex;
        }


        public function getJointByID( jointID:uint ):Joint
        {
            return joints[ jointID ];
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