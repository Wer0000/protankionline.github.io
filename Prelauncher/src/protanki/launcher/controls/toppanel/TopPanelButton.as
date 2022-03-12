package protanki.launcher.controls.toppanel
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Mouse;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.LocalizedControl;
	import protanki.launcher.makeup.MakeUp;
	import flash.net.SharedObject;
	
	public class TopPanelButton extends LocalizedControl
	{
		
		public static const GAME:String = "game";
		
		public static const MATERIALS:String = "materials";
		
		public static const TOURNAMENTS:String = "tournaments";
		
		public static const FORUM:String = "forum";
		
		public static const WIKI:String = "wiki";
		
		public static const RATINGS:String = "ratings";
		
		public static const HELP:String = "help";
		
		public var BUTTON_WIDTH:int = 125;
		
		private var textField:TextField;
		private var obj:DisplayObject;
		private var type:String;
		
		public function TopPanelButton(type:String)
		{
			super();
			this.type = type;
			addEventListener("mouseOut", mouseOut);
			addEventListener("mouseOver", mouseOver);
			addEventListener("click", mouseClick);
			redraw();
		}
		
		private function redraw():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, BUTTON_WIDTH, TopPanel.topLineData.height);
			graphics.endFill();
		}
		
		private function mouseClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Locale.current[type].link));
		}
		
		override public function switchLocale(locale:Locale):void
		{
			removeChildren();
			if (locale[type] == null)
			{
				BUTTON_WIDTH = 0;
				return;
			}
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			tf.font = MakeUp.getFont(locale);
			tf.bold = true;
			tf.size = 14;
			var icon:DisplayObject = MakeUp.getIconMakeUp(type);
			verticalCenter(icon);
			obj = MakeUp.getIconMakeUp(type);
			obj.visible = false;
		
	
				obj.transform.colorTransform = MakeUp.ICON_COLOR_TRANSFORM;

			
			
			verticalCenter(obj);
			textField = new TextField();
			textField.autoSize = "right";
			textField.embedFonts = true;
			textField.defaultTextFormat = tf;
			textField.selectable = false;
			textField.textColor = 16777215;
			textField.text = locale[type].text;
			var metrics:TextLineMetrics;
			BUTTON_WIDTH = (metrics = textField.getLineMetrics(0)).width + icon.width + 30;
			textField.y = 50 - metrics.height >> 1;
			textField.x = 0;
			textField.width = BUTTON_WIDTH;
			textField.height = TopPanel.topLineData.height;
			icon.x = obj.x = 15;
			addChild(textField);
			addChild(icon);
			addChild(obj);
			graphics.clear();
			graphics.lineStyle(0, 16711680, 0);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, BUTTON_WIDTH, TopPanel.topLineData.height);
			graphics.endFill();
		}
		
		private function mouseOut(e:MouseEvent):void
		{
			Mouse.cursor = "auto";
			if (numChildren > 0)
			{
				textField.textColor = 16777215;
				getChildAt(1).visible = true;
				getChildAt(numChildren - 1).visible = false;
			}
		}
		
		private function mouseOver(e:MouseEvent):void
		{
			
			Mouse.cursor = "button";
			if (numChildren > 0)
			{
		
					textField.textColor = 8440328;
			
				
				getChildAt(1).visible = false;
				getChildAt(numChildren - 1).visible = true;
				
			}
		}
		
		private function verticalCenter(obj:DisplayObject):void
		{
			obj.y = 50 - obj.height >> 1;
		}
	}
}
