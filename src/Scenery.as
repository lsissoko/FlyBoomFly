package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Graphiclist;
	
	/**
	 * This class handles our Backdrops.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Scenery extends Entity
	{		
		private var backdrop:Backdrop;
		private var backdrop1:Backdrop;
		private var backdrop2:Backdrop;
		
		public function Scenery():void{
			backdrop = new Backdrop(GFX.spr_backdrop, true);
			backdrop.scrollX = 0.5;
			backdrop.scrollY = 0.5;
			backdrop.alpha = 0.8;
			//addGraphic(backdrop);
			
			backdrop1 = new Backdrop(GFX.spr_backdrop_1, true);
			backdrop1.scrollX = 0.5;
			backdrop1.scrollY = 0.5;
			backdrop1.alpha = 0.8;
			//addGraphic(backdrop1);
			
			backdrop2 = new Backdrop(GFX.spr_backdrop_2, true);
			backdrop2.scrollX = 0.8;
			backdrop2.scrollY = -0.8;
			backdrop2.alpha = 0.8;
			//addGraphic(backdrop2);
			
			graphic = new Graphiclist(backdrop, backdrop1, backdrop2);
		}
		
		override public function update():void {
			// Make the backdrops scroll
			backdrop.x -= FP.elapsed * 20;
			backdrop.y -= FP.elapsed * 10;
			
			backdrop1.x -= FP.elapsed * 20;
			backdrop1.y -= FP.elapsed * 10;
			
			backdrop2.x -= FP.elapsed * 10;
			backdrop2.y += FP.elapsed * 10;
		}
	}
}