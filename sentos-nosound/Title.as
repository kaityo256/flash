package {
  import flash.display.*;
  import flash.text.*;
  import flash.system.*;
  import flash.utils.*;
  import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
  public class Title extends Sprite {

    private const WIDTH:int = Const.WIDTH;
    private const HEIGHT:int = Const.HEIGHT;
    private var backCanvas:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0);
    private var canvas:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0);
    private var theta:Number = 0;
    private var titleColor:uint = 0x010000;

    [Embed(source='title.png')]
    private var TitleImg:Class;
    private var titlebmp:Bitmap = new TitleImg;
    private var colorCount:uint = 0;
    private var colorArray:Array = new Array();

    private var urlButton:MyButton = new MyButton("(C) 2010 KAITYO");

    public function Title() {

      colorArray.push(0x010000);
      colorArray.push(0x000100);
      colorArray.push(0x000001);
      colorArray.push(0x000101);
      colorArray.push(0x010001);
      colorArray.push(0x010100);

      addChild(new Bitmap(backCanvas));
      var screen:Sprite = new Sprite();
      canvas.copyPixels(titlebmp.bitmapData,new Rectangle(0,0,320,320), new Point(0,0));
      screen.addChild(new Bitmap(canvas));
      addChild(screen);
      addChild(urlButton);
      urlButton.x = 200;
      urlButton.y = 304;
      urlButton.addEventListener(MouseEvent.CLICK,onURLButtonClick);
    }

    private function onURLButtonClick(e:MouseEvent):void{
      navigateToURL(new URLRequest("https://sites.google.com/site/kaityoapocalypse/"),"_blank");
    }

    public function show():void{
      this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame); 
      visible = true;
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
      theta = theta + 0.005;
      colorCount++;
      if(colorCount > 256){
        colorCount = 0;
        var r:int = (int)(Math.random()*colorArray.length);
        titleColor = colorArray[r];
      }
      var color:uint = (uint)(-64.0*Math.cos(2.0*colorCount*3.141592/256.0)+128);

      backCanvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      var s:Shape = new Shape();
      var i:int = 0;
      const w:Number = 320;
      const g:Number = 32;
      const n:int = 10;
      s.graphics.lineStyle(1,titleColor*color);
      var hx:Number = w*Math.cos(theta);
      var hy:Number = -w*Math.sin(theta);
      var dx:Number = g*Math.sin(theta);
      var dy:Number = g*Math.cos(theta);
      var sx:Number = 160.0+32.0*Math.sin(theta*3.0);
      var sy:Number = 160.0+32.0*Math.cos(theta*2.0+1.0);
      for(i=-n;i<n;i++){
        s.graphics.moveTo((int)(sx+dx*i-hx),(int)(sy+dy*i-hy));
        s.graphics.lineTo((int)(sx+dx*i+hx),(int)(sy+dy*i+hy));
      }
      backCanvas.draw(s);
      hx = w*Math.sin(theta);
      hy = w*Math.cos(theta);
      dx = g*Math.cos(theta);
      dy = -g*Math.sin(theta);
      for(i=-n;i<n;i++){
        s.graphics.moveTo((int)(sx+dx*i-hx),(int)(sy+dy*i-hy));
        s.graphics.lineTo((int)(sx+dx*i+hx),(int)(sy+dy*i+hy));
      }
      backCanvas.draw(s);
    }
  }
}
