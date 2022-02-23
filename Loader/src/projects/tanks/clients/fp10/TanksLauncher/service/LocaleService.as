package projects.tanks.clients.fp10.TanksLauncher.service
{
   import flash.external.ExternalInterface;
   import projects.tanks.clients.tankslauncershared.service.Locale;
   
   public class LocaleService
   {
      
      private static var _currentLocale:String = Locale.EN;
       
      
      public function LocaleService()
      {
         super();
      }
      
      public static function get anotherGameServerUrl() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         _loc1_ = "http://protanki-online.com/" + currentLocale.toLowerCase();
         if(ExternalInterface.available)
         {
            _loc2_ = ExternalInterface.call("getPreferGameServerUrl");
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public static function get currentLocale() : String
      {
         return _currentLocale;
      }
      
      public static function updateCurrentLocale(param1:String) : void
      {
         if(param1)
         {
            param1 = param1.toUpperCase();
            if(Locale.LOCALES.indexOf(param1) != -1)
            {
               _currentLocale = Locale.LOCALES[Locale.LOCALES.indexOf(param1)];
            }
         }
      }
   }
}
