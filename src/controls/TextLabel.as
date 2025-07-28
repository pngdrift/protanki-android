package controls {
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;

  public class TextLabel extends TextField {

    public function TextLabel(labelText:String = '',labelSize:int = 20,color:int = 0xFFFFFF) {
      defaultTextFormat = new TextFormat('_sans',labelSize,color,true);
      text = labelText;
      selectable = false;
      autoSize = TextFieldAutoSize.LEFT;
    }

  }
}