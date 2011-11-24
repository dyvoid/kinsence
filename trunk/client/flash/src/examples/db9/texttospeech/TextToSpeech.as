package
examples.db9.texttospeech{
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.MP3Loader;
    import com.greensock.loading.data.MP3LoaderVars;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.system.Security;
    import flash.system.System;
    import flash.utils.setTimeout;


    /**
     * @author Pieter van de Sluis
     */
    public class TextToSpeech
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _language       :String;
        private var _speech         :Sound;
        private var _soundChannel   :SoundChannel;

        private var _loader         :MP3Loader;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TextToSpeech( language:String = "en" )
        {
//            Security.allowDomain( "translate.google.com" );

			_language = language;
            _speech = new Sound();
		}

		/**
		 * Use this to get the URL of the mp3 containing the spoken words of the 'phrase' parameter
		 * @param	phrase
		 * @return	String	URL to Google Text to Speech engine
		 */
		public function say( phrase:String ):void
        {
			if (phrase.length > 100) throw new Error("Google currently only supports phrases less than 100 characters in length.");

            var url:String = "http://translate.google.com/translate_tts";
            url += "?tl=" + _language + "&q=";
			url += phrase;

            var loader:MP3Loader = new MP3Loader( url, { autoPlay: true } );
            loader.load();
		}


        private function soundCompleteHandler( e:Event ):void
        {
            var channel:SoundChannel = e.target as SoundChannel;

            channel.stop();
            trace("complete");
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