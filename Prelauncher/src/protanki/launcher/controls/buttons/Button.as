package protanki.launcher.controls.buttons
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Mouse;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.LocalizedControl;
	import protanki.launcher.makeup.MakeUp;
	
	public class Button extends LocalizedControl
	{
		
		private var onClick:Function;
		
		protected var textField:TextField;
		
		private var buttonOld:DisplayObject;
		
		private var overButtonOld:DisplayObject;
		
		public function Button(onClick:Function, buttonOld:DisplayObject, overButtonOld:DisplayObject)
		{
			textField = new TextField();
			super();
			this.onClick = onClick;
			this.buttonOld = buttonOld;
			this.overButtonOld = overButtonOld;
			scaleX = scaleY = 0.71;
			addEventListener("addedToStage", addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener("addedToStage", addedToStage);
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 32;
			textFormat.bold = true;
			textFormat.font = MakeUp.getFont(Locale.current);
			textField.embedFonts = true;
			textField.defaultTextFormat = textFormat;
			textField.autoSize = "center";
			textField.wordWrap = false;
			textField.multiline = false;
			textField.selectable = false;
			textField.selectable = true;
			addChildToCenter(overButtonOld);
			overButtonOld.visible = false;
			addChildToCenter(buttonOld);
			
			addChild(textField);
			addEventListener("mouseOver", onMouseOver);
			addEventListener("mouseOut", onMouseOut);
			addEventListener("mouseDown", onMouseDown);
			addEventListener("mouseUp", onMouseUp);
			addEventListener("click", onMouseClick);
		}
		
		private function removedFromStage(e:Event):void
		{
			removeEventListener("removedFromStage", removedFromStage);
			addEventListener("addedToStage", addedToStage);
		}
		
		protected function textFieldToCenter():void
		{
			var metrics:TextLineMetrics = textField.getLineMetrics(0);
			textField.x = -metrics.width >> 1;
			textField.y = (-metrics.height >> 1) - 4;
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			Mouse.cursor = "button";
			
			buttonOld.visible = false;
			overButtonOld.visible = true;
		
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			Mouse.cursor = "auto";
			
			buttonOld.visible = true;
			overButtonOld.visible = false;
		
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			
			buttonOld.visible = true;
			overButtonOld.visible = false;
		
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			
			buttonOld.visible = false;
			overButtonOld.visible = true;
		
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			onClick.call(this, e);
		}
	}
}
