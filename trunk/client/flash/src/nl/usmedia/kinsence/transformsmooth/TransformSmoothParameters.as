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