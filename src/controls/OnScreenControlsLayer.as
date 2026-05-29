package controls {
  import flash.display.DisplayObjectContainer;
  import flash.display.Screen;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TouchEvent;
  import flash.geom.Point;
  import flash.net.SharedObject;
  import flash.ui.Keyboard;
  import flash.ui.Multitouch;
  import flash.ui.MultitouchInputMode;
  import flash.utils.Dictionary;

  public class OnScreenControlsLayer extends Sprite {

    private var settingsMenu:SettingsMenu;

    private var allButtons:Vector.<ControlButton> = new Vector.<ControlButton>();

    private var activeControls:Dictionary = new Dictionary();

    private var touchStates:Vector.<ControlButton> = new Vector.<ControlButton>(5);

    private var defaultPositions:Object;

    private const buttonSizes:Vector.<Number> = Vector.<Number>([DPI.scale(40),DPI.scale(50),DPI.scale(70)]);

    public function OnScreenControlsLayer() {
      super();
      Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
      addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
      defaultPositions = getDefaultPositions();
      createControls();
      createSettings();
      loadPositions();
    }

    private function createSettings():void {
      var settingsButton:SettingsButton = new SettingsButton();
      settingsButton.x = Math.max(Screen.mainScreen.safeArea.x,DPI.scale(10));
      settingsButton.y = DPI.scale(10);
      settingsButton.addEventListener(MouseEvent.CLICK,toggleSettingsMenu);
      addChild(settingsButton);

      settingsMenu = new SettingsMenu(settingsButton,this);
      settingsMenu.x = settingsButton.x;
      settingsMenu.y = settingsButton.y + settingsButton.height;
      settingsMenu.visible = false;
      addChild(settingsMenu);
    }

    private function toggleSettingsMenu(event:MouseEvent):void {
      settingsMenu.visible = !settingsMenu.visible;
    }

    private function getDefaultPositions():Object {
      var leftX:Number = stage.stageWidth * 0.15;
      var rightX:Number = stage.stageWidth * 0.80;
      var baseY:Number = stage.stageHeight * 0.60;
      var diffSize:Number = buttonSizes[1] - buttonSizes[0];
      return {
          W: new Point(leftX,baseY - buttonSizes[1]),
          A: new Point(leftX - buttonSizes[1],baseY),
          S: new Point(leftX,baseY + buttonSizes[1]),
          D: new Point(leftX + buttonSizes[1],baseY),
          WA: new Point(leftX - buttonSizes[1] + diffSize,baseY - buttonSizes[1] + diffSize),
          WD: new Point(leftX + buttonSizes[1],baseY - buttonSizes[1] + diffSize),
          SA: new Point(leftX - buttonSizes[1] + diffSize,baseY + buttonSizes[1]),
          SD: new Point(leftX + buttonSizes[1],baseY + buttonSizes[1]),

          Z: new Point(rightX - buttonSizes[1],baseY),
          X: new Point(rightX,baseY),

          SPACE: new Point(rightX + buttonSizes[1] * 1.1,baseY - buttonSizes[1] * 1.2),

          ENTER: new Point(rightX + buttonSizes[0] * 1.1,baseY - buttonSizes[0] * 4)
        };
    }

    private function addStageListeners():void {
      stage.addEventListener(TouchEvent.TOUCH_BEGIN,onStageTouchBegin);
      stage.addEventListener(TouchEvent.TOUCH_MOVE,onStageTouchMove);
      stage.addEventListener(TouchEvent.TOUCH_END,onStageTouchEnd);
    }

    private function removeStageListeners():void {
      stage.removeEventListener(TouchEvent.TOUCH_BEGIN,onStageTouchBegin);
      stage.removeEventListener(TouchEvent.TOUCH_MOVE,onStageTouchMove);
      stage.removeEventListener(TouchEvent.TOUCH_END,onStageTouchEnd);
    }

    private function onStageTouchBegin(event:TouchEvent):void {
      if(settingsMenu.visible) {
        return;
      }
      var touchId:int = event.touchPointID;
      var button:ControlButton = getButtonAt(event.stageX,event.stageY);
      if(button != null) {
        touchStates[touchId] = button;
        setButtonState(button,true);
      }
    }

    private function onStageTouchMove(event:TouchEvent):void {
      if(settingsMenu.visible) {
        return;
      }
      var touchId:int = event.touchPointID;
      var buttonUnderTouch:ControlButton = getButtonAt(event.stageX,event.stageY);
      var currentButton:ControlButton = touchStates[touchId];
      if(buttonUnderTouch == currentButton) {
        return;
      }
      if(currentButton != null) {
        setButtonState(currentButton,false);
      }
      if(buttonUnderTouch != null) {
        setButtonState(buttonUnderTouch,true);
      }
      touchStates[touchId] = buttonUnderTouch;
    }

    [Inline]
    private final function getButtonAt(stageX:Number,stageY:Number):ControlButton {
      var result:ControlButton = null;
      var localX:Number = stageX - x;
      var localY:Number = stageY - y;
      for each(var button:ControlButton in allButtons) {
        if(button.hitTestPoint(localX,localY)) {
          result = button;
          break;
        }
      }
      return result;
    }

    private function onStageTouchEnd(event:TouchEvent):void {
      var touchId:int = event.touchPointID;
      var currentButton:ControlButton = touchStates[touchId];
      if(currentButton == null) {
        return;
      }
      setButtonState(currentButton,false);
      touchStates[touchId] = null;
    }

    private function createControls():void {
      var movementGroup:Sprite = new Sprite();
      createControl(movementGroup,'W',Keyboard.W);
      createControl(movementGroup,'A',Keyboard.A);
      createControl(movementGroup,'S',Keyboard.S);
      createControl(movementGroup,'D',Keyboard.D);
      createControl(movementGroup,'WA',Keyboard.W,Keyboard.A);
      createControl(movementGroup,'WD',Keyboard.W,Keyboard.D);
      createControl(movementGroup,'SA',Keyboard.S,Keyboard.A);
      createControl(movementGroup,'SD',Keyboard.S,Keyboard.D);
      addChild(movementGroup);

      var turretRotationGroup:Sprite = new Sprite();
      createControl(turretRotationGroup,'Z',Keyboard.Z);
      createControl(turretRotationGroup,'X',Keyboard.X);
      addChild(turretRotationGroup);

      createControl(this,'SPACE',Keyboard.SPACE);

      createControl(this,'ENTER',Keyboard.ENTER);
    }

    private function createControl(group:Sprite,label:String,keyCode1:uint,keyCode2:uint = 0):void {
      var position:Point = defaultPositions[label];
      var size:Number = buttonSizes[1];
      if(keyCode1 == Keyboard.SPACE) {
        size = buttonSizes[2];
      }
      else if(keyCode2 != 0 || keyCode1 == Keyboard.ENTER) {
        size = buttonSizes[0];
      }
      var button:ControlButton = new ControlButton(label,(keyCode2 << 16) | (keyCode1 & 0xFFFF),size,0x1e1e1e);
      button.x = position.x;
      button.y = position.y;
      button.addEventListener(MouseEvent.MOUSE_DOWN,startDragControl);
      group.addChild(button);
      allButtons.push(button);
      activeControls[label] = false;
    }

    private function setButtonState(button:ControlButton,pressed:Boolean):void {
      var label:String = button.getLabel();
      if(activeControls[label] == pressed) {
        return;
      }
      activeControls[label] = pressed;
      button.alpha = pressed ? 0.7 : 1.0;
      var keyCodes:uint = button.getKeyCodes();
      var keyCode1:uint = keyCodes & 0xFFFF;
      var keyCode2:uint = keyCodes >> 16;
      KeyUtil.simulateKeyPress(stage,pressed,keyCode1);
      if(keyCode2 != 0) {
        KeyUtil.simulateKeyPress(stage,pressed,keyCode2);
      }
    }

    public function savePositions():void {
      var storage:SharedObject = SharedObject.getLocal('storage');
      var positions:Object = {};
      for each(var button:ControlButton in allButtons) {
        var parent:DisplayObjectContainer = button.parent;
        positions[button.getLabel()] = new Point(parent.x + button.x,parent.y + button.y);
      }
      storage.data.positions = positions;
      storage.flush();
    }

    private function loadPositions():void {
      var storage:SharedObject = SharedObject.getLocal('storage');
      var positions:Object = storage.data.positions;
      if(positions == null) {
        return;
      }
      for each(var button:ControlButton in allButtons) {
        var label:String = button.getLabel();
        var position:Object = positions[label];
        if(position == null) {
          continue;
        }
        button.x = position.x;
        button.y = position.y;
      }
    }

    public function resetPositions():void {
      for each(var button:ControlButton in allButtons) {
        var position:Point = defaultPositions[button.getLabel()];
        if(button.parent != this) {
          button.parent.x = 0;
          button.parent.y = 0;
        }
        button.x = position.x;
        button.y = position.y;
      }
      savePositions();
    }

    public function setControlsEnabled(enabled:Boolean):void {
      if(enabled) {
        addStageListeners();
      }
      else {
        removeStageListeners();
      }
      for each(var button:ControlButton in allButtons) {
        button.visible = enabled;
      }
      var storage:SharedObject = SharedObject.getLocal('storage');
      storage.data.showControls = enabled;
      storage.flush();
    }

    private var draggedElement:Sprite;

    private function startDragControl(event:MouseEvent):void {
      if(!settingsMenu.visible) {
        return;
      }
      draggedElement = event.currentTarget as Sprite;
      if(draggedElement == null) {
        return;
      }
      if(draggedElement.parent != this) {
        draggedElement = draggedElement.parent as Sprite;
      }
      draggedElement.startDrag();
      stage.addEventListener(MouseEvent.MOUSE_UP,stopDragControl);
    }

    private function stopDragControl(event:MouseEvent):void {
      draggedElement.stopDrag();
      stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragControl);
      savePositions();
    }

  }
}
