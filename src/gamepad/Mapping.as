package gamepad {

  internal class Mapping {

    /**
     * Down
     */
    public var A:String;

    /**
     * Right
     */
    public var B:String;

    /**
     * Left
     */
    public var X:String;

    /**
     * Up
     */
    public var Y:String;

    /**
     * Left bumper (L1)
     */
    public var LB:String;

    /**
     * Right bumper (R1)
     */
    public var RB:String;

    /**
     * Left trigger (L2)
     */
    public var LT:String;

    /**
     * Right trigger (R2)
     */
    public var RT:String;

    /**
     * Left stick press
     */
    public var L3:String;

    /**
     * Right stick press
     */
    public var R3:String;

    public var SELECT:String;
    public var START:String;

    public var DPAD_UP:String;
    public var DPAD_RIGHT:String;
    public var DPAD_DOWN:String;
    public var DPAD_LEFT:String;

    public var LEFT_STICK_X:String;
    public var LEFT_STICK_Y:String;
    public var RIGHT_STICK_X:String;
    public var RIGHT_STICK_Y:String;

    public function Mapping(deviceName:String,deviceId:String) {
      if(deviceName == 'Xbox Wireless Controller' || deviceName == 'Microsoft X-Box 360 pad') {
        setXboxMapA();
      }
      else if(deviceName.startsWith('Xbox') || deviceId.startsWith('XINPUT')) {
        setXboxMapB();
      }
      else if(deviceName.startsWith('PLAYSTATION')) {
        setPSMapA();
      }
      else if(deviceName.endsWith('Wireless Controller')) {
        setPSMapB();
      }
      else if(deviceName.startsWith('Logitech')) {
        setLogitechMap();
      }
      else if(deviceName.startsWith('USB gamepad')) {
        setSNESMap();
      }
    }

    private function setXboxMapA():void {
      A = button(96);
      B = button(97);
      X = button(99);
      Y = button(100);
      LB = button(102);
      RB = button(103);
      LT = axis(23);
      RT = axis(22);
      SELECT = button(109);
      START = button(108);
      L3 = button(106);
      R3 = button(107);
      DPAD_UP = axis(16);
      DPAD_DOWN = axis(16);
      DPAD_LEFT = axis(15);
      DPAD_RIGHT = axis(15);
      LEFT_STICK_X = axis(0);
      LEFT_STICK_Y = axis(1);
      RIGHT_STICK_X = axis(11);
      RIGHT_STICK_Y = axis(14);
    }

    private function setXboxMapB():void {
      A = button(4);
      B = button(5);
      X = button(6);
      Y = button(7);
      LB = button(8);
      RB = button(9);
      LT = button(10);
      RT = button(11);
      SELECT = button(12);
      START = button(13);
      L3 = button(14);
      R3 = button(15);
      DPAD_UP = button(16);
      DPAD_DOWN = button(17);
      DPAD_LEFT = button(18);
      DPAD_RIGHT = button(19);
      LEFT_STICK_X = axis(0);
      LEFT_STICK_Y = axis(1);
      RIGHT_STICK_X = axis(2);
      RIGHT_STICK_Y = axis(3);
    }

    private function setPSMapA():void {
      A = button(18);
      B = button(17);
      X = button(19);
      Y = button(16);
      LB = button(14);
      RB = button(15);
      LT = button(12);
      RT = button(13);
      SELECT = button(4);
      START = button(7);
      L3 = button(5);
      R3 = button(6);
      DPAD_UP = button(8);
      DPAD_DOWN = button(10);
      DPAD_LEFT = button(11);
      DPAD_RIGHT = button(9);
      LEFT_STICK_X = axis(0);
      LEFT_STICK_Y = axis(1);
      RIGHT_STICK_X = axis(2);
      RIGHT_STICK_Y = axis(3);
    }

    private function setPSMapB():void {
      A = button(11);
      B = button(12);
      X = button(10);
      Y = button(13);
      LB = button(14);
      RB = button(15);
      LT = axis(3);
      RT = axis(4);
      SELECT = button(18);
      START = button(19);
      L3 = button(14);
      R3 = button(15);
      DPAD_UP = button(6);
      DPAD_DOWN = button(7);
      DPAD_LEFT = button(8);
      DPAD_RIGHT = button(9);
      LEFT_STICK_X = axis(0);
      LEFT_STICK_Y = axis(1);
      RIGHT_STICK_X = axis(2);
      RIGHT_STICK_Y = axis(5);
    }

    private function setLogitechMap():void {
      A = button(9);
      B = button(10);
      X = button(8);
      Y = button(11);
      LB = button(12);
      RB = button(13);
      LT = button(14);
      RT = button(15);
      SELECT = button(16);
      START = button(17);
      L3 = button(18);
      R3 = button(19);
      DPAD_UP = button(4);
      DPAD_DOWN = button(5);
      DPAD_LEFT = button(6);
      DPAD_RIGHT = button(7);
      LEFT_STICK_X = axis(0);
      LEFT_STICK_Y = axis(1);
      RIGHT_STICK_X = axis(2);
      RIGHT_STICK_Y = axis(3);
    }

    private function setSNESMap():void {
      A = button(3);
      B = button(4);
      X = button(2);
      Y = button(5);
      LT = button(6);
      RT = button(7);
      SELECT = button(10);
      START = button(11);
      DPAD_UP = axis(1);
      DPAD_DOWN = axis(1);
      DPAD_LEFT = axis(0);
      DPAD_RIGHT = axis(0);
    }

    private static function button(id:uint):String {
      return 'BUTTON_' + id.toString();
    }

    private static function axis(id:uint):String {
      return 'AXIS_' + id.toString();
    }
  }
}