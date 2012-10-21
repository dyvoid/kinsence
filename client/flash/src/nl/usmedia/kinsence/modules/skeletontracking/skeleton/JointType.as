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
    public class JointType
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const HIP_CENTER:uint = 0;
        public static const SPINE:uint = 1;
        public static const SHOULDER_CENTER:uint = 2;
        public static const HEAD:uint = 3;
        public static const SHOULDER_LEFT:uint = 4;
        public static const ELBOW_LEFT:uint = 5;
        public static const WRIST_LEFT:uint = 6;
        public static const HAND_LEFT:uint = 7;
        public static const SHOULDER_RIGHT:uint = 8;
        public static const ELBOW_RIGHT:uint = 9;
        public static const WRIST_RIGHT:uint = 10;
        public static const HAND_RIGHT:uint = 11;
        public static const HIP_LEFT:uint = 12;
        public static const KNEE_LEFT:uint = 13;
        public static const ANKLE_LEFT:uint = 14;
        public static const FOOT_LEFT:uint = 15;
        public static const HIP_RIGHT:uint = 16;
        public static const KNEE_RIGHT:uint = 17;
        public static const ANKLE_RIGHT:uint = 18;
        public static const FOOT_RIGHT:uint = 19;

        public static function getAll():Array
        {
            return [
                HIP_CENTER,
                SPINE,
                SHOULDER_CENTER,
                HEAD,
                SHOULDER_LEFT,
                ELBOW_LEFT,
                WRIST_LEFT,
                HAND_LEFT,
                SHOULDER_RIGHT,
                ELBOW_RIGHT,
                WRIST_RIGHT,
                HAND_RIGHT,
                HIP_LEFT,
                KNEE_LEFT,
                ANKLE_LEFT,
                FOOT_LEFT,
                HIP_RIGHT,
                KNEE_RIGHT,
                ANKLE_RIGHT,
                FOOT_RIGHT
            ]
        }
    }
}