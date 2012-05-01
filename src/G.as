package
{
	import net.flashpunk.tweens.misc.Alarm;
	/**
	 * This class holds our game's global variables.
	 * 
	 * @author Lamine Sissoko
	 */
	public final class G
	{
		/**
		 * Constants
		 */
		public static const startHealth:int = 10;
		public static const gameSpeed:int = 4;
		public static const shipSpeed:int = 250;
		public static const alienSpeed:int = 275;
		public static const bulletSpeed:int = 1000;
		public static const enemyBulletSpeed:int = 700;
		
		public static const chainEnergy:int = 10;
		public static const chainCooldownTime:int = 35;
		
		public static const textColor:uint = 0xFFFFFF;
		public static const textColorOrange:uint = 0xFF9900;
		public static const textColorTeal:uint = 0x00CC99;
		public static const textColorYellow:uint = 0x99FF00;		
		public static const textFont:String = "nokiafc22";
		public static const textSizeBig:int = 16;
		public static const textSizeMed:int = 34;
		public static const textSizeSmall:int = 12;
		
		/**
		 * Variables
		 */
		public static var volumeMusic:Number;
		public static var volumeSound:Number;
		public static var muted:Boolean;
		
		public static var score:int = 0;
		public static var health:int = startHealth;
		public static var gameOver:Boolean = false;
		
		public static var creditsTextLamine:TextDisplay;		
		public static var creditsTextVicki:TextDisplay;
		public static var scoreText:TextDisplay;
		public static var upgradeText:TextDisplay;
		public static var healthText:TextDisplay;
		public static var gameOverText:TextDisplay;
		public static var gameOverText1:TextDisplay;
		public static var gameOverText2:TextDisplay;
		public static var gameOverText3:TextDisplay;
		public static var arsenalText:TextDisplay;
		public static var chainText:TextDisplay;
		public static var chainEnergyText:TextDisplay;
		public static var chainCooldownText:TextDisplay;
		
		public static var upgradeTextHolder:Array = new Array;
		public static var upgradeTicker:Number = -1;
		public static var spreaderTicker:Number = 0;
		public static var chainTicker:Number = 0;
		
		public static var spreaderCooldown:Boolean = false;
		public static var chainCooldown:Boolean = false;
		
		/**
		 * Resets some of the above variables
		 */
		public static function superReset():void {
				spreaderCooldown = false;
				chainCooldown = false;
				score = 0;
				health = startHealth;
				upgradeTicker = -1;
				spreaderTicker = 0;
				chainTicker = 0;
				gameOver = false;
		}
	}	
}