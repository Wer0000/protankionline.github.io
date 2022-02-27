package protanki.launcher.locales.EN
{
	import flash.net.SharedObject;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.bottompanel.PartnerLogo.PartnerLogo;
	import protanki.launcher.locales.TextLinkPair;
	
	public class LocaleEn extends Locale
	{
		
		public function LocaleEn()
		{
			super();
			name = "en";
			playText = "PLAY";
			exitText = "EXIT";
			partners.push(PartnerLogo.VK, "https://vk.com/protanki_official");
			partners.push(PartnerLogo.YOUTUBE, "https://www.youtube.com/channel/UCvx5X0ibv6zAartWU_JyTsA");
			partners.push(PartnerLogo.DISCORD, "https://discord.gg/Bjkw35JGsG");
			partners.push(PartnerLogo.TELEGRAM, "https://t.me/protanki_official");
			game = new TextLinkPair("Game", "http://protanki-online.com/");
			wiki = new TextLinkPair("Wiki", "http://wiki.protanki-online.com/");
			ratings = new TextLinkPair("Ratings", "http://ratings.generaltanks.com/en/user/" + SharedObject.getLocal("name").data["userName"]);
			help = new TextLinkPair("Information", "https://vk.com/@protanki_official-rubrika-vopros-otvet-ot-razrabotchikov-protanki");
			materials = new TextLinkPair("Updates", "http://protanki-online.com/");
			kits = new TextLinkPair("List of kits", "https://docs.google.com/spreadsheets/d/1ys4N2Mt6tLZTf85t9GeSrKxZIHN4Lb31t2si4nm3bGU/edit");
			rules = new TextLinkPair("Game rules", "http://png-drift.ml/rules/en");
			contacts = new TextLinkPair("Discord: Aivaz#9559", "");
		}
	
	}
}
