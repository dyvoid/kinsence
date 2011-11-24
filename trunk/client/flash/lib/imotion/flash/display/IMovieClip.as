package flash.display
{
	
	public interface IMovieClip extends ISprite
	{
		/// Specifies the number of the frame in which the playhead is located in the timeline of the MovieClip instance.
		function get currentFrame () : int;

		/// The current label in which the playhead is located in the timeline of the MovieClip instance.
		function get currentLabel () : String;

		/// Returns an array of FrameLabel objects from the current scene.
		function get currentLabels () : Array;

		/// The current scene in which the playhead is located in the timeline of the MovieClip instance.
		function get currentScene () : Scene;

		/// A Boolean value that indicates whether a movie clip is enabled.
		function get enabled () : Boolean;
		function set enabled (value:Boolean) : void;

		/// The number of frames that are loaded from a streaming SWF file.
		function get framesLoaded () : int;

		/// An array of Scene objects, each listing the name, the number of frames, and the frame labels for a scene in the MovieClip instance.
		function get scenes () : Array;

		/// The total number of frames in the MovieClip instance.
		function get totalFrames () : int;

		/// Indicates whether other display objects that are SimpleButton or MovieClip objects can receive mouse release events.
		function get trackAsMenu () : Boolean;
		function set trackAsMenu (value:Boolean) : void;

		/// [Undocumented] Takes a collection of frame (zero-based) - method pairs that associates a method with a frame on the timeline.
		function addFrameScript (frame:int, method:Function) : void;

		/// Starts playing the SWF file at the specified frame.
		function gotoAndPlay (frame:Object, scene:String = null) : void;

		/// Brings the playhead to the specified frame of the movie clip and stops it there.
		function gotoAndStop (frame:Object, scene:String = null) : void;

		/// Sends the playhead to the next frame and stops it.
		function nextFrame () : void;

		/// Moves the playhead to the next scene of the MovieClip instance.
		function nextScene () : void;

		/// Moves the playhead in the timeline of the movie clip.
		function play () : void;

		/// Sends the playhead to the previous frame and stops it.
		function prevFrame () : void;

		/// Moves the playhead to the previous scene of the MovieClip instance.
		function prevScene () : void;

		/// Stops the playhead in the movie clip.
		function stop () : void;
	}
}
