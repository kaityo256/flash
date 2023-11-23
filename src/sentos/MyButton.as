package {
  import flash.display.*;
  import flash.text.*;
  import flash.system.*;
  import flash.utils.*;
  import flash.geom.*;
  import flash.events.*;
  public class MyButton extends Sprite {

    private var drawText:DrawText = new DrawText();
    private var canvas:BitmapData;
    private var caption:String;

    public function MyButton(text:String){
      caption = text;
      var w:int = caption.length * Const.CHAR_WIDTH;
      var h:int = Const.CHAR_HEIGHT;
      canvas = new BitmapData(w,h,true,0);
      addChild(new Bitmap(canvas));
      drawText.draw(caption,0,0,Const.TYPE_SCORE,canvas);
      addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
    }

    public function onMouseOver(e:MouseEvent):void{
      SoundPlayer.playSound(Const.S_CURSOR);
      drawText.draw(caption,0,0,Const.C_RED,canvas);
    }

    public function onMouseOut(e:MouseEvent):void{
      drawText.draw(caption,0,0,Const.C_WHITE,canvas);
    }

  }
}
