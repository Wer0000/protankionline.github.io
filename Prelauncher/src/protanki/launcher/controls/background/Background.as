package protanki.launcher.controls.background{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.Event;

    public class Background extends Sprite {

        private static var background:Class = background_old_png;

        public function Background(){
            addEventListener("addedToStage", addedToStage);
        }

        private function addedToStage(e:Event):void{
            var bitmap:Bitmap = (new background() as Bitmap);
            bitmap.scaleX = (stage.stageWidth / bitmap.width);
            bitmap.scaleY = bitmap.scaleX;
            addChild(bitmap);
            removeEventListener("addedToStage", addedToStage);
            addEventListener("removedFromStage", removedFromStage);
        }

        private function removedFromStage(e:Event):void{
            removeEventListener("removedFromStage", removedFromStage);
            addEventListener("addedToStage", addedToStage);
        }


    }
}//package protanki.launcher.controls.background