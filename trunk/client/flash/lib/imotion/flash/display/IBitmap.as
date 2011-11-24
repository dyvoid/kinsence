package flash.display
{

	public interface IBitmap extends IDisplayObject
	{
		/// The BitmapData object being referenced.
		function get bitmapData () : BitmapData;
		function set bitmapData (value:BitmapData) : void;

		/// Controls whether or not the Bitmap object is snapped to the nearest pixel.
		function get pixelSnapping () : String;
		function set pixelSnapping (value:String) : void;

		/// Controls whether or not the bitmap is smoothed when scaled.
		function get smoothing () : Boolean;
		function set smoothing (value:Boolean) : void;
	}
}
