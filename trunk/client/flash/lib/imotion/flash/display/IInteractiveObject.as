package flash.display
{
    import flash.accessibility.AccessibilityImplementation;
    import flash.ui.ContextMenu;


    public interface IInteractiveObject extends IDisplayObject
	{
		function get accessibilityImplementation () : AccessibilityImplementation;
		function set accessibilityImplementation (value:AccessibilityImplementation) : void;

		/// Specifies the context menu associated with this object.
		function get contextMenu () : ContextMenu;
		function set contextMenu (cm:ContextMenu) : void;

		/// Specifies whether the object receives doubleClick events.
		function get doubleClickEnabled () : Boolean;
		function set doubleClickEnabled (enabled:Boolean) : void;

		/// Specifies whether this object displays a focus rectangle.
		function get focusRect () : Object;
		function set focusRect (focusRect:Object) : void;

		/// Specifies whether this object receives mouse messages.
		function get mouseEnabled () : Boolean;
		function set mouseEnabled (enabled:Boolean) : void;

		/// Specifies whether this object is in the tab order.
		function get tabEnabled () : Boolean;
		function set tabEnabled (enabled:Boolean) : void;

		/// Specifies the tab ordering of objects in a SWF file.
		function get tabIndex () : int;
		function set tabIndex (index:int) : void;
	}
}
