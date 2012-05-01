package
{
	import net.flashpunk.graphics.Backdrop;
	
	/**
	 * This class embeds all of the game's images and fonts.
	 * 
	 * @author Lamine Sissoko
	 */
	public final class GFX
	{
		/**
		 * Bullets
		 */
		[Embed(source = "assets/laserbeam.png")] public static const BULLET_REGULAR:Class;
		[Embed(source = "assets/laserbeam_spreader.png")] public static const BULLET_SPREADER:Class;
		[Embed(source = "assets/laserbeam_yellow.png")] public static const BULLET_CHAIN:Class;
		[Embed(source = "assets/laserbeam_red.png")] public static const BULLET_ALIEN:Class;
		
		/**
		 * Player and Alien
		 */
		[Embed(source = "assets/shippy_alt.png")] public static const spr_ship:Class;
		[Embed(source = "assets/alien_ship.png")] public static const spr_alien:Class;
		[Embed(source = "assets/alien_ship_big_red.png")] public static const spr_alienBig:Class;
		
		/**
		 * Backdrops
		 */	
		[Embed(source = "assets/bg_front_spacedust.png")] public static const spr_backdrop:Class;
		[Embed(source = "assets/bg_spacialanomaly.png")] public static const spr_backdrop_1:Class;
		[Embed(source = "assets/bg_galaxy.png")] public static const spr_backdrop_2:Class;
		
		/**
		 * Explosion particle
		 */
		[Embed(source = "assets/explosion_pink.png")] public static const spr_explosion:Class;
		
		/**
		 * Font for score and game over displays
		 * 
		 * (for Flex < 4 remove the [embdedAsCff = "false"] tag)
		 */
		[Embed(source = "assets/nokiafc22.ttf", embedAsCFF = "false", fontFamily = "nokiafc22")]
		public static const font:Class;
	}	
}