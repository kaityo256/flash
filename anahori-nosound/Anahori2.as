package {
  import flash.display.*;
  import flash.text.*;
  import flash.events.*;
  import flash.ui.*;
  import flash.geom.*;
  import flash.net.*;
  import flash.system.*;
  import flash.utils.*;

  [Frame(factoryClass="Preloader")]
  public class Anahori2 extends Sprite {

    [Embed(source='title.png')]
    private var TitleImg:Class;
    private var titlebmp:Bitmap = new TitleImg;

    private var bmpdata:BitmapData = new BitmapData(320,320,true,0x0);
    private var player:Player = new Player();
    private var drawer:Drawer = new Drawer(bmpdata);
    private var field:Field = new Field(drawer);

    private var currentStage:int = 0;

    private var gameStatus:int = Const.GS_OPENING;
    private var keyState:KeyInput = new KeyInput();

    private var endingCount:int = 0;

    public function Anahori2() {

      keyState.callback = action;
      graphics.beginFill(0x00);
      graphics.drawRect(0,0,320,320);

      var bmp:Bitmap = new Bitmap(bmpdata);
      addChild(bmp);
      bmpdata.copyPixels(titlebmp.bitmapData,new Rectangle(0,0,320,320), new Point(0,0));
      addChild(player);
      addEventListener(Event.ADDED, onAdded);
      SoundPlayer.init();
      SoundPlayer.playSound(Const.S_CLEAR);
      //SoundPlayer.playBGM(Const.BGM4);
    }

    private function onAdded(e:Event):void{
      this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyState.onKeyDown);
      this.stage.addEventListener(KeyboardEvent.KEY_UP, keyState.onKeyUp);
      this.stage.addEventListener(MouseEvent.CLICK, onClick);
      setInterval(onTimer,42);
    }

    public function onClick(e:MouseEvent):void{
      if(Const.GS_OPENING == gameStatus){
        gameStatus = Const.GS_NOWPLAYING;
      }
      if(Const.GS_ENDING == gameStatus){
        gameStatus = Const.GS_CLEARED;
        endingCount = Const.ENDING_COUNT;
        ending();
        return;
      }
      restart();
    }

    public function drawAll():void{
      player.draw();
      field.draw();
    }

    public function action(key:int):void{
      if(Const.GS_ENDING == gameStatus){
        return;
      }
      if(Const.GS_CLEARED == gameStatus){
        if(Keyboard.SPACE == key){
          currentStage++;
          if(currentStage == field.getLastStage()){
            currentStage = 0;
            SoundPlayer.playBGM(Const.BGM4);
            gameStatus = Const.GS_ENDING;
            return;
          }else{
            restart(); 
          }
        }
        return;
      }

      if(player.isDead){
        if(Keyboard.SPACE == key|| Keyboard.ESCAPE==key){
          restart();
        }
        return;
      }

      if(Keyboard.ESCAPE == key){
        restart();
        return;
      }

      if(74 == key){ // J
        currentStage++;
        if(currentStage >= field.getLastStage()){
          currentStage = field.getLastStage()-1;
        }
        restart();
        return;
      }
      if(75 == key){ // K
        currentStage--;
        if(currentStage <0){
          currentStage = 0;
        }
        restart();
        return;
      }

      player.action(key,field);

      if(player.clearCheck(field)){
        SoundPlayer.playSound(Const.S_CLEAR);
        gameStatus = Const.GS_CLEARED;
        drawer.drawEvent(Const.E_GETLOVE);
      }
    }

    public function onTimer():void{
      if(Const.GS_OPENING == gameStatus){
        return;
      }
      if(Const.GS_ENDING == gameStatus){
        ending();
        return;
      }
      if(keyState.moved()){
        return;
      }
      var key:int = keyState.getLastKey();
      action(key);
    }

    public function restart():void {
      gameStatus = Const.GS_NOWPLAYING;
      if(currentStage <6){
        SoundPlayer.playBGM(Const.BGM1);
      }else if (currentStage < 12){
        SoundPlayer.playBGM(Const.BGM2);
      }else{
        SoundPlayer.playBGM(Const.BGM3);
      }

      field.load(currentStage);
      player.init();
      drawAll();
    }

    private function ending():void{
     if(drawer.drawEnding(endingCount)){
        currentStage = 0;
        endingCount = 0;
        gameStatus = Const.GS_CLEARED;
      }else{
        endingCount++;
      }
    }

  }
}
