package protanki.launcher.controls.bottompanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.LocalizedControl;
	import protanki.launcher.controls.bottompanel.LinkField.LinkField;
	import protanki.launcher.controls.bottompanel.PartnerLogo.PartnerLogo;
	
	public class BottomPanel extends LocalizedControl
	{
		
		private static var bottomLine:Class = panel_png$e67b3782353f75555851b480ca538f72352815433;
		
		public static var bottomLineData:BitmapData = (new bottomLine() as Bitmap).bitmapData;
		
		public static var bottomPanelHeight:int = 75;
		
		private static var panel:Shape = new Shape();
		
		private const rectangle:Rectangle = new Rectangle(9, 9, 1, 1);
		
		public function BottomPanel()
		{
			super();
		}
		
		public function createLines(locale:Locale):void
		{
			addPartners(locale);
			
			this.addLine(20, 40, 15, locale, LinkField.RULES, LinkField.KITS);
			//this.addLine(10, 40, 15, locale, LinkField.CONTACTS);
		
		}
		
		private function addPartners(locale:Locale):void
		{
			var i:int = 0;
			var type:* = null;
			var link:* = null;
			var partner:* = null;
			var offsetX:* = 40;
			var offsetY:* = 30;
			var gap:* = 10;
			for (i = locale.partners.length / 2; i >= 0; )
			{
				type = locale.partners[i * 2];
				link = locale.partners[i * 2 + 1];
				(partner = new PartnerLogo(type, link)).x = stage.stageWidth - offsetX;
				partner.y = offsetY;
				addChild(partner);
				offsetX += gap + partner.actualWidth;
				i--;
			}
		}
		
		override protected function onResize(e:Event):void
		{
			x = 5;
			y = stage.stageHeight - bottomPanelHeight;
			this.redrawPanel()
			panel.scaleX = (stage.stageWidth - 10) / panel.width;
			panel.scaleY = bottomPanelHeight / panel.height + 2;
			if (panel.parent == null)
			{
				addChild(panel);
			}
		
		}
		
		private function redrawPanel():void
		{
			var top:Number = NaN;
			var j:int = 0;
			var gridX:Array = [this.rectangle.left, this.rectangle.right, bottomLineData.width];
			var gridY:Array = [this.rectangle.top, this.rectangle.bottom, bottomLineData.height];
			panel.graphics.clear();
			var left:Number = 0;
			for (var i:int = 0; i < 3; i++)
			{
				top = 0;
				for (j = 0; j < 3; j++)
				{
					panel.graphics.beginBitmapFill(bottomLineData);
					panel.graphics.drawRect(left, top, gridX[i] - left, gridY[j] - top);
					panel.graphics.endFill();
					top = gridY[j];
				}
				left = gridX[i];
			}
			panel.scale9Grid = this.rectangle;
		}
		
		override public function switchLocale(locale:Locale):void
		{
			removeChildren();
			addChild(panel);
			createLines(locale);
		}
		
		private function addText(type:String, locale:Locale, x:int, y:int):LinkField
		{
			var linkField:LinkField = new LinkField(type, locale);
			linkField.x = x;
			linkField.y = y;
			addChild(linkField);
			return linkField;
		}
		
		private function addLine(x:int, y:int, gap:int, locale:Locale, ... args):void
		{
			var type:String = null;
			var lf:LinkField = null;
			var offsetX:int = x;
			for each (type in args)
			{
				lf = this.addText(type, locale, offsetX, y);
				offsetX += lf.getLineMetrics(0).width + gap;
			}
		}
	}
}
