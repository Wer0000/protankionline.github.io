package
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import projects.tanks.clients.fp10.TanksLauncher.SmartErrorHandler;
   import projects.tanks.clients.fp10.TanksLauncher.background.Background;
   import projects.tanks.clients.fp10.TanksLauncher.service.LocaleService;
   import projects.tanks.clients.tankslauncershared.dishonestprogressbar.DishonestProgressBar;
   
   public class GameLoader extends Sprite
   {
      
      private static const ENTRANCE_MODEL_OBJECT_LOADED_EVENT:String = "EntranceModel.objectLoaded";
       
      
      private const SERVER_STATUS_OVERLOADED:String = "overloaded";
      
      private const SERVER_STATUS_UNAVAILABLE:String = "unavailable";
      
      private var loader:Loader;
      
      private var locale:String;
      
      public var log:TextField;
      
      private var _dishonestProgressBar:DishonestProgressBar;
      
      private var _background:Background;
      
      private var configLoader:URLLoader;
      
      public function GameLoader()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public static function findClass(param1:String) : Class
      {
         return Class(ApplicationDomain.currentDomain.getDefinition(param1));
      }
      
      private function init(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         new IncludedLibrary();
         this.configureStage();
         this.createBackground();
         LocaleService.updateCurrentLocale(loaderInfo.parameters["lang"]);
         try
         {
            this.startLoadServerConfiguration();
         }
         catch(e:Error)
         {
         }
      }
      
      private function configureStage() : void
      {
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.quality = StageQuality.LOW;
         stage.stageFocusRect = false;
         mouseEnabled = false;
         tabEnabled = false;
         stage.addEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT,this.onEntranceModelObjectLoaded);
      }
      
      private function createBackground() : void
      {
         this._background = new Background();
         stage.addChild(this._background);
      }
      
      private function createDishonestProgressBar() : void
      {
         this._dishonestProgressBar = new DishonestProgressBar("RU",this.progressBarFinished);
         stage.addChild(this._dishonestProgressBar);
         this._dishonestProgressBar.start();
      }
      
      private function progressBarFinished() : void
      {
         this.removeFromStageBackground();
         this.removeFromStageDishonestProgressBar();
      }
      
      private function removeFromStageBackground() : void
      {
         if(stage.contains(this._background))
         {
            stage.removeChild(this._background);
         }
      }
      
      private function removeFromStageDishonestProgressBar() : void
      {
         if(stage.contains(this._dishonestProgressBar))
         {
            stage.removeChild(this._dishonestProgressBar);
         }
      }
      
      private function onEntranceModelObjectLoaded(param1:Event) : void
      {
         stage.removeEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT,this.onEntranceModelObjectLoaded);
         this.removeFromStageBackground();
      }
      
      private function loadLibrary() : void
      {
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["locale"] = loaderInfo.parameters["lang"];
         _loc2_["rnd"] = Math.random();
         var _loc3_:URLRequest = new URLRequest(loaderInfo.parameters["swf"]);
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = URLLoaderDataFormat.BINARY;
         _loc4_.addEventListener(Event.COMPLETE,this.byteArrayLoadComplete);
         _loc4_.load(_loc3_);
      }
      
      private function startLoadServerConfiguration() : void
      {
         this.configLoader = new URLLoader();
         this.configLoader.addEventListener(Event.COMPLETE,this.onServerConfigLoadingComplete);
         this.configLoader.load(new URLRequest("http://s2.protanki-online.com/config.xml" + "?rnd=" + Math.random()));
      }
      
      private function onServerConfigLoadingComplete(param1:Event) : void
      {
         var _loc2_:XML = XML(this.configLoader.data);
         this.configLoader = null;
         var _loc3_:Namespace = _loc2_.namespace();
         var _loc4_:String = _loc2_._loc3_::status.toString();
         switch(_loc4_)
         {
            case this.SERVER_STATUS_OVERLOADED:
               this.onServerOverloaded();
               return;
            case this.SERVER_STATUS_UNAVAILABLE:
               this.onServerUnavailable();
               return;
            default:
               this.loadLibrary();
               return;
         }
      }
      
      public function onServerUnavailable() : void
      {
         this.handleLoadingError("Server is unavailable",SmartErrorHandler.NOTAVAILABLE_ERROR);
      }
      
      public function onServerOverloaded() : void
      {
         this.handleLoadingError("Server is overloaded",SmartErrorHandler.OVERLOADED_ERROR);
      }
      
      private function byteArrayLoadComplete(param1:Event) : void
      {
         var _loc2_:ByteArray = URLLoader(param1.target).data as ByteArray;
         this.loader = new Loader();
         var _loc3_:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         var _loc4_:LoaderInfo;
         (_loc4_ = this.loader.contentLoaderInfo).addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         _loc3_.allowCodeImport = true;
         this.loader.loadBytes(_loc2_,_loc3_);
      }
      
      public function logEvent(param1:String) : void
      {
         this.log.appendText(param1 + "\n");
      }
      
      private function onComplete(param1:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         var _loc2_:Class = Class(this.loader.contentLoaderInfo.applicationDomain.getDefinition("Game"));
         var _loc3_:* = new _loc2_();
         addChild(_loc3_);
         _loc3_.SUPER(stage,this,loaderInfo);
      }
      
      private function handleLoadingError(param1:String, param2:String) : void
      {
         var _loc3_:SmartErrorHandler = new SmartErrorHandler(param1,param2);
         stage.addChild(_loc3_);
         _loc3_.handleLoadingError();
      }
   }
}
