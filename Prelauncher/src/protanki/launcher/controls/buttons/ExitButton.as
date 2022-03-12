package protanki.launcher.controls.buttons{
    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;
    import protanki.launcher.makeup.MakeUp;
    import protanki.launcher.Locale;
    import flash.events.Event;

    public class ExitButton extends Button {
private static var buttonRedOld:Class = buttonRedOld_png;
		
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
        }

        override protected function onResize(e:Event):void{
            x = (stage.stageWidth >> 1);
            y = ((stage.stageHeight >> 1) + 150);
        }


    }
}//package protanki.launcher.controls.buttons

// _SafeStr_1 = "buttonRed_png$3a589b11c1d4bc44adc3e689b9336250-354884483" (String#295)
