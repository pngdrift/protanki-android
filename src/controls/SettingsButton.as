package controls {
  import flash.display.Sprite;

  public class SettingsButton extends Sprite {

    public function SettingsButton() {
      super();
      graphics.beginFill(0x000000,0.5);
      graphics.drawRect(0,0,DPI.scale(40),DPI.scale(40));
      graphics.endFill();

      var icon:TextLabel = new TextLabel('⚙',DPI.scale(25));
      icon.x = width / 2 - icon.width / 2;
      icon.y = height / 2 - icon.height / 2;
      addChild(icon);

      buttonMode = true;
      mouseChildren = false;
    }

  }
}
