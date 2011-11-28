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
    public class SkeletonFrame
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var floorClipPlane:KinSenceVector;
        public var frameNumber:int;
        public var normalToGravity:KinSenceVector;
        public var quality:uint;
        public var skeletons:Vector.<SkeletonData>;
        public var timeStamp:uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SkeletonFrame()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            floorClipPlane = new KinSenceVector();
            floorClipPlane.fromObject( object.FloorClipPlane );

            frameNumber = object.FrameNumber;

            normalToGravity = new KinSenceVector();
            normalToGravity.fromObject( object.NormalToGravity );

            quality = uint( object.Quality );

            skeletons = new Vector.<SkeletonData>();
            for each ( var skeletonObject:Object in object.Skeletons )
            {
                var skeletonData:SkeletonData = new SkeletonData();
                skeletonData.fromObject( skeletonObject );
                skeletons[ skeletons.length ] = skeletonData;
            }

            timeStamp = object.TimeStamp;
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