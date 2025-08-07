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

    private const deadZone:Number = 0.25;

    private function onAxisChange(event:Event):void {
      var control:GameInputControl = event.target as GameInputControl;
      switch(control.id) {
        case mapping.RIGHT_STICK_X:
          // Turret rotation
          if(control.value > deadZone) {
            simulateKeyPress(false,Keyboard.Z);
            simulateKeyPress(true,Keyboard.X);
          }
          else if(control.value < -deadZone) {
            simulateKeyPress(false,Keyboard.X);
            simulateKeyPress(true,Keyboard.Z);
          }
          else {
            simulateKeyPress(false,Keyboard.Z);
            simulateKeyPress(false,Keyboard.X);
          }
          break;
        case mapping.RIGHT_STICK_Y:
          // Camera
          if(control.value > deadZone) {
            simulateKeyPress(false,Keyboard.PAGE_UP);
            simulateKeyPress(true,Keyboard.PAGE_DOWN);
          }
          else if(control.value < -deadZone) {
            simulateKeyPress(false,Keyboard.PAGE_DOWN);
            simulateKeyPress(true,Keyboard.PAGE_UP);
          }
          else {
            simulateKeyPress(false,Keyboard.PAGE_UP);
            simulateKeyPress(false,Keyboard.PAGE_DOWN);
          }
          break;
        case mapping.DPAD_UP:
        case mapping.DPAD_DOWN:
          // Tank forward/backward
          if(control.value > 0) {
            simulateKeyPress(false,Keyboard.W);
            simulateKeyPress(true,Keyboard.S);
          }
          else if(control.value < 0) {
            simulateKeyPress(true,Keyboard.W);
            simulateKeyPress(false,Keyboard.S);
          }
          else {
            simulateKeyPress(false,Keyboard.W);
            simulateKeyPress(false,Keyboard.S);
          }
          break;
        case mapping.DPAD_LEFT:
        case mapping.DPAD_RIGHT:
          // Tank left/right
          if(control.value > 0) {
            simulateKeyPress(false,Keyboard.A);
            simulateKeyPress(true,Keyboard.D);
          }
          else if(control.value < 0) {
            simulateKeyPress(true,Keyboard.A);
            simulateKeyPress(false,Keyboard.D);
          }
          else {
            simulateKeyPress(false,Keyboard.A);
            simulateKeyPress(false,Keyboard.D);
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
          simulateKeyPress(control.value,Keyboard.SPACE);
          break;
        case mapping.LT:
          // Seld-destruct
          simulateKeyPress(control.value > 0.66,Keyboard.DELETE);
          break;
        case mapping.R3:
          // Center turret
          simulateKeyPress(control.value,Keyboard.C);
          break;
        case mapping.L3:
          // Open battle chat
          simulateKeyPress(control.value,Keyboard.ENTER);
          break;
        case mapping.DPAD_UP:
          // Tank forward
          simulateKeyPress(control.value,Keyboard.W);
          break;
        case mapping.DPAD_DOWN:
          // Tank backward
          simulateKeyPress(control.value,Keyboard.S);
          break;
        case mapping.DPAD_LEFT:
          // Tank left
          simulateKeyPress(control.value,Keyboard.A);
          break;
        case mapping.DPAD_RIGHT:
          // Tank right
          simulateKeyPress(control.value,Keyboard.D);
          break;
        case mapping.RB:
          // Drop flag
          simulateKeyPress(control.value,Keyboard.F);
          break;
        case mapping.LB:
          // Use medkit
          simulateKeyPress(control.value,Keyboard.NUMBER_1);
          break;
        case mapping.A:
          // Use double damage
          simulateKeyPress(control.value,Keyboard.NUMBER_3);
          break;
        case mapping.B:
          // Use nitro
          simulateKeyPress(control.value,Keyboard.NUMBER_4);
          break;
        case mapping.X:
          // Drop mine
          simulateKeyPress(control.value,Keyboard.NUMBER_5);
          break;
        case mapping.Y:
          // Use double armor
          simulateKeyPress(control.value,Keyboard.NUMBER_4);
          break;
        case mapping.SELECT:
          // Show statistics
          simulateKeyPress(control.value,Keyboard.TAB);
          break;
        case mapping.START:
          // Pause
          simulateKeyPress(control.value,Keyboard.P);
          break;
      }
    }

    private function simulateKeyPress(keyDown:Boolean,keyCodeValue:uint):void {
      var keyEventType:String = keyDown ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP;
      stage.dispatchEvent(new KeyboardEvent(keyEventType,true,false,0,keyCodeValue));
    }

  }
}