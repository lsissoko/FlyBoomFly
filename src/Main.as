package 
{
	import net.flashpunk.debug.Console;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	import splash.Splash;
	[SWF(width = "640", height = "480", backgroundColor='#000000', frameRate='60')]
	
	/**
	 * Main class. Starts the game.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(640, 480, 60, false);
			FP.screen.color = 0x202020;
		}
		
		override public function init():void
		{
			Kongregate.connect(FP.stage);
			
			var s:Splash = new Splash;
			FP.world.add(s);
			s.start(splashComplete);
			
			//splashComplete();
		}
		
		public function splashComplete():void
		{			
			FP.world = new GameRoom;
			//FP.console.enable();
		}
		
		public static function mute():void
		{
			FP.volume = FP.volume > 0 ? 0 : 1;
			Data.writeBool("volume", FP.volume > 0);
			Data.save("chs.pref");
		}
		
	}
	
}