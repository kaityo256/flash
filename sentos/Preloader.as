package {
  import flash.display.*;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.utils.getDefinitionByName;
  import flash.events.*;

  public class Preloader extends MovieClip {

    private var tf:TextField;

    public function Preloader() {
      stop();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.stageFocusRect = false;
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      tf = new TextField();
      tf.selectable = false;
      tf.x = 100;
      tf.y = 140;
      tf.textColor = 0xFFFFFF;
      tf.text = "Now Loading ... ";
      addChild(tf);
    }

    public function onEnterFrame(event:Event):void {
      if (framesLoaded == totalFrames) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        addEventListener(MouseEvent.CLICK,onClick);
        tf.x = 120;
        tf.text = "Click to Start!";
        nextFrame();
      } 
    }

    private function onClick(e:MouseEvent):void{
      init();
    }

    private function init():void {
      var mainClass:Class = Class(getDefinitionByName("Sentos"));
      if (mainClass) {
        removeChild(tf);
        var app:Sprite = new mainClass();
        addChild(app);
        }
    }
  }
}

