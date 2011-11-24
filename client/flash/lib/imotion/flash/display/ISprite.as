package flash.display
{
    import flash.geom.Rectangle;
    import flash.media.SoundTransform;


    public interface ISprite extends IDisplayObjectContainer
	{
		/// Specifies the button mode of this sprite.
		function get buttonMode () : Boolean;
		function set buttonMode (value:Boolean) : void;

		/// Specifies the display object over which the sprite is being dragged, or on which the sprite was dropped.
		function get dropTarget () : DisplayObject;

		/// Specifies the Graphics object that belongs to this sprite where vector drawing commands can occur.
		function get graphics () : Graphics;

		/// Designates another sprite to serve as the hit area for a sprite.
		function get hitArea () : Sprite;
		function set hitArea (value:Sprite) : void;

		/// Controls sound within this sprite.
		function get soundTransform () : SoundTransform;
		function set soundTransform (sndTransform:SoundTransform) : void;

		/// A Boolean value that indicates whether the pointing hand (hand cursor) appears when the mouse rolls over a sprite in which the buttonMode property is set to true.
		function get useHandCursor () : Boolean;
		function set useHandCursor (value:Boolean) : void;

		/// Lets the user drag the specified sprite.
		function startDrag (lockCenter:Boolean = false, bounds:Rectangle = null) : void;

		/// Ends the startDrag() method.
		function stopDrag () : void;

		function toString () : String;
	}
}
