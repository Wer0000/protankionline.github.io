package protanki.launcher.controls.logo
{
   import flash.events.Event;
   import protanki.launcher.Locale;
   import protanki.launcher.controls.LocalizedControl;
   	  import flash.net.SharedObject;

	  

   public class Logo extends LocalizedControl
   {
      
   
	  private static var logoOld:Class = logo_png;
	  
	    private static var sharedObject:SharedObject = SharedObject.getLocal("launcherStorage");
       
      
      public function Logo()
      {
         super();
      }
      
      override public function switchLocale(locale:Locale) : void
      {
     
			 	   removeChildren();
         addChildToCenter(new logoOld());

      }
	  

		 
   
      
      
      override protected function onResize(e:Event) : void
      {
         x = stage.stageWidth >> 1;
         y = stage.stageHeight / 3.5;
      }
   }
}
