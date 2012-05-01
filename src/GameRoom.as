package  
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import GFX;
	
	/**
	 * Main game class. Handles gameplay.
	 * 
	 * @author Lamine Sissoko
	 */
	public class GameRoom extends World
	{
		/**
		 * Game variables
		 */
		private var spawnTimer:Number;
		private var spawnInterval:Number = 2.5;
		private static var explode:Emitter;
		
		private var player:Ship;
		
		private var alienCount:int = 0;
		private var alienMax:int = 6;
		
		private var regularPoints:int = 0; // number of points to unlock the REGULAR weapon
		private var spreaderPoints:int = 20; // number of points to unlock the SPREADER weapon
		private var chainPoints:int = 100; // number of points to unlock the CHAIN weapon
		
		private var scoreSubmitted:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function GameRoom()
		{
			/**
			 * Initialize colors
			 */
			FP.screen.color = 0x000000; // 0xC2C2C2;
			
			/**
			 * Start the music and initialize global sound values
			 */
			G.muted = false;
			FP.volume = 1;
			G.volumeMusic = 0.5;
			G.volumeSound = 0.3;
			SoundManager.currentMusic = SoundManager.background_music; // as3 setter
			
			/**
			 * Particle setup (completed in the overidden render() method below)
			 */
			explode = new Emitter(GFX.spr_explosion, 2, 2);
			explode.newType("explosion", [0]);
			explode.setMotion("explosion", 0, 50, 0.1, 360, 50, 0.9);

			/**
			 * Everything else
			 */
			add(new Scenery);
			add(player = new Ship);
			add(new HUD);
			add(new cameraShake);
			resetSpawnTimer();			
		}
		
		override public function update():void
		{			
			super.update();
			
			G.scoreText.updateText( new Array("SCORE: " + String(G.score)) );
			G.healthText.updateText( new Array("HEALTH: " + String(G.health)) );
			
			// Spawn new aliens (set a limit)
			spawnTimer -= FP.elapsed;
			alienCount = (int)(classCount(Alien));
			if (G.gameOver == false && spawnTimer < 0 && alienCount <= alienMax){
				spawnAlien();
				resetSpawnTimer();
			}
			explode.update();
			
			FP.camera.x += G.gameSpeed;
			
			weaponUpgrade();
			
			if (G.gameOver && Input.check(Key.ENTER)) {
				G.superReset();
				FP.world = new GameRoom;
			}
			
			if (Input.pressed(Key.M))
				Main.mute();
			
			// Submit score to Kongregate
			if (G.gameOver && scoreSubmitted==false && Input.pressed(Key.SPACE)) {
				Kongregate.submit("High Scores", G.score);
				G.gameOverText3.updateText(new Array("SCORE SUBMITTED"));
				G.gameOverText3.setColor(G.textColorOrange);
				scoreSubmitted = true;
			}
		}
		
		override public function render():void{
			//explode.render(new Point, FP.camera); // for FlashPunk 1.4
			explode.render(FP.buffer, new Point, FP.camera); // for FlashPunk 1.5
			super.render();
		}
		
		private function spawnAlien():void{
			var _x:Number = FP.screen.width + FP.camera.length;
			var _y:Number = Math.random() * (FP.screen.height - 100) +50;			
			/**
			 * As you get more points, the chances of a Big Alien spawning increase
			 */
			if (	(G.score >= 50 && new int(Math.random() * 60) == 0) ||
					(G.score >= 300 && new int(Math.random() * 50) == 0) ||
					(G.score >= 500 && new int(Math.random() * 40) == 0) ||
					(G.score >= 1000 && new int(Math.random() * 30) == 0)
				)
				add(new Alien(_x, _y, "big")); // aliens that fight back
			else
				add(new Alien(_x, _y)); // regular aliens
		}
		
		private function resetSpawnTimer():void{
			spawnTimer = spawnInterval;
			spawnInterval *= 0.95;
			if (spawnInterval < 0.1)
				spawnInterval = 0.1;
		}
		
		private function weaponUpgrade():void{
			if (G.score >= regularPoints && player.getArsenal().regular == false){
				player.upgradeWeapon("regular");
				G.arsenalText.concatText(" [Z]");
			}
			if (G.score >= spreaderPoints && player.getArsenal().spreader == false){
				player.upgradeWeapon("spreader");
				G.arsenalText.concatText(" [X]");
			}
			if (G.score >= chainPoints && player.getArsenal().chain == false){
				player.upgradeWeapon("chain");
				G.arsenalText.concatText(" [C]");
			}
		}
		
		public static function particleExplosion(_x:Number, _y:Number):void{
			for (var i:int = 0; i < 35; i++){
				explode.emit("explosion", _x, _y);
			}
		}
	}
	
}