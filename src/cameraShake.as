package 
{
	import net.flashpunk.*;
	
	public class cameraShake extends Entity
	{
		public static var cameraJitterCounter:int = 0;
		private static var saveCameraX:Number;
		private static var saveCameraY:Number;
		
		public function cameraShake() 
		{
			
		}
		
		public static function activateCameraJitter(jitterCount:int):void
		{
			if (cameraJitterCounter == 0) {  // if already shaking do nothing
				cameraJitterCounter = jitterCount;
				saveCameraX = FP.camera.x;  // save camera coords
				saveCameraY = FP.camera.y;
			}
		}
		
		override public function update():void
		{
			if (cameraJitterCounter > 0)
			{ 
				cameraJitterCounter--;
				if (cameraJitterCounter == 0)
				{
					FP.camera.x = saveCameraX;
					FP.camera.y = saveCameraY;
				}
				else
				{
					var cameraXOffset:Number = Math.random() * 20;  
					if (Math.random() < 0.5)
					{
						cameraXOffset = -cameraXOffset;
					}
					var cameraYOffset:Number = Math.random() * 20;
					if (Math.random() < 0.5)
					{
						cameraYOffset = -cameraYOffset;
					}					
					FP.camera.x = saveCameraX + cameraXOffset;
					FP.camera.y = saveCameraY + cameraYOffset;
				}
			}
		}
	}
}