using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinSence.Util
{
    public class Range
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private double boundary1;
        private double boundary2;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        /**
		 * Constructs a new <code>Range</code>
		 * @param	boundary1 the first boundary value of the range
		 * @param	boundary2 the second boundary value of the range
		 */
        public Range( double boundary1, double boundary2 )
        {
            this.boundary1 = boundary1;
            this.boundary2 = boundary2;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        /**
		 * Translates a value in the range to a relative position (0-1).
		 * The input value is automatically constrained to the boundaries of the range.
		 * @param	value a value within the range
		 * @return	the relative position within the range
		 */
        public double GetRelativePosFromValue( double value )
        {
            value = Constrain( value );

            return Math.Abs( value - boundary1 ) / Size;
        }


        /**
         * Translates a relative position (0-1) to a value within the range.
         * The input value is automatically constrained to 0-1.
         * @param	relativePos the relative position
         * @return	the value within the range
         */
        public double GetValueFromRelativePos( double relativePos )
        {
            relativePos = ConstrainTo( relativePos, 0, 1 );

            double result;

            if ( boundary2 > boundary1 )
            {
                result = boundary1 + ( relativePos * Size );
            }
            else
            {
                result = boundary1 - ( relativePos * Size );
            }

            return result;
        }


        /**
         * Translates a value within this range to a value in a target range
         * @param	value a value within the boundaries of this range
         * @param	targetRange the target range that the value should be translated to
         * @return	the translated value
         */
        public double Translate( double value, Range targetRange )
        {
            return targetRange.GetValueFromRelativePos( GetRelativePosFromValue( value ) );
        }


        /**
		 * Constrains a value to the boundaries of the range
		 * @param	value the value that should be constrained
		 * @return	the constrained value
		 */
        public double Constrain( double value )
        {
            if ( boundary2 > boundary1 )
            {
                return ConstrainTo( value, boundary1, boundary2 );
            }
            else
            {
                return ConstrainTo( value, boundary2, boundary1 );
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        /**
		 * Constrains a value to an upper and lower limit
		 * @param	value the value that should be constrained
		 * @param	lower the lower limit
		 * @param	upper the upper limit
		 * @return	the constrained value
		 */
        private double ConstrainTo( double value, double lower, double upper )
        {
            if ( value > upper )
                return upper;
            if ( value < lower )
                return lower;
            return value;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        /**
		 * The total size of the range
		 */
        public double Size
        {
            get
            {
                double c = ( boundary2 - boundary1 );
                return c > 0 ? c : -c;
            }
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}
