package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class SkeletonFrameQualityFlag
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const CAMERA_MOTION       :uint = 0x00000001;
        public static const EXTRAPOLATED_FLOOR  :uint = 0x00000010;
        public static const UPPER_BODY_SKELETON :uint = 0x00000100;
        
    }
}