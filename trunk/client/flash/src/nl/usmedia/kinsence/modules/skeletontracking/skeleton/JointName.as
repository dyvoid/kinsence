package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class JointName
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const HIP_CENTER:String = "HipCenter";
        public static const SPINE:String = "Spine";
        public static const SHOULDER_CENTER:String = "ShoulderCenter";
        public static const HEAD:String = "Head";
        public static const SHOULDER_LEFT:String = "ShoulderLeft";
        public static const ELBOW_LEFT:String = "ElbowLeft";
        public static const WRIST_LEFT:String = "WristLeft";
        public static const HAND_LEFT:String = "HandLeft";
        public static const SHOULDER_RIGHT:String = "ShoulderRight";
        public static const ELBOW_RIGHT:String = "ElbowRight";
        public static const WRIST_RIGHT:String = "WristRight";
        public static const HAND_RIGHT:String = "HandRight";
        public static const HIP_LEFT:String = "HipLeft";
        public static const KNEE_LEFT:String = "KneeLeft";
        public static const ANKLE_LEFT:String = "AnkleLeft";
        public static const FOOT_LEFT:String = "FootLeft";
        public static const HIP_RIGHT:String = "HipRight";
        public static const KNEE_RIGHT:String = "KneeRight";
        public static const ANKLE_RIGHT:String = "AnkleRight";
        public static const FOOT_RIGHT:String = "FootRight";

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