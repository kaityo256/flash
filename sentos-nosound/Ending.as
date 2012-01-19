package {
  import flash.display.*;
  import flash.text.*;
  import flash.system.*;
  import flash.utils.*;
  import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
  public class Ending extends Sprite {

    private const WIDTH:int = Const.WIDTH;
    private const HEIGHT:int = Const.HEIGHT;
    private var backCanvas:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0);
    private var canvas:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0);
    private var drawText:DrawText = new DrawText();
    private var endingCount:int = 0;
    private var score:int = 0;
    private var clear_bonus:int = 0;
    private var max_combo:int = 0;
    private var timerID:uint = 0;
    private var sentos:Sentos;

    private const SIZE:int = 12;
    private var points:Array = new Array(SIZE);
    private var omega:Number = 0.0;
    private var colorArray:Array = new Array();
    private var colorCount:uint = 0;
    private var titleColor:uint = 0x010000;


    public function Ending(s:Sentos) {

      colorArray.push(0x010000);
      colorArray.push(0x000100);
      colorArray.push(0x000001);
      colorArray.push(0x000101);
      colorArray.push(0x010001);
      colorArray.push(0x010100);

      var i:int = 0;
      var j:int = 0;
      for(i=0;i<SIZE;i++){
        points[i] = new Array(SIZE);
      }
      for(i=0;i<SIZE;i++){
        for(j=0;j<SIZE;j++){
          points[i][j] = new Point(i*32-32,j*32-32);
        }
      }
      drawAll();

      sentos = s;
      addChild(new Bitmap(backCanvas));
      var screen:Sprite = new Sprite();
      screen.addChild(new Bitmap(canvas));
      addChild(screen);
      visible = false;
    }

    public function show(s:int, mc:int, cb:int):void{
      canvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      endingCount = 0;
      score = s;
      max_combo = mc;
      clear_bonus = cb;
      this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame); 
      visible = true;
      SoundPlayer.stopBGM();
      timerID = setInterval(onTimer,600);
    }

    private function onTimer():void{
      switch(endingCount){
        case 0:
         SoundPlayer.playSound(Const.S_CURSOR);
         drawText.drawCenter("CLEAR BONUS",32,Const.C_RED,canvas);
         drawText.drawCenter(clear_bonus.toString(),48,Const.C_RED,canvas);
        break;
        case 1:
         SoundPlayer.playSound(Const.S_CURSOR);
         drawText.drawCenter("MAX COMBO BONUS",80,Const.C_YELLOW,canvas);
         drawText.drawCenter(max_combo.toString() + " X 1000000",96,Const.C_YELLOW,canvas);
        break;
        case 2:
         SoundPlayer.playSound(Const.S_CURSOR);
         drawText.drawCenter("YOUR SCORE IS",128,Const.C_WHITE,canvas);
        break;
        case 3:
         SoundPlayer.playSound(Const.S_CURSOR);
         drawText.drawCenter(score.toString(),144,Const.C_WHITE,canvas);
        break;
        case 4:
         SoundPlayer.playSound(Const.S_COMBO);
         drawText.drawCenter("MISSION COMPLETE",176,Const.C_YELLOW,canvas);
        break;
        default:
          SoundPlayer.playBGM(Const.BGM_RANKING);
          clearInterval(timerID);
          sentos.showButtons();
        break;
      }
      endingCount++;
    }

    public function hide():void{
      if(!visible){
        return;
      }
      this.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame); 
      visible=false;
    }

    private function onEnterFrame(eventObject:Event):void{
      drawAll();
    }

    private function drawAll():void{
      omega = omega + 0.04;
      backCanvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      var s:Shape = new Shape();
      colorCount++;
      if(colorCount > 256){
        colorCount = 0;
        var r:int = (int)(Math.random()*colorArray.length);
        titleColor = colorArray[r];
      }
      var color:uint = (uint)(-64.0*Math.cos(2.0*colorCount*3.141592/256.0)+128);

      s.graphics.lineStyle(1,titleColor*color);
      var i:int = 0;
      var j:int = 0;
      var h:Number = 8.0;
      var p:Number = 0.1;
      for(i=0;i<SIZE-1;i++){
        for(j=0;j<SIZE-1;j++){
          var x1:Number = points[i][j].x + h*Math.cos(omega + (i*SIZE+j)*p);
          var y1:Number = points[i][j].y + h*Math.sin(omega + (i*SIZE+j)*p);

          var x2:Number = points[i+1][j].x + h*Math.cos(omega + ((i+1)*SIZE+j)*p);
          var y2:Number = points[i+1][j].y + h*Math.sin(omega + ((i+1)*SIZE+j)*p);

          var x3:Number = points[i][j+1].x + h*Math.cos(omega + (i*SIZE+j+1)*p);
          var y3:Number = points[i][j+1].y + h*Math.sin(omega + (i*SIZE+j+1)*p);

          s.graphics.moveTo(x1,y1);
          s.graphics.lineTo(x2,y2);
          s.graphics.moveTo(x1,y1);
          s.graphics.lineTo(x3,y3);
        }
      }
      backCanvas.draw(s);
    }
  }
}
