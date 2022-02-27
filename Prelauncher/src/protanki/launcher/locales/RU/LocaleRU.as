package protanki.launcher.locales.RU
{
	import flash.net.SharedObject;
	import protanki.launcher.Locale;
	import protanki.launcher.controls.bottompanel.PartnerLogo.PartnerLogo;
	import protanki.launcher.locales.TextLinkPair;
	
	public class LocaleRU extends Locale
	{
		
		public function LocaleRU()
		{
			super();
			name = "ru";
			playText = "ИГРАТЬ";
			exitText = "ВЫХОД";			
			partners.push(PartnerLogo.VK, "https://vk.com/protanki_official");
			partners.push(PartnerLogo.YOUTUBE, "https://www.youtube.com/channel/UCvx5X0ibv6zAartWU_JyTsA");
			partners.push(PartnerLogo.DISCORD, "https://discord.gg/Bjkw35JGsG");
			partners.push(PartnerLogo.TELEGRAM, "https://t.me/protanki_official");
			game = new TextLinkPair("Игра", "http://protanki-online.com/");
			wiki = new TextLinkPair("Вики", "http://wiki.protanki-online.com/");
			ratings = new TextLinkPair("Рейтиги", "http://ratings.generaltanks.com/en/user/" + SharedObject.getLocal("name").data["userName"]);
			help = new TextLinkPair("Информация", "https://vk.com/@protanki_official-rubrika-vopros-otvet-ot-razrabotchikov-protanki");
			materials = new TextLinkPair("Обновления", "http://protanki-online.com/");
			kits = new TextLinkPair("Список комплектов", "https://docs.google.com/spreadsheets/d/1ys4N2Mt6tLZTf85t9GeSrKxZIHN4Lb31t2si4nm3bGU/edit");
			rules = new TextLinkPair("Правила игры", "http://png-drift.ml/rules/ru");
			contacts = new TextLinkPair("Discord: Aivaz#9559", "");
		}
	}
}
