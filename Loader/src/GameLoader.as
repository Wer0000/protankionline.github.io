package
{
   import flash.desktop.NativeApplication;
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
   import projects.tanks.clients.tankslauncershared.dishonestprogressbar.DishonestProgressBar;
   
   public class GameLoader extends Sprite
   {
      
      private static var GAME_URL:String = "http://93.78.105.80:8080/resource/";
      
      private static const ENTRANCE_MODEL_OBJECT_LOADED_EVENT:String = "EntranceModel.objectLoaded";
       
      
      private var loader:Loader;
      
      private var locale:String;
      
      public var log:TextField;
      
      private var _dishonestProgressBar:DishonestProgressBar;
      
      private var _background:Background;
      
      public function GameLoader()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public static function findClass(param1:String) : Class
      {
         return Class(ApplicationDomain.currentDomain.getDefinition(param1));
      }
      
      private function init(e:Event = null) : void
      {
         trace("AIR SDK Version: ",NativeApplication.nativeApplication.runtimeVersion);
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         this.configureStage();
         this.createBackground();
		   this.createDishonestProgressBar();
         try
         {
            this.loadLibrary();
         }
         catch(e:Error)
         {
            this.handleLoadingError(e.getStackTrace(),"0");
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
         this._dishonestProgressBar = new DishonestProgressBar(loaderInfo.parameters["lang"].toUpperCase(),this.progressBarFinished);
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
      
      private function onEntranceModelObjectLoaded(event:Event) : void
      {
         trace("entrance model obj loaded");
         stage.removeEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT,this.onEntranceModelObjectLoaded);
         
         this._dishonestProgressBar.forciblyFinish();
      }
      
      private function loadLibrary() : void
      {
         var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var flashvars:URLVariables = new URLVariables();
         flashvars["locale"] = loaderInfo.parameters["lang"];
         flashvars["rnd"] = Math.random();
         var urlReq:URLRequest = new URLRequest(loaderInfo.parameters["swf"]);
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         urlLoader.addEventListener(Event.COMPLETE,this.byteArrayLoadComplete);
         urlLoader.load(urlReq);
      }
      
      private function byteArrayLoadComplete(event:Event) : void
      {
         var bytes:ByteArray = URLLoader(event.target).data as ByteArray;
         this.loader = new Loader();
         var loaderContext:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         var loaderInfo:LoaderInfo = this.loader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         loaderContext.allowCodeImport = true;
         this.loader.loadBytes(bytes,loaderContext);
      }
      
      public function logEvent(entry:String) : void
      {
         this.log.appendText(entry + "\n");
         trace(entry);
      }
      
      private function onComplete(e:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         var mainClass:Class = Class(this.loader.contentLoaderInfo.applicationDomain.getDefinition("Game"));
         var obj:* = new mainClass();
         obj.SUPER(stage,this,loaderInfo);
         addChild(obj);
		          this.progressBarFinished();
      }
      
      private function handleLoadingError(errorMessage:String, errorCode:String) : void
      {
         var seh:SmartErrorHandler = new SmartErrorHandler(errorMessage,errorCode);
         stage.addChild(seh);
         seh.handleLoadingError();
      }
   }
}
