package flash.display
{
    import flash.geom.Point;
    import flash.text.TextSnapshot;


    public interface IDisplayObjectContainer extends IInteractiveObject
	{
		/// Determines whether or not the children of the object are mouse enabled.
		function get mouseChildren () : Boolean;
		function set mouseChildren (enable:Boolean) : void;

		/// Returns the number of children of this object.
		function get numChildren () : int;

		/// Determines whether the children of the object are tab enabled.
		function get tabChildren () : Boolean;
		function set tabChildren (enable:Boolean) : void;

		/// Returns a TextSnapshot object for this DisplayObjectContainer instance.
		function get textSnapshot () : TextSnapshot;

		/// Adds a child object to this DisplayObjectContainer instance.
		function addChild (child:DisplayObject) : DisplayObject;

		/// Adds a child object to this DisplayObjectContainer instance.
		function addChildAt (child:DisplayObject, index:int) : DisplayObject;

		/// Indicates whether the security restrictions would cause any display objects to be omitted from the list returned by calling the DisplayObjectContainer.getObjectsUnderPoint() method with the specified point point.
		function areInaccessibleObjectsUnderPoint (point:Point) : Boolean;

		/// Determines whether the specified display object is a child of the DisplayObjectContainer instance or the instance itself.
		function contains (child:DisplayObject) : Boolean;

		/// Returns the child display object instance that exists at the specified index.
		function getChildAt (index:int) : DisplayObject;

		/// Returns the child display object that exists with the specified name.
		function getChildByName (name:String) : DisplayObject;

		/// Returns the index number of a child DisplayObject instance.
		function getChildIndex (child:DisplayObject) : int;

		/// Returns an array of objects that lie under the specified point and are children (or grandchildren, and so on) of this DisplayObjectContainer instance.
		function getObjectsUnderPoint (point:Point) : Array;

		/// Removes a child display object from the DisplayObjectContainer instance.
		function removeChild (child:DisplayObject) : DisplayObject;

		/// Removes a child display object, at the specified index position, from the DisplayObjectContainer instance.
		function removeChildAt (index:int) : DisplayObject;

		/// Changes the index number of an existing child.
		function setChildIndex (child:DisplayObject, index:int) : void;

		/// Swaps the z-order (front-to-back order) of the two specified child objects.
		function swapChildren (child1:DisplayObject, child2:DisplayObject) : void;

		/// Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list.
		function swapChildrenAt (index1:int, index2:int) : void;
	}
}
