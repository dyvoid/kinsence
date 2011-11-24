package flash.display
{
    import flash.accessibility.AccessibilityProperties;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Transform;


    public interface IDisplayObject extends IEventDispatcher
	{
		/// The current accessibility options for this display object.
		function get accessibilityProperties () : AccessibilityProperties;
		function set accessibilityProperties (value:AccessibilityProperties) : void;

		/// Indicates the alpha transparency value of the object specified.
		function get alpha () : Number;
		function set alpha (value:Number) : void;

		/// A value from the BlendMode class that specifies which blend mode to use.
		function get blendMode () : String;
		function set blendMode (value:String) : void;

		/// If set to true, Flash Player caches an internal bitmap representation of the display object.
		function get cacheAsBitmap () : Boolean;
		function set cacheAsBitmap (value:Boolean) : void;

		/// An indexed array that contains each filter object currently associated with the display object.
		function get filters () : Array;
		function set filters (value:Array) : void;

		/// Indicates the height of the display object, in pixels.
		function get height () : Number;
		function set height (value:Number) : void;

		/// Returns a LoaderInfo object containing information about loading the file to which this display object belongs.
		function get loaderInfo () : LoaderInfo;

		/// The calling display object is masked by the specified mask object.
		function get mask () : DisplayObject;
		function set mask (value:DisplayObject) : void;

		/// Indicates the x coordinate of the mouse position, in pixels.
		function get mouseX () : Number;

		/// Indicates the y coordinate of the mouse position, in pixels.
		function get mouseY () : Number;

		/// Indicates the instance name of the DisplayObject.
		function get name () : String;
		function set name (value:String) : void;

		/// Specifies whether the display object is opaque with a certain background color.
		function get opaqueBackground () : Object;
		function set opaqueBackground (value:Object) : void;

		/// Indicates the DisplayObjectContainer object that contains this display object.
		function get parent () : DisplayObjectContainer;

		/// For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file.
		function get root () : DisplayObject;

		/// Indicates the rotation of the DisplayObject instance, in degrees, from its original orientation.
		function get rotation () : Number;
		function set rotation (value:Number) : void;

		/// The current scaling grid that is in effect.
		function get scale9Grid () : Rectangle;
		function set scale9Grid (innerRectangle:Rectangle) : void;

		/// Indicates the horizontal scale (percentage) of the object as applied from the registration point.
		function get scaleX () : Number;
		function set scaleX (value:Number) : void;

		/// Indicates the vertical scale (percentage) of an object as applied from the registration point of the object.
		function get scaleY () : Number;
		function set scaleY (value:Number) : void;

		/// The scroll rectangle bounds of the display object.
		function get scrollRect () : Rectangle;
		function set scrollRect (value:Rectangle) : void;

		/// The Stage of the display object.
		function get stage () : Stage;

		/// An object with properties pertaining to a display object's matrix, color transform, and pixel bounds.
		function get transform () : Transform;
		function set transform (value:Transform) : void;

		/// Indicates the width of the display object, in pixels.
		function get width () : Number;
		function set width (value:Number) : void;

		/// Whether or not the display object is visible.
		function get visible () : Boolean;
		function set visible (value:Boolean) : void;

		/// Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.
		function get x () : Number;
		function set x (value:Number) : void;

		/// Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer.
		function get y () : Number;
		function set y (value:Number) : void;

		/// Returns a rectangle that defines the area of the display object relative to the coordinate system of the targetCoordinateSpace object.
		function getBounds (targetCoordinateSpace:DisplayObject) : Rectangle;

		/// Returns a rectangle that defines the boundary of the display object, based on the coordinate system defined by the targetCoordinateSpace parameter, excluding any strokes on shapes.
		function getRect (targetCoordinateSpace:DisplayObject) : Rectangle;

		/// Converts the point object from Stage (global) coordinates to the display object's (local) coordinates.
		function globalToLocal (point:Point) : Point;

		/// Evaluates the display object to see if it overlaps or intersects with the display object passed as a parameter.
		function hitTestObject (obj:DisplayObject) : Boolean;

		/// Evaluates the display object to see if it overlaps or intersects with a point specified by x and y.
		function hitTestPoint (x:Number, y:Number, shapeFlag:Boolean = false) : Boolean;

		/// Converts the point object from the display object's (local) coordinates to the Stage (global) coordinates.
		function localToGlobal (point:Point) : Point;
	}
}
