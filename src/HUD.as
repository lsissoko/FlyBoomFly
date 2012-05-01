package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	
	/**
	 * This class initializes and adds our global TextDisplay objects
	 * 
	 * @author Lamine Sissoko
	 */
	public final class HUD extends Entity
	{		
		public function HUD()
		{			
			var lineBreak:uint =  new Text("\n\n\n\n\n").height;
			var lineSkip:String = "\n\n\n\n\n";
			var gameOverTextMessage:Array = new Array("GAME OVER",
								"PRESS <ENTER> TO PLAY AGAIN",
								"PRESS <SPACE> TO SUBMIT SCORE"	);
			G.gameOverText = new TextDisplay(gameOverTextMessage, 0, 0, G.textColor, lineSkip, 16, "nokiafc22", 0, -1*lineBreak/2);
			G.gameOverText.centerText();
			G.gameOverText.graphic.visible = false;
				
			G.chainText = new TextDisplay(new Array(""), 10, 8, G.textColor, "", 12, "nokiafc22");
			G.healthText = new TextDisplay(new Array("HEALTH: " + String(G.score)), 10, FP.height - 60, G.textColor, "", 12, "nokiafc22");
			G.scoreText = new TextDisplay(new Array("SCORE: " + String(G.score)), 10, FP.height - 42, G.textColor, "", 12, "nokiafc22");			
			G.arsenalText = new TextDisplay(new Array("WEAPONS:"), 10, FP.height - 24, G.textColor, "", 12, "nokiafc22");
			
			G.creditsTextLamine = new TextDisplay(new Array("Programming + Music by Lamine Sissoko"), 0, 0, G.textColor, "", 12, "nokiafc22");
			G.creditsTextLamine.rightText(10, FP.height - 42);
			
			G.creditsTextVicki = new TextDisplay(new Array("Art by Vicki Wenderlich"), 0, 0, G.textColor, "", 12, "nokiafc22");
			G.creditsTextVicki.rightText(10, FP.height - 24);
			
			/**
			 * Add Text objects to screen
			 */			
			graphic = new Graphiclist(G.gameOverText.graphic,
						G.healthText.graphic,
						G.scoreText.graphic,
						G.arsenalText.graphic,
						G.chainText.graphic,
						G.creditsTextLamine.graphic,
						G.creditsTextVicki.graphic );
			
			layer = -100;
		}
		
		public static function upgradeDisplayCountdown():void {
			if(Math.floor(G.upgradeTicker) > 0) {
				G.upgradeTicker -= 1 / 60; // countdown to 0 while ticker > 0 (int value)
			}
			else if (Math.floor(G.upgradeTicker) == 0) {
				G.upgradeTicker = -1; // set back to negative				
				removeUpgradeText();
			}
		}
		public static function removeUpgradeText():void {
			FP.world.remove(G.upgradeText);
		}
		
		public static function spreaderWeaponCooldown():void {
			if(G.spreaderTicker > 0) {
				G.spreaderTicker -= 1 / 60; // countdown to 0 while ticker > 0 (int value)
			}
			else if (G.spreaderTicker <= 0){
				G.spreaderCooldown = false; // end cooldown
			}
		}
		
		public static function chainWeaponCooldown():void {
			/**
			 * Show the CHAIN energy / Show the CHAIN cooldown time
			 */
			if (G.chainCooldown==true)
				G.chainText.updateText( new Array("CHAIN COOLDOWN: " + String(Math.floor(G.chainTicker))) );
			else if (G.chainCooldown == false) {
				var energyLeft:int = G.chainEnergy - Math.floor(G.chainTicker);
				G.chainText.updateText( new Array("CHAIN ENERGY: " + String(energyLeft)) );
				
				// You can use the CHAIN for about G.chainEnergy seconds before cooldown begins
				if(Math.floor(G.chainTicker) == G.chainEnergy){
					G.chainCooldown = true;
					G.chainTicker = G.chainCooldownTime; // set the ticker to the cooldown start value
					G.chainText.setColor(G.textColorOrange); // change color to show CHAIN cooldown level
				}
			}
			
			// Continue to countdown towards cooldown end
			if (Math.floor(G.chainTicker) > 0 && G.chainCooldown==true) {
				G.chainTicker -= 1 / 60;
			}
			// Clear text and flag cooldown end
			else if (Math.floor(G.chainTicker) == 0) {
				G.chainCooldown = false;
				G.chainText.setColor(G.textColor); // change color to show CHAIN energy level
			}
		}
	}
}