package {
  import flash.display.Stage;
  import flash.events.KeyboardEvent;

  public class KeyUtil {

    private static const keyEventDown:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
    private static const keyEventUp:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_UP);

    public static function simulateKeyPress(stage:Stage,keyDown:Boolean,keyCodeValue:uint):void {
      var keyEvent:KeyboardEvent = keyDown ? keyEventDown : keyEventUp;
      keyEvent.keyCode = keyCodeValue;
      stage.dispatchEvent(keyEvent);
    }

  }
}