package  
{
	import net.flashpunk.*
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	/**
	 * Player class.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Ship extends Entity
	{
		private var shipMap:Spritemap = new Spritemap(GFX.spr_ship, 64, 32);
		private var arsenal:Object = { regular: false, spreader: false, chain: false };
		private var weaponType:String = "regular";
		
		/**
		 * Constructor
		 */
		public function Ship()
		{
			shipMap.add("resting", [0, 1], 12, true);
			shipMap.add("moving", [2, 3], 12, true);
			graphic = shipMap;
			shipMap.play("resting");
			x = 50;
			y = 150; // 50;
			setHitbox(27, 21, -24, -7); // to offset a hitbox coordinate by A we set its origin to -1*A
			type = "ship";
		}
		
		override public function render():void 
		{
			super.render();
			//Draw.hitbox(this);
		}
		
		override public function update():void
		{
			move();
			constrain();
			shoot();
			collision();
			HUD.upgradeDisplayCountdown();
			if(arsenal.spreader)
				HUD.spreaderWeaponCooldown();
			if(arsenal.chain)
				HUD.chainWeaponCooldown();
		}
		
		/**
		 * Translate input to player movement
		 */
		private function move():void
		{
			var speed:int = G.shipSpeed;
			
			shipMap.play("resting");
			
			// Limit diagonal movement speed
			if( (Input.check(Key.LEFT) || Input.check(Key.RIGHT)) && (Input.check(Key.UP) || Input.check(Key.DOWN)) )
				speed *= 0.8;
			
			if (Input.check(Key.RIGHT)){
				x += speed * FP.elapsed;
				shipMap.play("moving"); // engine thrust only if we're moving right
			}				
			if (Input.check(Key.LEFT)){
				x -= speed * FP.elapsed;
			}
			if (Input.check(Key.DOWN)){
				y += speed * FP.elapsed;
			}
			if (Input.check(Key.UP)){
				y -= speed * FP.elapsed;
			}
			//}
			
			// compensate for the camera movement (while not shaking)
			if(cameraShake.cameraJitterCounter==0)
				x += G.gameSpeed;
		}
		
		/**
		 * Keeps this object within the screen/camera's bounds
		 */
		private function constrain():void
		{
			if(x > FP.screen.width - width - 16 + FP.camera.length)
				x = FP.screen.width - width - 16 + FP.camera.length;
			else if(x < 16 + FP.camera.length)
				x = 16 + FP.camera.length;
			if(y > FP.screen.height - height - 16)
				y = FP.screen.height - height - 16;
			else if(y < 16)
				y = 16;
		}
		
		/**
		 * Handles shooting different weapons
		 */
		private function shoot():void
		{			
			// Regular gun
			if (Input.pressed(Key.Z)) {
				world.add(new Bullet(x + 2 * width, y + 12));
				SoundManager.i.playSound("BulletShot");
			}
			// Spreader gun
			else if(Input.pressed(Key.X) && arsenal.spreader == true && G.spreaderCooldown==false){
				world.add(new Bullet(x + 2 * width, y + 12, "spreader")); // bullet going straight
				
				var ySpeed:Number = 100 * FP.elapsed; // bullet vertical speed
					
				var bullet:Bullet = new Bullet(x + 2*width, y + 12, "spreader");
				bullet.setAccelerationY(ySpeed);
				world.add(bullet); // bullet going down/right
					
				bullet = new Bullet(x + 2*width, y + 12, "spreader");
				bullet.setAccelerationY(-ySpeed);
				world.add(bullet); // bullet going up/right
					
				SoundManager.i.playSound("BulletShot");
					
				G.spreaderCooldown = true;
				G.spreaderTicker = 0.3; // start cooldown
			}
			// Chain gun
			else if (Input.check(Key.C) && arsenal.chain == true && G.chainCooldown == false) {
				world.add(new Bullet(x + 2 * width, y + 12, "chain")); // chain of bullets going straight				
				G.chainTicker += 1 / 60; // start ticking towards cooldown start
			}
		}
		
		/**
		 * Get the weapons list
		 */
		public function getArsenal():Object {
			return this.arsenal;
		}
		
		/**
		 * Upgrade the player's weapon and put a short text display
		 * 
		 * @param	newWeaponType The new weapon's name
		 */
		public function upgradeWeapon(newWeaponType:String):void {
			var trigger:String;
			if (newWeaponType == "regular"){
				arsenal.regular = true;
				trigger = "Z";
			}
			else if (newWeaponType == "spreader"){
				arsenal.spreader = true;
				trigger = "X";
			}
			else if(newWeaponType == "chain"){
				arsenal.chain = true;
				trigger = "C";
				G.chainText.updateText( new Array("CHAIN ENERGY: " + String(G.chainEnergy)) );
			}
			
			var message:String = "WEAPON UNLOCKED!";	
			var message2:String = (newWeaponType == "chain") ? "HOLD <" : "PRESS <";
			message2 += trigger + "> TO USE [" + newWeaponType.toLowerCase() + "].";
			var lineBreak:uint = new Text("\n\n\n").height;
			G.upgradeText = new TextDisplay(new Array(message, message2), 0, 0, 0x99FF00, "\n\n\n", 16, G.textFont, 0, -1*lineBreak/2);
			G.upgradeText.centerText();
			G.upgradeText.layer = -10;
			FP.world.add(G.upgradeText);
			
			G.upgradeTicker = 3; // start the timer to delete this upgrade text
		}
		
		/**
		 * Start ending the game if hit by an Alien or an Alien bullet
		 */
		private function collision():void{
			var alien:Alien = collide("alien", x, y) as Alien;
			var bullet:Bullet = collide("bullet", x, y) as Bullet;
			if ( alien || (bullet && bullet.bulletStyle == "alien") )
			{
				if(alien) alien.destroy();
				if (bullet) bullet.destroy();
				cameraShake.activateCameraJitter(20);
				SoundManager.i.playSound("ExplosionShip");
				
				if (G.health > 0)
					G.health--;
				if (G.health <= 0) {
					// Initiate destruction
					this.destroy();
					HUD.removeUpgradeText();
					GameRoom.particleExplosion(x, y);
					
					// Display game over message
					G.gameOverText.graphic.visible = true;
					G.chainText.graphic.visible = false;
					
					// Stop music and flag game over
					SoundManager.stopMusic();
					G.gameOver = true;
				}
			}
		}
		
		public function destroy():void{
			FP.world.remove(this);
		}
	}

}