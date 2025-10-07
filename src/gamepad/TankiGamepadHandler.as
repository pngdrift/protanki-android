package gamepad {
  import controls.TextLabel;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.GameInputEvent;
  import flash.events.KeyboardEvent;
  import flash.ui.GameInput;
  import flash.ui.GameInputControl;
  import flash.ui.GameInputDevice;
  import flash.ui.Keyboard;

  public class TankiGamepadHandler {

    private var stage:Stage;
    private var gameInput:GameInput;
    private var mapping:Mapping;

    public function TankiGamepadHandler(stage:Stage) {
      this.stage = stage;
    }

    public function init():Boolean {
      if(!GameInput.isSupported) {
        return false;
      }
      gameInput = new GameInput();
      gameInput.addEventListener(GameInputEvent.DEVICE_ADDED,onDeviceAdded);
      gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED,onDeviceRemoved);
      return true;
    }

    private function onDeviceRemoved(event:GameInputEvent):void {
      var device:GameInputDevice = event.device;
      trace('Device removed',device.name);
    }

    private function onDeviceAdded(event:GameInputEvent):void {
      var device:GameInputDevice = event.device;
      trace('Device added',device.name);
      device.enabled = true;
      mapping = new Mapping(device.name,device.id);
      for(var i:int = 0; i < device.numControls; i++) {
        var control:GameInputControl = device.getControlAt(i);
        if(control.id.startsWith('BUTTON_')) {
          control.addEventListener(Event.CHANGE,onButtonChange);
        }
        else {
          control.addEventListener(Event.CHANGE,onAxisChange);
        }
      }
      // stage.addChild(new TextLabel('Gamepad: ' + device.name + '__' + device.id));
    }

    private const deadZone:Number = 0.30;

    private function onAxisChange(event:Event):void {
      var control:GameInputControl = event.target as GameInputControl;
      switch(control.id) {
        case mapping.RIGHT_STICK_X:
          // Turret rotation
          if(control.value > deadZone) {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.Z);
            KeyUtil.simulateKeyPress(stage,true,Keyboard.X);
          }
          else if(control.value < -deadZone) {
            KeyUtil.simulateKeyPress(stage,true,Keyboard.Z);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.X);
          }
          else {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.Z);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.X);
          }
          break;
        case mapping.RIGHT_STICK_Y:
          // Camera
          if(control.value > deadZone) {
            KeyUtil.simulateKeyPress(stage,true,Keyboard.PAGE_DOWN);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.PAGE_UP);
          }
          else if(control.value < -deadZone) {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.PAGE_DOWN);
            KeyUtil.simulateKeyPress(stage,true,Keyboard.PAGE_UP);
          }
          else {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.PAGE_DOWN);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.PAGE_UP);
          }
          break;
        case mapping.DPAD_UP:
        case mapping.DPAD_DOWN:
          // Tank forward/backward
          if(control.value > 0.01) {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.W);
            KeyUtil.simulateKeyPress(stage,true,Keyboard.S);
          }
          else if(control.value < -0.01) {
            KeyUtil.simulateKeyPress(stage,true,Keyboard.W);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.S);
          }
          else {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.W);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.S);
          }
          break;
        case mapping.DPAD_LEFT:
        case mapping.DPAD_RIGHT:
          // Tank left/right
          if(control.value > 0.01) {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.A);
            KeyUtil.simulateKeyPress(stage,true,Keyboard.D);
          }
          else if(control.value < -0.01) {
            KeyUtil.simulateKeyPress(stage,true,Keyboard.A);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.D);
          }
          else {
            KeyUtil.simulateKeyPress(stage,false,Keyboard.A);
            KeyUtil.simulateKeyPress(stage,false,Keyboard.D);
          }
          break;
        case mapping.RT:
        case mapping.LT:
          onButtonChange(event);
          break;
      }
    }

    private function onButtonChange(event:Event):void {
      var control:GameInputControl = event.target as GameInputControl;
      switch(control.id) {
        case mapping.RT:
          // Shoot
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.SPACE);
          break;
        case mapping.LT:
          // Seld-destruct
          KeyUtil.simulateKeyPress(stage,control.value > 0.66,Keyboard.DELETE);
          break;
        case mapping.R3:
          // Center turret
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.C);
          break;
        case mapping.L3:
          // Open battle chat
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.ENTER);
          break;
        case mapping.DPAD_UP:
          // Tank forward
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.W);
          break;
        case mapping.DPAD_DOWN:
          // Tank backward
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.S);
          break;
        case mapping.DPAD_LEFT:
          // Tank left
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.A);
          break;
        case mapping.DPAD_RIGHT:
          // Tank right
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.D);
          break;
        case mapping.RB:
          // Drop flag
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.F);
          break;
        case mapping.LB:
          // Use medkit
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.NUMBER_1);
          break;
        case mapping.A:
          // Use double damage
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.NUMBER_3);
          break;
        case mapping.B:
          // Use nitro
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.NUMBER_4);
          break;
        case mapping.X:
          // Drop mine
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.NUMBER_5);
          break;
        case mapping.Y:
          // Use double armor
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.NUMBER_2);
          break;
        case mapping.SELECT:
          // Show statistics
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.TAB);
          break;
        case mapping.START:
          // Pause
          KeyUtil.simulateKeyPress(stage,control.value,Keyboard.P);
          break;
      }
    }

  }
}