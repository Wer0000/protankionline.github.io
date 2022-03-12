package protanki.launcher.controls.toppanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.LocalizedControl;
	import flash.net.SharedObject;
	
	public class TopPanel extends LocalizedControl
	{
		
		
		private static var topLineOld:Class = topLineOld_png;
		
		public static var topLineData:BitmapData = (new topLineOld() as Bitmap).bitmapData;
		
		private static var sharedObject:SharedObject = SharedObject.getLocal("launcherStorage");
		
		public function TopPanel()
		{
			super();
			addChild(new TopPanelButton("game"));
			addChild(new TopPanelButton("wiki"));
			addChild(new TopPanelButton("ratings"));
			addChild(new TopPanelButton("help"));
		}
		
		override protected function onResize(e:Event):void
		{
				var topLineData:BitmapData = (new topLineOld() as Bitmap).bitmapData;
			graphics.clear();
			graphics.beginBitmapFill(topLineData);
			graphics.drawRect(-1000, 0, 3000, topLineData.height);
			graphics.endFill();
		}
		

		
		override public function switchLocale(locale:Locale):void
		{
			var i:int = 0;
			var child:* = null;
			var offsetX:int = 20;
			for (i = 0; i < numChildren; )
			{
				if ((child = getChildAt(i)) is LocalizedControl)
				{
					(child as LocalizedControl).switchLocale(locale);
					if (child is TopPanelButton)
					{
						child.x = offsetX;
						offsetX += (child as TopPanelButton).BUTTON_WIDTH;
					}
				}
				i++;
			}
		}
		
		public function addAlignRight(obj:LocalizedControl):void
		{
			addChild(obj);
			obj.x = stage.stageWidth - obj.width - 10;
		}
	}
}
