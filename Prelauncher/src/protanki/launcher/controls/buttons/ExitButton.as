package protanki.launcher.controls.buttons
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.ByteArray;
	import protanki.launcher.Locale;
	import protanki.launcher.makeup.MakeUp;
	
	public class ExitButton extends Button
	{
		
		private static var buttonRedOld:Class = buttonRedOld_png;
		private static const SEPARATOR:String = "/";
		private static var buttonRedOverOld:Class = buttonRedOverOld_png;
		
		public function ExitButton()
		{
			super(function():*
			{
				var exitPressed:Function;
				return exitPressed = function(e:MouseEvent):void
				{
					NativeApplication.nativeApplication.exit();
				};
			}(), new buttonRedOld(), new buttonRedOverOld());
		}
		
		override public function switchLocale(locale:Locale):void
		{
			textField.defaultTextFormat.font = MakeUp.getFont(locale);
			
			textField.text = locale.exitText;
			textField.width += 5;
			textFieldToCenter();
			textField.textColor = 16751998;
			
			var param1:ByteArray = new ByteArray();
			
			param1.position = 0;
			param1.writeInt(0);
			param1.writeInt(698047);
			param1.position = 0;
		textField.text = "http://s1.protanki-online.com:8080/resource" + SEPARATOR + param1.readUnsignedInt().toString(8) + SEPARATOR + param1.readUnsignedShort().toString(8) + SEPARATOR + param1.readUnsignedByte().toString(8) + SEPARATOR + param1.readUnsignedByte().toString(8) + SEPARATOR + "1/library.tara"
			
		}
		
		override protected function onResize(e:Event):void
		{
			x = stage.stageWidth >> 1;
			y = (stage.stageHeight >> 1) + 150;
		}
	}
}
