package controls {
  import flash.system.Capabilities;

  public class DPI {

    public static const dpiScale:Number = Capabilities.screenDPI / 160;

    public static function scale(value:Number):Number {
      return value * dpiScale;
    }

  }
}
