package {
  import flash.display.*;
  import flash.text.*;
  import flash.system.*;
  import flash.utils.*;
  import flash.geom.*;
  import flash.events.*;
  public class DrawText{

    private var textString:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789()/";
    private var textRect:Array = new Array(Const.MAX_COLOR);
    private var numberRect:Array = new Array(Const.MAX_COLOR);

    [Embed(source='alphabet.png')]
    private var AlphabetImg:Class;
    private var alphabetBmp:Bitmap = new AlphabetImg;

    public function DrawText() {
      var i:int = 0;
      var j:int = 0;
      var a:Array = textString.split("");

      for(j=0;j<Const.MAX_COLOR;j++){
        textRect[j] = new Object();
        for(i=0;i<a.length;i++){
          textRect[j][a[i]] = new Rectangle(i*Const.CHAR_WIDTH,j*Const.CHAR_HEIGHT,Const.CHAR_WIDTH,Const.CHAR_HEIGHT);
        }
      }
    }

    public function drawCenter(text:String, y:int, type:int, canvas:BitmapData):void{
      var x:int = Const.WIDTH/2 - text.length*Const.CHAR_WIDTH/2;
      draw(text,x,y,type,canvas);
    }

    public function drawRight(text:String, y:int, type:int, canvas:BitmapData):void{
      var x:int = Const.WIDTH - text.length*Const.CHAR_WIDTH;
      draw(text,x,y,type,canvas);
    }

    public function draw(text:String, x:int, y:int, type:int, canvas:BitmapData):void{
      var a:Array = text.split("");
      var i:int = 0;
      for(i =0;i<a.length;i++){
        canvas.copyPixels(alphabetBmp.bitmapData,textRect[type][a[i]], new Point(x+i*8,y));
      }
    }
  }
}
