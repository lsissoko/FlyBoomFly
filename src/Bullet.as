package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Draw;
	
	/**
	 * Bullet class.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Bullet extends Entity
	{
		private var xAccel:Number,
					yAccel:Number;
		public var bulletStyle:String;
		
		public function Bullet(_x:Number, _y:Number, _bulletStyle:String = "normal")
		{
			x = _x;
			y = _y;
			setHitbox(16, 4);
			type = "bullet";
			
			bulletStyle = _bulletStyle;
			
			if (bulletStyle.toLowerCase() == "chain"){
				graphic = new Image(GFX.BULLET_CHAIN);
				setHitbox(8, 3);
			}
			else if (bulletStyle.toLowerCase() == "spreader")
				graphic = new Image(GFX.BULLET_SPREADER);
			else if (bulletStyle.toLowerCase() == "alien")
				graphic = new Image(GFX.BULLET_ALIEN);
			else
				graphic = new Image(GFX.BULLET_REGULAR);
		}
		
		override public function render():void 
		{
			super.render();
			//Draw.hitbox(this);
		}
		
		override public function update():void
		{
			// Determine bullet direction and speed
			if (bulletStyle == "alien") {
				var dir:int = -1;
				var speed:Number = G.enemyBulletSpeed;
			}
			else {
				dir = 1;
				speed = G.bulletSpeed;
			}			
			
			// Move the bullet
			if (xAccel)
				x += dir * xAccel;
			else
				x += dir * speed * FP.elapsed;
				
			if (yAccel)
				y += dir * yAccel;
			
			// Destroy if bullet leaves the screen
			if (x > FP.screen.width + FP.camera.length)
				destroy();
			
			// compensate for the camera movement
			x += 2;
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
		
		public function setAccelerationX(_xAccel:Number):void {			
			xAccel = _xAccel;
		}
		public function setAccelerationY(_yAccel:Number):void {
			yAccel = _yAccel;
		}
	}

}