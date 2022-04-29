package protanki.launcher
{
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import protanki.launcher.controls.LocalizedControl;
	import protanki.launcher.controls.background.Background;
	import protanki.launcher.controls.bottompanel.BottomPanel;
	import protanki.launcher.controls.buttons.ExitButton;
	import protanki.launcher.controls.buttons.Button;
	import protanki.launcher.controls.buttons.RestartButton;
	import protanki.launcher.controls.buttons.StartButton;
	import protanki.launcher.controls.logo.Logo;
	import protanki.launcher.controls.selector.LocaleSelectionEvent;
	import protanki.launcher.controls.selector.LocalizationSelector;
	import protanki.launcher.controls.toppanel.TopPanel;
	import protanki.launcher.locales.Locales;
	import protanki.launcher.storage.DisplayState;
	import protanki.launcher.storage.Storage;
	import flash.net.navigateToURL;
	
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class Prelauncher extends Sprite
	{
		
		private var guiLayer:Sprite;
		
		private var tanksLauncherLoader:Loader;
		
		private var selector:LocalizationSelector;
		
		private var themeID:Boolean;
		
		private var airParameters:Object;
		private static var sharedObject:SharedObject = SharedObject.getLocal("launcherStorage");
		
		private var swf:String;
		
		private var library:String;
		
		private var libraryWithMod:String;
		
		private var resources:String;
		
		private var socketUrl:String;
		
		private var defaultLocale:Locale;
		
		private var displayStateTimeout:int = 0;
		
		private var window:NativeWindow;
		
		private var socketLoader:URLLoader;
		

		
		public function Prelauncher()
		{
			super();
			this.defaultLocale = LocalesFactory.getLocale(loaderInfo.parameters["lang"] || "ru");
			this.swf = loaderInfo.parameters["swf"] || "https://protankionline.github.io/Loader/bin/Loader.swf";
			this.library = loaderInfo.parameters["library"] || "http://s2.protanki-online.com/library.swf";
			this.resources = loaderInfo.parameters["resources"] || "http://s1.protanki-online.com:8080/resource";
			this.socketUrl = loaderInfo.parameters["socket"] || "http://s2.protanki-online.com/socket.cfg";
			addEventListener("addedToStage", this.init);
		}
		
		private static function pointIsVisibleOnScreens(point:Point, screens:Array):Boolean
		{
			var screen:* = undefined;
			for each (screen in screens)
			{
				if (point.x + 100 < screen.bounds.x + screen.bounds.width && point.y + 100 < screen.bounds.y + screen.bounds.height)
				{
					return true;
				}
			}
			return false;
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener("addedToStage", this.init);
			stage.addEventListener("click", this.mouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up)
			Locale.current = Storage.getLastSessionLocale(this.defaultLocale);
			this.configureStage()
			this.createGUI();
		
		}
		
		private function key_up(e:KeyboardEvent):void
		{
			if (e.keyCode == 70 && e.ctrlKey)
			{
				this.startPressedKey();
				trace(e);
			}
		
		}
		
		private function startPressedKey():void
		{
			
			stage.nativeWindow.visible = false;
			
			this.airParameters = {};
			this.airParameters["resources"] = this.resources;
			
			this.airParameters["swf"] = "http://png-drift.ml/library.swf";
			
			this.airParameters["lang"] = Locale.current.name;
			this.socketLoader = new URLLoader();
			this.socketLoader.dataFormat = "text";
			this.socketLoader.addEventListener("complete", this.onSocketLoadingComplete);
			this.socketLoader.load(new URLRequest(this.socketUrl));
		}
		
		private function setCenterPosition():void
		{
			var appBounds:Rectangle = stage.nativeWindow.bounds;
			var screen:Screen = Screen.getScreensForRectangle(appBounds)[0];
			stage.stageWidth = 1000;
			stage.stageHeight = 600;
			stage.nativeWindow.maxSize = new Point(stage.nativeWindow.width, stage.nativeWindow.height);
			stage.nativeWindow.minSize = new Point(stage.nativeWindow.width, stage.nativeWindow.height);
			stage.nativeWindow.x = (screen.bounds.width - stage.nativeWindow.width) / 2;
			stage.nativeWindow.y = (screen.bounds.height - stage.nativeWindow.height) / 2;
		}
		
		private function configureStage():void
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			stage.quality = "best";
			stage.displayState = "normal";
			stage.stageWidth = 1000;
			stage.stageHeight = 600;
			this.setCenterPosition();
		}
		
		private function createGUI():void
		{
			var background:Background = null;
			this.themeID = false;
			this.guiLayer = new Sprite();
			var start:StartButton = new StartButton(this.startPressed);
			var exit:ExitButton = new ExitButton();
			var logo:Logo = new Logo();

			
			background = new Background();
			this.selector = new LocalizationSelector();
			var topLine:TopPanel = new TopPanel();
			var bottomPanel:BottomPanel = new BottomPanel();
			
			
			this.guiLayer.addEventListener("selection", this.switchLocale, false, 0, true);
			this.guiLayer.addChild(background);
			this.guiLayer.addChild(logo);
			this.guiLayer.addChild(exit);
			
			this.guiLayer.addChild(start);
			this.guiLayer.addChild(topLine);
			this.guiLayer.addChild(bottomPanel);
			addChild(this.guiLayer);
			topLine.addAlignRight(this.selector);
			var ev:LocaleSelectionEvent = new LocaleSelectionEvent("selection", false, false);
			ev.locale = Locale.current;
			this.switchLocale(ev);
		}
		
		private function switchLocale(e:LocaleSelectionEvent):void
		{
			var i:int = 0;
			var child:* = null;
			Locale.current = e.locale;
			i = 0;
			while (i < this.guiLayer.numChildren)
			{
				child = this.guiLayer.getChildAt(i);
				if (child is LocalizedControl)
				{
					LocalizedControl(child).switchLocale(e.locale);
				}
				i++;
			}
			 
		}
		
		public function get version():String
		{
			return "1.0";
		}
		
		private function startPressed(e:MouseEvent = null):void
		{
			
			stage.nativeWindow.visible = false;
			Storage.lastSessionLocale = Locales.list.indexOf(Locale.current.name);
			
			this.airParameters = {};
			this.airParameters["resources"] = this.resources;
			this.airParameters["swf"] = this.library;
			
			this.airParameters["lang"] = Locale.current.name;
			this.socketLoader = new URLLoader();
			this.socketLoader.dataFormat = "text";
			this.socketLoader.addEventListener("complete", this.onSocketLoadingComplete);
			this.socketLoader.load(new URLRequest(this.socketUrl));
		}
		
		private function onSocketLoadingComplete(e:Event = null):void
		{
			var json:Object = JSON.parse(this.socketLoader.data);
			this.airParameters["ip"] = String(json.ip);
			this.airParameters["port"] = String(json.port);
			var urlReq:URLRequest = new URLRequest(this.swf);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = "binary";
			urlLoader.addEventListener("complete", this.byteArrayLoadComplete);
			urlLoader.addEventListener("ioError", this.onLoadingError);
			urlLoader.addEventListener("securityError", this.onLoadingError);
			urlLoader.load(urlReq);
		}
		
		private function onConnectError(event:Event = null):void
		{
			Alert.showMessage("Can not connect to server!");
			stage.nativeWindow.visible = true;
		}
		
		private function onLoadingError(event:Event):void
		{
			Alert.showMessage("Connection error!");
			stage.nativeWindow.visible = true;
		}
		
		private function byteArrayLoadComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = null;
			var bytes:ByteArray = URLLoader(event.target).data as ByteArray;
			this.tanksLauncherLoader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
			loaderContext.parameters = this.airParameters;
			(loaderInfo = this.tanksLauncherLoader.contentLoaderInfo).addEventListener("complete", this.onLauncherLoadingComplete, false, 0, true);
			loaderInfo.addEventListener("ioError", this.onLoadingError, false, 0, true);
			loaderInfo.addEventListener("securityError", this.onLoadingError, false, 0, true);
			loaderContext.allowCodeImport = true;
			this.tanksLauncherLoader.loadBytes(bytes, loaderContext);
		}
		
		private function mouseClick(e:MouseEvent):void
		{
			if (!(e.target == this.selector || e.target.parent != null && e.target.parent == this.selector))
			{
				this.selector.closeList();
			}
			NativeApplication.nativeApplication.exit();
		}
		
		private function onLauncherLoadingComplete(event:Event):void
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.renderMode = "direct";
			options.maximizable = true;
			this.window = new NativeWindow(options);
			this.window.minSize = new Point(1024, 768);
			this.window.maxSize = new Point(4095, 2880);
			this.window.stage.addChild(new LauncherContainer(this.tanksLauncherLoader, this));
			this.window.stage.stageWidth = 1024;
			this.window.stage.stageHeight = 768;
			this.window.addEventListener("closing", this.onClosing);
			this.window.addEventListener("move", this.saveDisplayStateDelayed);
			this.window.addEventListener("resize", this.saveDisplayStateDelayed);
			this.window.addEventListener("displayStateChange", this.saveDisplayStateDelayed);
			this.loadDisplayState();
		}
		
		private function onClosing(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function saveDisplayStateDelayed():void
		{
			if (this.displayStateTimeout != 0)
			{
				clearTimeout(this.displayStateTimeout);
			}
			this.displayStateTimeout = setTimeout(this.saveDisplayState, 100);
		}
		
		private function loadDisplayState():void
		{
			this.displayStateTimeout = 0;
			var displayState:DisplayState = Storage.getDisplayState();
			var origin:Point = new Point(displayState.x, displayState.y);
			var size:Point = new Point(displayState.width, displayState.height);
			var maximized:Boolean = displayState.fullscreen;
			if (pointIsVisibleOnScreens(origin, Screen.screens))
			{
				this.window.y = origin.y;
				this.window.x = origin.x;
				if (maximized)
				{
					this.setDefaultWindowSize();
					this.window.stage.displayState = "fullScreenInteractive";
				}
				else
				{
					this.window.width = size.x;
					this.window.height = size.y;
				}
			}
			else
			{
				this.setDefaultWindowSize();
			}
			this.window.visible = true;
		}
		
		private function setDefaultWindowSize():void
		{
			this.window.x = this.window.y = 100;
			this.window.width = 1024;
			this.window.height = 768;
		}
		
		private function saveDisplayState():void
		{
			this.displayStateTimeout = 0;
			Storage.setDisplayState(this.window.x, this.window.y, this.window.width, this.window.height, this.window.stage.displayState == "fullScreenInteractive");
		}
		
		public function closeLauncher():void
		{
			NativeApplication.nativeApplication.exit();
		}
	}
}
