package lang {
  import flash.system.Capabilities;

  public class Lang {
    
    private static var langCode:String = getLangCode();

    private static function getLangCode():String {
      switch(Capabilities.language) {
        case 'ru':
        case 'pt':
          return Capabilities.language;
        case 'en':
          var langTag:String = Capabilities.languages[0];
          return langTag == 'uk-UA' ? 'ua' : 'en';
        default:
          return 'en'
      }
    }

    private static const texts:Object = {
      ua: include 'texts/ua.jsonc',
      pt: include 'texts/pt.jsonc',
      ru: include 'texts/ru.jsonc',
      en: include 'texts/en.jsonc'
    };

    [Inline]
    internal static function getText(key:String):String {
      var langSet:Object = texts[langCode];
      return langSet[key] || ('@{' + key + '}@');
    }

  }
}
