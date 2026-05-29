package controls {
  import flash.desktop.NativeApplication;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.SharedObject;
  import flash.text.TextField;
  import lang.t;

  public class SettingsMenu extends Sprite {

    private var settingsButton:SettingsButton;
    private var onScreenControls:OnScreenControlsLayer;

    private var alphaSlider:NormalSlider;
    private var showControlsCheckbox:Checkbox;

    public function SettingsMenu(button:SettingsButton,touchControls:OnScreenControlsLayer) {
      this.settingsButton = settingsButton;
      this.onScreenControls = touchControls;
      createUI();
      loadSettings();
    }

    private function createUI():void {
      graphics.beginFill(0x333333,0.8);
      graphics.drawRect(0,0,DPI.scale(240),DPI.scale(180));
      graphics.endFill();

      var title:TextField = new TextLabel(t('settings'),DPI.scale(16));
      title.x = DPI.scale(10);
      title.y = DPI.scale(5);
      addChild(title);

      var hint:TextField = new TextLabel(t('drag_buttons_hint'),DPI.scale(12));
      hint.x = DPI.scale(10);
      hint.y = DPI.scale(30);
      addChild(hint);

      showControlsCheckbox = new Checkbox();
      showControlsCheckbox.x = DPI.scale(10);
      showControlsCheckbox.y = DPI.scale(50);
      showControlsCheckbox.addEventListener(MouseEvent.CLICK,onShowControlsChange);
      addChild(showControlsCheckbox);

      var showControlsLabel:TextLabel = new TextLabel(t('show_controls'),DPI.scale(12));
      showControlsLabel.x = showControlsCheckbox.width + DPI.scale(10);
      showControlsLabel.y = showControlsCheckbox.y + DPI.scale(2);
      addChild(showControlsLabel);

      var resetButtons:TextLabel = new TextLabel('<u>' + t('reset_buttons_position') + '</u>',DPI.scale(12));
      resetButtons.htmlText = resetButtons.text;
      resetButtons.x = DPI.scale(10);
      resetButtons.y = DPI.scale(80);
      resetButtons.addEventListener(MouseEvent.CLICK,onResetButtons);
      addChild(resetButtons);

      var alphaLabel:TextLabel = new TextLabel(t('settings_button_opacity'),DPI.scale(12));
      alphaLabel.x = DPI.scale(10);
      alphaLabel.y = DPI.scale(130);
      addChild(alphaLabel);
      alphaSlider = new NormalSlider(180);
      alphaSlider.x = DPI.scale(10);
      alphaSlider.y = DPI.scale(150);
      alphaSlider.value = 1.0;
      alphaSlider.addEventListener(Event.CHANGE,onAlphaChange);
      addChild(alphaSlider);
    }

    private function onLanguageChange(lang:String):void {
      var storage:SharedObject = SharedObject.getLocal('storage');
      storage.data.language = lang;
      storage.flush();
      NativeApplication.nativeApplication.exit();
    }

    private function onShowControlsChange(event:MouseEvent):void {
      onScreenControls.setControlsEnabled(showControlsCheckbox.checked);
      saveSettings();
    }

    private function onAlphaChange(event:Event):void {
      var newAlpha:Number = alphaSlider.value;
      settingsButton.alpha = newAlpha;
      saveSettings();
    }

    private function onResetButtons(event:MouseEvent):void {
      onScreenControls.resetPositions();
    }

    private function loadSettings():void {
      var storage:SharedObject = SharedObject.getLocal('storage');
      var showControls:Boolean = storage.data.showControls ?? true;
      showControlsCheckbox.checked = showControls;
      onScreenControls.setControlsEnabled(showControls);
      if(storage.data.settingButtonAlpha != undefined) {
        alphaSlider.value = storage.data.settingButtonAlpha;
        settingsButton.alpha = alphaSlider.value;
      }
    }

    private function saveSettings():void {
      var storage:SharedObject = SharedObject.getLocal('storage');
      storage.data.showControls = showControlsCheckbox.checked;
      storage.data.settingButtonAlpha = alphaSlider.value;
      storage.flush();
    }

  }
}
