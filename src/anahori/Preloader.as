package {
  import flash.display.*;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.utils.getDefinitionByName;

  public class Preloader extends MovieClip {

    private var tf:TextField;

    public function Preloader() {
      stop();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.stageFocusRect = false;
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      tf = new TextField();
      tf.x = 100;
      tf.y = 140;
      tf.textColor = 0xFFFFFF;
      addChild(tf);
    }

    public function onEnterFrame(event:Event):void {
      if (framesLoaded == totalFrames) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        nextFrame();
        init();
      } else {
        var percent:Number = int(100 * root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal);
        tf.text = "Loading... " + percent + "%";
      }
    }

    private function init():void {
      var mainClass:Class = Class(getDefinitionByName("Anahori2"));
      if (mainClass) {
        removeChild(tf);
        var app:Sprite = new mainClass();
        addChild(app);
        }
    }
  }
}

