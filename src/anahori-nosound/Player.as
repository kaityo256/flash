package {
  import flash.display.*;
  import flash.text.*;
  import flash.events.*;
  import flash.ui.*;
  import flash.geom.*;
  import flash.utils.*;

  public class Player extends Sprite{
    public const D_LEFT:int = 0;
    public const D_RIGHT:int = 1;
    public const D_UP:int = 2;
    public const D_DOWN:int = 3;

    public var px:int;
    public var py:int;
    public var dir:int;
    private var anime_count:int = 0;
    private var r_right:Array = new Array(5,6);
    private var r_left:Array = new Array(7,8);
    private var playerbmp:BitmapData = new BitmapData(32,32,true,0x0);
    private var drawer:Drawer = new Drawer(playerbmp);

    private var moveDir:int = 0;
    private var halfMoved:Boolean = false;
    private var digCount:int = 0;
    private var nowDigging:Boolean = false;

    public var isDead:Boolean = false;
    private var fallCounter:int = 0;
    public function Player(){
      addChild(new Bitmap(playerbmp));
      init();
    }

    public function init():void{
      nowDigging = false;
      halfMoved = false;
      isDead = false;
      visible = true;
      fallCounter = 0;
      dir = D_RIGHT;
      px = 0;
      py = 9;
      x = px*Const.CHARSIZE;
      y = py*Const.CHARSIZE;
    }

    public function draw():void{
      anime_count = (anime_count+1)%2;
      if(isDead){
        drawer.drawChar(0,0,9);
        return;
      }
      if(nowDigging){
        if(dir==D_RIGHT){
          drawer.drawChar(0,0,10);
        }else{
          drawer.drawChar(0,0,15);
        }
        return;
      } 

      if(dir==D_RIGHT){
        drawer.drawChar(0,0,r_right[anime_count]);
      }else if(dir==D_LEFT){
        drawer.drawChar(0,0,r_left[anime_count]);
      }
    }

    private function fall(field:Field):Boolean{
      if(fallCounter==0){
        SoundPlayer.playSound(Const.S_FALLMAN);
      }
      moveHalf(Const.D_DOWN);
      fallCounter++;
      return true; 
    }

    private function fallCheck(field:Field):Boolean {
      if(Const.SY -1 == py) return false;
      if(Const.T_NULL != field.getStageData(px,py)) return false;
      if(Const.T_LADDER == field.getStageData(px,py+1)) return false;
      if(Const.T_STONE == field.getStageData(px,py+1)) return false;
      if(Const.T_TUTI == field.getStageData(px,py+1)) return false;
      return true;
    }

    public function action(key:int, field:Field):void{
      if(halfMoved){
        moveHalfRest();
        return;
      }

      if(nowDigging){
        dig(field);
        return;
      }

      if(isDead)return;

      if(fallCheck(field)){
        fall(field);
        draw();
        return;
      }
      if(fallCounter >=2){
        isDead = true;
        draw();
        SoundPlayer.playSound(Const.S_FALL);
        field.drawFallDeath();
        if( 2 <= px && px <= 7 && 2 <= py && py <= 7){
          visible = false;
        }
        return;
      }
      fallCounter = 0;

      switch(key){
        case Keyboard.LEFT:
          dir = D_LEFT;
          if(!field.canMove(px,py,D_LEFT)){
            if(field.canPush(px,py,D_LEFT)){
              if(field.push(px,py,D_LEFT)){
                SoundPlayer.playSound(Const.S_FALL);
                isDead = true;
                visible = false;
                return;
              }
            }else{
              draw();
              return;
            }
          }
          moveHalf(Const.D_LEFT);
        break;
        case Keyboard.RIGHT:
          dir = D_RIGHT;
          if(!field.canMove(px,py,D_RIGHT)){
            if(field.canPush(px,py,D_RIGHT)){
              if(field.push(px,py,D_RIGHT)){
                SoundPlayer.playSound(Const.S_FALL);
                isDead = true;
                visible = false;
                return;
              }
            }else{
              draw();
              return;
            }
          }
          moveHalf(Const.D_RIGHT);
        break;
        case Keyboard.UP:
          if(field.canMove(px,py,D_UP)){
            moveHalf(Const.D_UP);
          }
        break;
        case Keyboard.DOWN:
          if(field.canMove(px,py,D_DOWN)){
            moveHalf(Const.D_DOWN);
          }
        break;
        case Keyboard.SPACE:
          if(field.canDig(px,py,dir)){
            nowDigging = true;
            SoundPlayer.playSound(Const.S_DIG);
            dig(field);
          }
        break;
      }
      draw();
    }

    private function moveHalf(d:int):void {
      moveDir = d;
      halfMoved = true;
      switch(d){
        case D_LEFT:
          x = px * Const.CHARSIZE - Const.CHARSIZE/2;
        break;
        case D_RIGHT:
          x = px * Const.CHARSIZE + Const.CHARSIZE/2;
        break;

        case D_UP:
          y = py * Const.CHARSIZE - Const.CHARSIZE/2;
        break;
        case D_DOWN:
          y = py * Const.CHARSIZE + Const.CHARSIZE/2;
        break;
      }
      draw();
    }

    private function moveHalfRest():void {
      switch(moveDir){
        case D_LEFT:
          px--;
          x = px * Const.CHARSIZE;
        break;
        case D_RIGHT:
          px++;
          x = px * Const.CHARSIZE;
        break;
        case D_UP:
          py--;
          y = py * Const.CHARSIZE;
        break;
        case D_DOWN:
          py++;
          y = py * Const.CHARSIZE;
        break;
      }
      draw();
      halfMoved = false;
    }

    public function clearCheck(field:Field):Boolean {
      if(field.clearCheck(px,py)){
        visible = false;
        return true;
      }else{
        return false;
      }
    }

    private function dig(field:Field):void{
      field.digAnimation(px,py,dir,digCount);
      digCount++;
      if(digCount >= 4){
        field.dig(px,py,dir);
        digCount = 0;
        nowDigging = false;
      }
      draw();
    }
  }
}

