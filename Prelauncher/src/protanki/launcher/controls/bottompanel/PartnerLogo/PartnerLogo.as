package protanki.launcher.controls.bottompanel.PartnerLogo
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	
	public class PartnerLogo extends Sprite
	{
		
		private static var vkIcon:Class = vkIcon_png$5dbe7a0f189d11d7d929458422b99f661813534102;
		
		private static var youtubeIcon:Class = youtubeIcon_png$1d119197cd1e5cec5e55265f9839357013746442;
		
		private static var discordIcon:Class = discordIcon_png$5987016afcf99ab0297ae4a38ea0e33b936363523;
		
		private static var telegramIcon:Class = telegramIcon_png$99a9013827af36f753ec57b8bb54a2a958218966;
		
		
		public static var VK:String = "VK";
		
		public static var YOUTUBE:String = "YOUTUBE";
		
		public static var DISCORD:String = "DISCORD";
		
		public static var TELEGRAM:String = "TELEGRAM";
		
		
		public var actualWidth:Number = 0;
		
		private var link:String;
		
		private var type:String;
		
		public function PartnerLogo(type:String, link:String)
		{
			type = type;
			link = link;
			super();
			this.link = link;
			this.type = type;
			addEventListener("mouseOver", function(e:MouseEvent):void
			{
				Mouse.cursor = "button";
			});
			addEventListener("mouseOut", function(e:MouseEvent):void
			{
				Mouse.cursor = "auto";
			});
			addEventListener("click", onClick);
			if (type != null)
			{
				addLogo(createIconByType(type));
			}
		}
		
		private function createIconByType(type:String):Bitmap
		{
			switch (type)
			{
			case VK: 
				return new vkIcon();
			case YOUTUBE: 
				return new youtubeIcon();
			case DISCORD: 
				return new discordIcon();
			case TELEGRAM: 
				return new telegramIcon();
			default: 
				throw new Error("Undefined icon type: " + type);
			}
		}
		
		private function addLogo(logo:Bitmap):void
		{
			actualWidth = logo.width;
			addChild(logo);
			logo.x = -logo.width >> 1;
			
			logo.y = -logo.height >> 1;
			
	
		}
		
		private function onClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(link));
		}
	}
}
