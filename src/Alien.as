package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import GFX;
	
	/**
	 * Enemy class.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Alien extends Entity
	{
		private var alienMap:Spritemap;
		private var alienStyle:String;
		private var health:int;
		private var bulletOffset:int = 12;		
		private var shotTimer:Number = 0;
		private var flickering:Boolean = false;
		
		public function Alien(_x:Number,_y:Number, _alienStyle:String = "normal"):void 
		{
			x = _x;
			y = _y;
			setHitbox(70, 29);
			alienStyle = _alienStyle;
			if (alienStyle == "big") {
				alienMap = new Spritemap(GFX.spr_alienBig, 209, 76);
				graphic = alienMap; // new Image(GFX.spr_alienBig);
				alienMap.add("anim1", [0], 15);
				alienMap.add("anim2", [0, 1], 15);
				setHitbox(209, 76);
				bulletOffset = 48;
				health = 5;
			}
			else{
				graphic = new Image(GFX.spr_alien);
				health = 1;
			}
			type = "alien";
		}
		
		override public function render():void 
		{
			super.render();
			//Draw.hitbox(this);
		}
		
		override public function update():void
		{				
			// Movement
			// regular Alien moves to the left, big Alien gets on-screen then stays to the right
			var rightPos:Boolean = (alienStyle == "big" && x >= FP.camera.length + FP.width * (3 / 5));
			if (alienStyle != "big" || rightPos)
				x -= G.alienSpeed * FP.elapsed;
			y += (Math.cos(x / 50) * 50) * FP.elapsed;
			
			// compensate for the camera movement
			x += G.gameSpeed;
			
			// Big Alien shoots bullets
			if (alienStyle == "big" && new int(Math.random()*100) == 0) {
				world.add(new Bullet(x - 5, y + bulletOffset, "alien"));
				SoundManager.i.playSound("AlienBulletShot");
			}
			
			// Kill if completely off-screen or if game ends
			if (x < FP.camera.length - this.width || G.gameOver==true)
				destroy();
			
			// Hurt if hit by a Ship bullet
			var bullet:Bullet = collide("bullet", x, y) as Bullet;
			if ( (bullet && bullet.bulletStyle != "alien") ) 
			{
				bullet.destroy();
				
				if (!flickering)
				{
				if (alienStyle == "big") {
					alienMap.play("anim2");
					shotTimer += 1 / 60;
					flickering = true;
				}
					
				if (health > 0){
					health--;
				}
				if (health <= 0){
					destroy();
					SoundManager.i.playSound("ExplosionAlien");
					GameRoom.particleExplosion(x, y);
					// Update score accordingly
					if (alienStyle == "big") G.score += 10;
					else G.score++;
				}				
				}
			}
			
			// check to see if Alien should flicker
			if (shotTimer > 0)
				shotTimer += 1 / 60;
			if (Math.floor(shotTimer) == 1){
				shotTimer = 0;
				flickering = false;
				alienMap.play("anim1");
			}
		}
		
		public function destroy():void{
			FP.world.remove(this)
		}
	}
	
}