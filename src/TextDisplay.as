package
{
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * This class is a simple means for placing multiple lines of text
	 * on the game screen.
	 * 
	 * @author Lamine Sissoko
	 */
	public class TextDisplay extends Entity
	{
		//public var display:Text = new Text("", 0, 0, 640, 480);
		private var textContent:Text;
		private var xCentered:Boolean = false;
		private var yCentered:Boolean = false;
		private var xOffset:int = 0;
		private var yOffset:int = 0;
		
		// will be our graphic
		private var allText:Graphiclist;
		// holds the matching line break height
		private var lineBreakHeight:uint;
		// holds each line of text, String
		private var textContentArray:Array = new Array;
		
		private var textArrayX:Array = new Array;
		private var textArrayY:Array = new Array;
		private var lineBreakArray:Array = new Array;
		private var textHolder:Dictionary = new Dictionary;
		
		
		private var startSize:int;
		private var startColor:uint;
		private var startFont:String;
		
		private var flickerCount:int = 0;
		
		/**
		 * Constructor
		 */
		public function TextDisplay(_textArray:Array,
									_x:Number, 
									_y:Number, 
									_color:int, 
									_lineBreak:String = "",
									_size:int = 20, 
									_font:String = null, 
									_xOffset:int = 0, 
									_yOffset:int = 0 )
		{
			allText = new Graphiclist;
			lineBreakHeight = new Text(_lineBreak).height / 2;			
			startColor = _color;
			startFont = _font;
			startSize = _size;
			
			// change display Text objects to match input parameters
			for (var i:int = 0; i < _textArray.length; i++){				
				textContent = new Text(_textArray[i], _x, _y + i*lineBreakHeight, 640, 480);
				textContent.color = _color;
				textContent.size = _size;
				textContent.font = _font;
				
				allText.add(textContent);
				textContentArray.push(textContent);
				lineBreakArray.push(i * lineBreakHeight);
				textArrayX.push(_x);
				textArrayY.push(_y + i * lineBreakHeight);
			}
			
			// super class Entity constructor takes (x, y, graphic)
			super(_x, _y, allText);
			graphic.scrollX = 0;
			this.xOffset = _xOffset;
			this.yOffset = _yOffset;
		}
		
		/**
		 * Writes out a different text (also updates position if text is centered)
		 */
		public function updateText(newText:Array):void {
			allText.removeAll();
			textContentArray = new Array;
			lineBreakArray = new Array;
			
			for (var i:int = 0; i < newText.length; i++){				
				textContent = new Text(newText[i], textArrayX[i], textArrayY[i], 640, 480);
				// keep the same atrributes from when we first created the TextDisplay
				textContent.color = startColor;
				textContent.size = startSize;
				textContent.font = startFont;				
				
				allText.add(textContent);
				textContentArray.push(textContent);
				lineBreakArray.push(i * lineBreakHeight);
			}
		}
		
		/**
		 * Adds text to the end of current text (also updates position if text is centered)
		 */
		public function concatText(endText:String):void {
			textContent.text += endText;
			centerText(xCentered, yCentered);
		}
		
		/**
		 * Centers the TextDisplay object on our chosen coordinates.
		 * 
		 * @param	_x Whether the TextDisplay should be horizontally centered
		 * @param	_y Whether the TextDisplay should be vertically centered
		 */
		public function centerText(_x:Boolean = true, _y:Boolean = true):void {
			var t:Text;
			var i:int;
			if (_x==true) {		
				allText.removeAll();
				for (i = 0; i < textContentArray.length; i++) {
					t = textContentArray[i];
					t.x = FP.width / 2 - t.width / 2 + xOffset;
					allText.add(t);
				}
				graphic = allText;				
				xCentered = true;
			}
			else {
				xCentered = false;
			}
			
			if (_y==true) {
				allText.removeAll();
				for (i = 0; i < textContentArray.length; i++) {
					t = textContentArray[i];
					t.y = FP.height / 2 - t.height / 2 + yOffset + lineBreakArray[i];
					allText.add(t);
				}
				graphic = allText;
				yCentered = true;
			}
			else {
				yCentered = false;
			}
		}
		
		/**
		 * Aligns the TextDisplay to the right
		 * 
		 * @param	_x	Number of pixels between the end of our text and the right edge of the screen
		 * @param	_y	The y coordinate of our text
		 */
		public function rightText(_x:int, _y:int):void {
			graphic.x = FP.width - textContent.width - 1*_x;
			graphic.y = _y;
		}
		
		public function setOffset(_xOffset:int, _yOffset:int):void {
			xOffset = _xOffset;
			yOffset = _yOffset;
		}
		
		public function setFont(newFont:String):void {
			startFont = newFont;
			allText.removeAll();
			for each(var t:Text in textContentArray){				
				t.font = newFont;
				allText.add(t);
			}
			graphic = allText;
		}
		
		public function setColor(newColor:uint):void {
			startColor = newColor;
			allText.removeAll();
			for each(var t:Text in textContentArray){				
				t.color = newColor;
				allText.add(t);
			}
			graphic = allText;
		}
	}
	
}