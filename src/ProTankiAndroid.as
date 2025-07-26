package {
  import flash.desktop.NativeApplication;
  import flash.display.*;
  import flash.events.*;
  import flash.net.*;
  import flash.system.*;
  import flash.text.*;
  import flash.utils.*;

  public class ProTankiAndroid extends Sprite {

    private static const IDLE_TIMEOUT:int = 1500;

    private static const resourceUrlMirrors:Vector.<String> = Vector.<String>([
          'http://tankiresources.com',
          'http://194.67.196.216',
          'https://s.pro-tanki.com'
        ]);

    private var currentMirrorIndex:int = 0;

    private function get resourceUrl():String {
      return resourceUrlMirrors[currentMirrorIndex];
    }

    private var timeoutId:uint;
    private var urlloader:URLLoader;

    public function ProTankiAndroid() {
      super();
      addEventListener(Event.ADDED_TO_STAGE,init);
    }

    private function init(event:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE,init);
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      loadTankiLoader();
    }

    private function loadTankiLoader():void {
      trace('Trying resourceUrl',resourceUrl);
      urlloader = new URLLoader();
      urlloader.dataFormat = URLLoaderDataFormat.BINARY;
      urlloader.addEventListener(IOErrorEvent.IO_ERROR,onLoadingError);
      urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadingError);
      urlloader.addEventListener(ProgressEvent.PROGRESS,onProgress);
      urlloader.addEventListener(Event.COMPLETE,onUrlloaderComplete);
      urlloader.load(new URLRequest(resourceUrl + '/Loader.swf'));
      renewTimeout();
    }

    private function renewTimeout():void {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(onLoadingError,IDLE_TIMEOUT);
    }

    private function onProgress(event:Event):void {
      renewTimeout();
    }

    private function onLoadingError(event:Event = null):void {
      cleanupUrlloader();
      tryNextUrl();
    }

    private function cleanupUrlloader():void {
      clearTimeout(timeoutId);
      urlloader.close();
      urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onLoadingError);
      urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadingError);
      urlloader.removeEventListener(Event.COMPLETE,onUrlloaderComplete);
      urlloader = null;
    }

    private function tryNextUrl():void {
      currentMirrorIndex++;
      if(currentMirrorIndex < resourceUrlMirrors.length) {
        loadTankiLoader();
      }
      else {
        var tf:TextField = new TextField();
        tf.defaultTextFormat = new TextFormat('Tahoma',42,0xCCCCCC);
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.text = 'Loading error';
        tf.x = tf.y = 50;
        addChild(tf);
      }
    }

    private function onUrlloaderComplete(event:Event):void {
      var loader:Loader = new Loader();
      var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
      context.parameters = {
          resources: resourceUrl,
          config: resourceUrl + '/config.xml',
          swf: resourceUrl + '/library.swf',
          lang: getLang()
        };
      context.allowCodeImport = true;
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
      loader.loadBytes(urlloader.data as ByteArray,context);
      cleanupUrlloader();
    }

    private function onComplete(event:Event):void {
      var contentLoaderInfo:LoaderInfo = event.target as LoaderInfo;
      contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
      addChild(contentLoaderInfo.loader);
    }

    /**
     * @return Game localization
     */
    private static function getLang():String {
      switch(Capabilities.language) {
        case 'ru':
          return 'ru';
        case 'pt':
          return 'pt_BR';
        case 'en':
        default:
          return 'en';
      }
    }

    /**
     * Invoked by the game
     */
    public function closeLauncher():void {
      NativeApplication.nativeApplication.exit();
    }

  }
}