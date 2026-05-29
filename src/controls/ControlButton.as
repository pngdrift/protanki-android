package controls {
  import flash.display.Shape;
  import flash.display.Sprite;

  public class ControlButton extends Sprite {

    private var label:String;
    private var keyCodes:uint;

    public function ControlButton(label:String,keyCodes:uint,size:Number,color:uint) {
      this.label = label;
      this.keyCodes = keyCodes;

      var bg:Shape = new Shape();
      bg.graphics.beginFill(color,0.6);
      bg.graphics.lineStyle(DPI.scale(2),0xFFFFFF,0.8);
      bg.graphics.drawRect(0,0,size,size);
      bg.graphics.endFill();
      addChild(bg);

      var tl:TextLabel = new TextLabel(label,size * 0.25);
      tl.x = size / 2 - tl.width / 2;
      tl.y = size / 2 - tl.height / 2;
      addChild(tl);

      buttonMode = true;
      mouseChildren = false;
    }

    public function getLabel():String {
      return label;
    }

    public function getKeyCodes():uint {
      return keyCodes;
    }
  }
}
