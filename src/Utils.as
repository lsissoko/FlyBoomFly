package
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import net.flashpunk.utils.Input;

	/**
	 * A set of utility tools.
	 * 
	 * @author Rolpege, Lamine Sissoko
	 */
	public final class Utils
	{
		public static var flash:Flash = new Flash;

		public static function openURL(url:String):void
		{
			navigateToURL(new URLRequest(url));
		}

		public static function timeFormatter(num:Number):String
		{
			var time:int = int(num);
			var minutes:int = int(time/60);
			var seconds:int = time - (minutes*60);
			var milliseconds:Number = num-time;

			var secondString:String = seconds < 10 ? "0" + seconds : seconds.toString();

			return minutes + ":" + secondString + "." + milliseconds.toString().slice(2, 4);
		}
	}
}