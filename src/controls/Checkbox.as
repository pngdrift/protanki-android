package controls {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  public class Checkbox extends Sprite {

    private var _checked:Boolean = false;
    private var checkMark:Shape;
    private var size:Number;

    public function Checkbox() {
      super();
      size = DPI.scale(20);
      createUI();
      buttonMode = true;
      addEventListener(MouseEvent.CLICK,onClick);
    }

    private function createUI():void {
      var box:Sprite = new Sprite();
      box.graphics.beginFill(0,0);
      box.graphics.lineStyle(DPI.scale(1),0xFFFFFF);
      box.graphics.drawRect(0,0,size,size);
      box.graphics.endFill();
      addChild(box);

      checkMark = new Shape();
      updateCheckMark();
      addChild(checkMark);
    }

    private function updateCheckMark():void {
      checkMark.graphics.clear();
      if(_checked) {
        checkMark.graphics.lineStyle(DPI.scale(1.5),0x00FF00);
        checkMark.graphics.moveTo(size * 0.2,size * 0.5);
        checkMark.graphics.lineTo(size * 0.45,size * 0.75);
        checkMark.graphics.lineTo(size * 0.8,size * 0.25);
      }
    }

    private function onClick(event:MouseEvent):void {
      _checked = !_checked;
      updateCheckMark();
    }

    public function get checked():Boolean {
      return _checked;
    }

    public function set checked(value:Boolean):void {
      _checked = value;
      updateCheckMark();
    }
  }
}
