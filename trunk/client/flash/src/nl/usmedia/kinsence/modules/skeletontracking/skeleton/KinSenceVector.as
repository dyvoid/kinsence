package nl.usmedia.kinsence.modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public class KinSenceVector
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var w:Number;
        public var x:Number;
        public var y:Number;
        public var z:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function KinSenceVector( x:Number = NaN, y:Number = NaN, z:Number = NaN, w:Number = NaN )
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
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


        public function fromObject( object:Object ):void
        {
            w = object.W;
            x = object.X;
            y = object.Y;
            z = object.Z;
        }
    }
}