package{
  import flash.display.*;
  import flash.text.*;
  import flash.events.*;
  import flash.ui.*;
  import flash.geom.*;
  import flash.net.*;
  import flash.system.*;


  public class Drawer {
    [Embed(source='charset.png')]
    private var CharImg:Class;

    [Embed(source='d_asshi.png')]
    private var EventAsshi:Class;
    [Embed(source='d_maishi.png')]
    private var EventMaishi:Class;
    [Embed(source='d_rakushi.png')]
    private var EventRakushi:Class;
    [Embed(source='d_sashishi.png')]
    private var EventSashishi:Class;
    [Embed(source='d_getlove.png')]
    private var EventGetLove:Class;

    [Embed(source='ending.png')]
    private var EventEnding:Class;
    private var endingImage:Bitmap = new EventEnding();

    private var dest:BitmapData;
    public var charset:Bitmap;
    private var eventImage:Array = new Array();

    public function Drawer(d:BitmapData){
      charset = new CharImg();
      dest = d;
      eventImage.push(new EventAsshi);
      eventImage.push(new EventMaishi);
      eventImage.push(new EventRakushi);
      eventImage.push(new EventSashishi);
      eventImage.push(new EventGetLove);
    }

    public function drawEvent(index:int):void{
      dest.copyPixels(eventImage[index].bitmapData,new Rectangle(0,0,192,192), new Point(64,64));
    }

    public function drawChar(ix:uint, iy:uint, index:uint) :void{
      var mx:uint = ix * Const.CHARSIZE;
      var my:uint = iy * Const.CHARSIZE;
      var ccx:uint = (index%5);
      var ccy:uint = (index-ccx)/5;
      ccx = ccx * Const.CHARSIZE;
      ccy = ccy * Const.CHARSIZE;
      dest.copyPixels(charset.bitmapData,new Rectangle(ccx,ccy,Const.CHARSIZE,Const.CHARSIZE), new Point(mx,my));
    }

    public function drawEnding(count:int):Boolean{
      if(0==count){
        for(var ix:int=0;ix<Const.SX;ix++){
          for(var iy:int=0;iy<Const.SY;iy++){
            drawChar(ix,iy,Const.T_NULL);
          }
        }
      }

      var pos:int = count;
      if(pos < 256){
        dest.copyPixels(endingImage.bitmapData,new Rectangle(0,0,256,pos), new Point(32,256+32-pos));
      }else{
        dest.copyPixels(endingImage.bitmapData,new Rectangle(0,pos-256,256,256), new Point(32,32));
      }
      if(pos < Const.ENDING_COUNT){
        return false;
      }else{
        return true;
      }
    }
  }
}
