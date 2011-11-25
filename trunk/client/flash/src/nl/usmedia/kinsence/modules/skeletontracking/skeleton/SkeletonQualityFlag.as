package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class SkeletonQualityFlag
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const CLIPPED_RIGHT   :uint = 0x00000001;
        public static const CLIPPED_LEFT    :uint = 0x00000010;
        public static const CLIPPED_TOP     :uint = 0x00000100;
        public static const CLIPPED_BOTTOM  :uint = 0x00001000;

    }
}