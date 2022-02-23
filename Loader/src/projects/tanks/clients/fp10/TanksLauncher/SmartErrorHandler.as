package projects.tanks.clients.fp10.TanksLauncher
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import projects.tanks.clients.fp10.TanksLauncher.service.LocaleService;
   
   public class SmartErrorHandler extends Sprite
   {
      
      public static const OVERLOADED_ERROR:String = "overloaded";
      
      public static const NOTAVAILABLE_ERROR:String = "notavailable";
       
      
      private var errorMessage:String;
      
      private var errorCode:String;
      
      private var tanksErrorMessage;
      
      public function SmartErrorHandler(param1:String, param2:String)
      {
         super();
         this.errorMessage = param1;
         this.errorCode = param2;
      }
      
      private function showSimpleMessage(param1:String) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.wordWrap = true;
         _loc2_.multiline = true;
         _loc2_.width = 600;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.defaultTextFormat = new TextFormat("Tahoma",16,16777215);
         _loc2_.text = param1;
         stage.addChild(_loc2_);
         _loc2_.x = stage.stageWidth - _loc2_.width >> 1;
         _loc2_.y = stage.stageHeight - _loc2_.height >> 1;
      }
      
      public function handleLoadingError() : void
      {
         var _loc4_:LoaderContext = null;
         var _loc1_:URLRequest = null;
         var _loc2_:Loader = null;
         var _loc3_:LoaderInfo = null;
         if(this.forceShowDetailedError || this.isDebugMode)
         {
            this.showSimpleMessage(this.errorMessage);
         }
         else
         {
            (_loc4_ = new LoaderContext()).applicationDomain = ApplicationDomain.currentDomain;
            _loc1_ = new URLRequest("http://s2.protanki-online.com/TanksErrorScreen.swf");
            _loc2_ = new Loader();
            _loc3_ = _loc2_.contentLoaderInfo;
            _loc2_.load(_loc1_,_loc4_);
            _loc3_.addEventListener(Event.COMPLETE,this.onLoadingErrorMessageComplete);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.onFailedLoadingTanksErrorMessageClass);
            _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFailedLoadingTanksErrorMessageClass);
         }
      }
      
      private function onFailedLoadingTanksErrorMessageClass(param1:Event) : void
      {
         this.showSimpleMessage(this.errorMessage);
      }
      
      private function onLoadingErrorMessageComplete(param1:Event) : void
      {
         this.tanksErrorMessage = param1.currentTarget.content;
         this.tanksErrorMessage.init(this.errorCode,this.isTestServer,LocaleService.anotherGameServerUrl,LocaleService.currentLocale);
         stage.addChild(this.tanksErrorMessage);
         this.tanksErrorMessage.redraw(stage.stageWidth,stage.stageHeight);
         stage.addEventListener(Event.RESIZE,this.draw);
      }
      
      private function draw(param1:Event) : void
      {
         this.tanksErrorMessage.redraw(stage.stageWidth,stage.stageHeight);
      }
      
      private function get isDebugMode() : Boolean
      {
         return loaderInfo.parameters["debug"];
      }
      
      private function get isTestServer() : Boolean
      {
         return Boolean(loaderInfo.parameters["test_server"]);
      }
      
      private function get forceShowDetailedError() : Boolean
      {
         return Boolean(loaderInfo.parameters["show_detailed_error"]);
      }
   }
}
