package protanki.launcher.locales.BR
{
	import flash.net.SharedObject;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.bottompanel.PartnerLogo.PartnerLogo;
	import protanki.launcher.locales.TextLinkPair;
	
	public class LocaleBR extends Locale
	{
		
		public function LocaleBR()
		{
			super();
			name = "pt_BR";
			playText = "JOGUE";
			exitText = "EXIT";
			partners.push(PartnerLogo.VK, "https://vk.com/protanki_official");
			partners.push(PartnerLogo.YOUTUBE, "https://www.youtube.com/channel/UCvx5X0ibv6zAartWU_JyTsA");
			partners.push(PartnerLogo.DISCORD, "https://discord.gg/Bjkw35JGsG");
			partners.push(PartnerLogo.TELEGRAM, "https://t.me/protanki");
			game = new TextLinkPair("Jogo", "http://protanki-online.com/");
			wiki = new TextLinkPair("Wiki", "http://wiki.protanki-online.com");
		    ratings = new TextLinkPair("Classificações", "http://ratings.generaltanks.com/en/user/" + SharedObject.getLocal("name").data["userName"]);
			help = new TextLinkPair("Informações", "http://protanki-online.com/");
			materials = new TextLinkPair("Updates", "http://protanki-online.com/");
			kits = new TextLinkPair("Lista dos kits", "https://docs.google.com/spreadsheets/d/e/2PACX-1vRkDP6m697TLgoIpbUIECXBzxQpAIu0cSlHSXBj22buHTeTHN8bJSsxzdYtIIj2XDdORHtBIYc6QR2y/pubhtml");
			rules = new TextLinkPair("Regras do jogo", "http://png-drift.ml/rules/br");
			contacts = new TextLinkPair("Discord: Aivaz#9559", "");
		}
	}
}
