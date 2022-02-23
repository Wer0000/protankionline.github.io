package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.text.TextField;
	import projects.tanks.clients.tankslauncershared.dishonestprogressbar.DishonestProgressBar;
	import projects.tanks.clients.fp10.TanksLauncher.background.Background;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import projects.tanks.clients.fp10.TanksLauncher.service.LocaleService;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.system.LoaderContext;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import projects.tanks.clients.fp10.TanksLauncher.SmartErrorHandler;
	import flash.utils.ByteArray;
	import flash.display.LoaderInfo;
	
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
			addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		public static function findClass(_arg_1:String):Class
		{
			return (Class(ApplicationDomain.currentDomain.getDefinition(_arg_1)));
		}
		
		private function init(_arg_1:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.init);
			new IncludedLibrary();
			this.configureStage();
			this.createBackground();
			LocaleService.updateCurrentLocale(loaderInfo.parameters["lang"]);
			try
			{
				this.createDishonestProgressBar();
				this.startLoadServerConfiguration();
			}
			catch (e:Error)
			{
			}
			;
		}
		
		private function configureStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			stage.stageFocusRect = false;
			mouseEnabled = false;
			tabEnabled = false;
			stage.addEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT, this.onEntranceModelObjectLoaded);
		}
		
		private function createBackground():void
		{
			this._background = new Background();
			stage.addChild(this._background);
		}
		
		private function createDishonestProgressBar():void
		{
			this._dishonestProgressBar = new DishonestProgressBar("RU", this.progressBarFinished);
			stage.addChild(this._dishonestProgressBar);
			this._dishonestProgressBar.start();
		}
		
		private function progressBarFinished():void
		{
			this.removeFromStageBackground();
			this.removeFromStageDishonestProgressBar();
		}
		
		private function removeFromStageBackground():void
		{
			if (stage.contains(this._background))
			{
				stage.removeChild(this._background);
			}
			;
		}
		
		private function removeFromStageDishonestProgressBar():void
		{
			if (stage.contains(this._dishonestProgressBar))
			{
				stage.removeChild(this._dishonestProgressBar);
			}
			;
		}
		
		private function onEntranceModelObjectLoaded(_arg_1:Event):void
		{
			stage.removeEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT, this.onEntranceModelObjectLoaded);
			this._dishonestProgressBar.forciblyFinish();
		}
		
		private function loadLibrary():void
		{
			var _local_1:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var _local_2:URLVariables = new URLVariables();
			_local_2["locale"] = loaderInfo.parameters["lang"];
			_local_2["rnd"] = Math.random();
			var _local_3:URLRequest = new URLRequest(loaderInfo.parameters["swf"]);
			var _local_4:URLLoader = new URLLoader();
			_local_4.dataFormat = URLLoaderDataFormat.BINARY;
			_local_4.addEventListener(Event.COMPLETE, this.byteArrayLoadComplete);
			_local_4.load(_local_3);
		}
		
		private function startLoadServerConfiguration():void
		{
			this.configLoader = new URLLoader();
			this.configLoader.addEventListener(Event.COMPLETE, this.onServerConfigLoadingComplete);
			this.configLoader.load(new URLRequest((("http://s2.protanki-online.com/config.xml" + "?rnd=") + Math.random())));
		}
		
		private function onServerConfigLoadingComplete(_arg_1:Event):void
		{
			var _local_2:XML = XML(this.configLoader.data);
			this.configLoader = null;
			var _local_3:Namespace = _local_2.namespace();
			var _local_4:String = _local_2._local_3::status.toString();
			switch (_local_4)
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
			;
		}
		
		public function onServerUnavailable():void
		{
			this.handleLoadingError("Server is unavailable", SmartErrorHandler.NOTAVAILABLE_ERROR);
		}
		
		public function onServerOverloaded():void
		{
			this.handleLoadingError("Server is overloaded", SmartErrorHandler.OVERLOADED_ERROR);
		}
		
		private function byteArrayLoadComplete(_arg_1:Event):void
		{
			var _local_2:ByteArray = (URLLoader(_arg_1.target).data as ByteArray);
			this.loader = new Loader();
			var _local_3:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
			var _local_4:LoaderInfo = this.loader.contentLoaderInfo;
			_local_4.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
			_local_3.allowCodeImport = true;
			this.loader.loadBytes(_local_2, _local_3);
		}
		
		public function logEvent(_arg_1:String):void
		{
			this.log.appendText((_arg_1 + "\n"));
		}
		
		private function onComplete(_arg_1:Event):void
		{
			this.loader.removeEventListener(Event.COMPLETE, this.onComplete);
			var _local_2:Class = Class(this.loader.contentLoaderInfo.applicationDomain.getDefinition("Game"));
			var _local_3:* = new (_local_2)();
			addChild(_local_3);
			_local_3.SUPER(stage, this, loaderInfo);
		}
		
		private function handleLoadingError(_arg_1:String, _arg_2:String):void
		{
			var _local_3:SmartErrorHandler = new SmartErrorHandler(_arg_1, _arg_2);
			stage.addChild(_local_3);
			_local_3.handleLoadingError();
		}
	
	}
}//package 