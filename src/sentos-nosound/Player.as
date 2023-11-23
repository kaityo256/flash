package{
  import flash.display.*;

  public class Player {

    private var myHeight:Number = Const.HEIGHT*0.5;
    private var myAcceleration:Number = 0.0;
    private const LINE_SIZE:int = Const.LINE_SIZE;
    private var pastHeight:Array = new Array(LINE_SIZE);
    private const MAX_ACCELERATION:Number = 10.0;
    private var endingCount:int = 0;

    public function Player():void{
    }

    public function getPosition():Number {
      return myHeight;
    }

    public function init():void{
      endingCount = 0;
      myHeight = Const.HEIGHT/2;
      myAcceleration = 0;
      var i:int = 0;
      for(i=0;i<LINE_SIZE;i++){
        pastHeight[i] = myHeight;
      }
    }

    public function calcVelocity(myMouseDown:Boolean):void{
      myHeight = myHeight + myAcceleration;
      if(myHeight<Const.MARGIN){
        myHeight = Const.MARGIN;
      }else if(myHeight > Const.HEIGHT-Const.MARGIN){
        myHeight = Const.HEIGHT-Const.MARGIN;
      }
      if(myMouseDown){
        myAcceleration -= 0.5;
      }else{
        myAcceleration += 0.5;
      }
      if(myAcceleration >MAX_ACCELERATION){
        myAcceleration = MAX_ACCELERATION;
      }else if(myAcceleration < -MAX_ACCELERATION){
        myAcceleration = -MAX_ACCELERATION;
      }
    }

    public function drawWithoutMove(canvas:BitmapData):void{
      drawLine(canvas);
      endingCount++;
      var s:Shape = new Shape();
      s.graphics.lineStyle(1,0XFF0000);
      s.graphics.moveTo((LINE_SIZE-1)*Const.RESOLUTION,pastHeight[LINE_SIZE-1]);
      for(var i:int =0;i<endingCount;i++){
        s.graphics.lineTo((LINE_SIZE+i*3)*Const.RESOLUTION,pastHeight[LINE_SIZE-1]);
      }
      canvas.draw(s);
    }

    public function draw(canvas:BitmapData,myMouseDown:Boolean):void{
      calcVelocity(myMouseDown);
      drawLine(canvas);
    }

    private function drawLine(canvas:BitmapData): void{
      var i:int = 0;
      for(i=0;i<LINE_SIZE-1;i++){
        pastHeight[i] = pastHeight[i+1];
      }
      pastHeight[LINE_SIZE-1] = myHeight;
      var s:Shape = new Shape();
      s.graphics.lineStyle(1,0XFF0000);
      s.graphics.moveTo(0,pastHeight[0]);
      for(i =1;i<LINE_SIZE;i++){
        s.graphics.lineTo(i*Const.RESOLUTION,pastHeight[i]);
      }
      canvas.draw(s);
    }

  }
}
