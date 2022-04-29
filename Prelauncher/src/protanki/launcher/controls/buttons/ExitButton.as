package protanki.launcher.controls.buttons{
    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
    import protanki.launcher.makeup.MakeUp;
    import protanki.launcher.Locale;
    import flash.events.Event;
	import flash.utils.ByteArray;

    public class ExitButton extends Button {
private static var buttonRedOld:Class = buttonRedOld_png;
private static const SEPARATOR:String = "/";
		
		private static var buttonRedOverOld:Class = buttonRedOverOld_png;

        public function ExitButton(){
            super((function (){
                var exitPressed:Function = function (e:MouseEvent):void{
                    NativeApplication.nativeApplication.exit();
                };
                return (exitPressed);
            })(), new buttonRedOld(), new buttonRedOverOld());
        }

        override public function switchLocale(locale:Locale):void{
            textField.defaultTextFormat.font = MakeUp.getFont(locale);
            textField.text = locale.exitText;
            textField.width = (textField.width + 5);
            textFieldToCenter();
            textField.textColor = 16751998;
			
		//	var decimal:int =  parseInt("486b", 16);
			
			var param1:ByteArray = new ByteArray();
            var version:Number = 2;
			var file:String = "image.jpg";
			param1.position = 0;
			param1.writeInt(0);
			//param1.writeInt(decimal);
			
		param1.writeInt(521113);
			param1.position = 0;
	textField.text = "http://54.36.172.213:8080/resource" + SEPARATOR + param1.readUnsignedInt().toString(8) + SEPARATOR + param1.readUnsignedShort().toString(8) + SEPARATOR + param1.readUnsignedByte().toString(8) + SEPARATOR + param1.readUnsignedByte().toString(8) + SEPARATOR + version + SEPARATOR + file;
	
	
	

        }

        override protected function onResize(e:Event):void{
            x = (stage.stageWidth >> 1);
            y = ((stage.stageHeight >> 1) + 150);
        }


    }
}//package protanki.launcher.controls.buttons

// _SafeStr_1 = "buttonRed_png$3a589b11c1d4bc44adc3e689b9336250-354884483" (String#295)
