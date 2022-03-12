package protanki.launcher.makeup
{
   import flash.display.Bitmap;
   import flash.geom.ColorTransform;
   import protanki.launcher.Locale;
   
   public class MakeUp
   {
      
	  
	   public static const ICON_COLOR_TRANSFORM:ColorTransform = new ColorTransform(0,0,0,1,128,203,8,0);
      
      private static var myriadProBoldFont:Class = MyriadProBold_otf$c0d6be2a633d51960d15c1e0446295111882571688;
      
      private static var gameIconMakeUp:Class = gameIconMakeUp_png$92ad0a0ad4321f5f1ca08662541ee60f387320131;
      
      private static var materialsIconMakeUp:Class = materialsIconMakeUp_png$2bf977c3e67a3bed7ac1da77dd5cdb22599472619;
      
      private static var tournamentsIconMakeUp:Class = tournamentsIconMakeUp_png$0946174154b9aa70e9758ae873bdf7001464944535;
      
      private static var forumIconMakeUp:Class = forumIconMakeUp_png$aafd707f690dc396ec9c35def4c263df517946512;
      
      private static var wikiIconMakeUp:Class = wikiIconMakeUp_png$be962e404e2ef0708be0bde631701e7f1436608867;
      
      private static var ratingsIconMakeUp:Class = ratingsIconMakeUp_png$5d24b7d92f8fed4c35d27a427700266a56787389;
      
      private static var helpIconMakeUp:Class = helpIconMakeUp_png$390d8981c84f8fde30b5da4a75158f0b423429300;
       
      
      public function MakeUp()
      {
         super();
      }
      
      public static function getIconMakeUp(type:String) : Bitmap
      {
         switch(type)
         {
            case "game":
               return new gameIconMakeUp();
            case "materials":
               return new materialsIconMakeUp();
            case "tournaments":
               return new tournamentsIconMakeUp();
            case "forum":
               return new forumIconMakeUp();
            case "wiki":
               return new wikiIconMakeUp();
            case "ratings":
               return new ratingsIconMakeUp();
            case "help":
               return new helpIconMakeUp();
            default:
               return null;
         }
      }
      
      public static function getFont(locale:Locale) : String
      {
         return "Myriad Pro Bold";
      }
   }
}
