package
nl.usmedia.kinsence.modules.skeletontracking.skeleton{
    /**
     * @author Pieter van de Sluis
     */
    public class JointID
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