package controls {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;

  public class NormalSlider extends Sprite {

    private var track:Sprite;
    private var handle:Sprite;

    private var _value:Number = 0.5;

    private var minX:Number;
    private var maxX:Number;

    public function NormalSlider(width:Number) {
      var trackWidth:Number = DPI.scale(width);
      track = new Sprite();
      track.graphics.beginFill(0x555555);
      track.graphics.drawRect(0,0,trackWidth,DPI.scale(8));
      track.graphics.endFill();
      track.graphics.beginFill(0x777777);
      track.graphics.drawRect(0,DPI.scale(3),trackWidth,DPI.scale(2));
      track.graphics.endFill();
      addChild(track);

      handle = new Sprite();
      handle.graphics.beginFill(0xCCCCCC);
      handle.graphics.drawCircle(0,DPI.scale(3),DPI.scale(10));
      handle.graphics.endFill();
      handle.graphics.beginFill(0xFFFFFF);
      handle.graphics.drawCircle(0,DPI.scale(3),DPI.scale(8));
      handle.graphics.endFill();
      handle.buttonMode = true;
      handle.addEventListener(MouseEvent.MOUSE_DOWN,startDragHandle);
      addChild(handle);

      minX = 0;
      maxX = trackWidth;
    }

    private function startDragHandle(event:MouseEvent):void {
      handle.startDrag(false,new Rectangle(minX,handle.y,maxX,0));
      stage.addEventListener(MouseEvent.MOUSE_UP,stopDragHandle);
      stage.addEventListener(Event.ENTER_FRAME,updateValueFromPosition);
    }

    private function stopDragHandle(event:MouseEvent):void {
      handle.stopDrag();
      stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragHandle);
      stage.removeEventListener(Event.ENTER_FRAME,updateValueFromPosition);
      updateValueFromPosition(null);
    }

    private function updateValueFromPosition(event:Event):void {
      var newValue:Number = (handle.x - minX) / (maxX - minX);
      newValue = Math.max(0,Math.min(1,newValue));
      if(Math.abs(newValue - _value) > 0.001) {
        value = newValue;
      }
    }

    public function get value():Number {
      return _value;
    }

    public function set value(v:Number):void {
      _value = Math.max(0,Math.min(1,v));
      handle.x = minX + (_value * (maxX - minX));
      dispatchEvent(new Event(Event.CHANGE));
    }

  }
}
