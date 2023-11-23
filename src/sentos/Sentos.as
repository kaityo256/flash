package {
  import flash.display.*;
  import flash.text.*;
  import flash.system.*;
  import flash.utils.*;
  import flash.geom.*;
  import flash.events.*;
  import flash.ui.*;

  [Frame(factoryClass="Preloader")]
  public class Sentos extends Sprite {

    private const WIDTH:int = Const.WIDTH;
    private const HEIGHT:int = Const.HEIGHT;
    private const MARGIN:int = Const.MARGIN;
    private var canvas:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0);

    private var startButton:MyButton = new MyButton("START");
    private var titleButton:MyButton = new MyButton("TITLE");
    private var submitButton:MyButton = new MyButton("SUBMIT SCORE");

    private var myMouseDown:Boolean = false;

    private var drawText:DrawText = new DrawText();
    private var player:Player = new Player();

    private const MAX_HOLE:int = 30;
    private var holeHeight:Array = new Array(MAX_HOLE);
    private var holePosition:Array = new Array(MAX_HOLE);
    private var holeSize:Array = new Array(MAX_HOLE);
    private var holeComboSize:Array = new Array(MAX_HOLE);
    private const HOLE_GAP:int = 100;
    private const COMBO_GAP:int = 15;
    private const MAX_COMBO:int = 15;
    private const BGM_CHANGE_COMBO:int = 5;

    private var gameState:int = GS_STOP;
    private const GS_STOP:int = 0;
    private const GS_PLAYING:int = 1;

    private var score:int = 0;
    private var highScore:int = 0;
    private var combo:int = 0;
    private var max_combo:int = 0;
    private var passed_hole:int = 0;

    private var title:Title = new Title();
    private var ending:Ending;

    public function Sentos() {
      addChild(new Bitmap(canvas));
      addChild(title);
      ending = new Ending(this);
      addChild(ending);
      addEventListener(Event.ADDED,onAdded);
      startButton.x = 140;
      startButton.y = 220;
      startButton.addEventListener(MouseEvent.CLICK,onStartClick);
      addChild(startButton);

      titleButton.x = 140;
      titleButton.y = 236;
      titleButton.addEventListener(MouseEvent.CLICK,onTitleClick);
      addChild(titleButton);

      SoundPlayer.init();
      SoundPlayer.playBGM(Const.BGM_TITLE);
      //title.hide();
      //missionComplete();
    }

    public function onAdded(e:Event):void{
      this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame); 
      this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
      this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
      this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
      this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
      showTitle();
    }

    public function showTitle():void{
      canvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      title.show();
      ending.hide();
      titleButton.visible = false;
      startButton.visible = true;
      SoundPlayer.playBGM(Const.BGM_TITLE);
    }

    private function init():void{
      if(combo>=BGM_CHANGE_COMBO){
        SoundPlayer.playBGM(Const.BGM_PLAYING);
      }
      canvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      score = 0;
      combo = 0;
      max_combo = 0;
      passed_hole = 0;
      drawText.draw("HIGH SCORE",0,0,Const.TYPE_HIGHSCORE,canvas);
      drawText.draw("COMBO",32,304,Const.TYPE_COMBO,canvas);
      drawText.draw("SCORE",104,304,Const.TYPE_SCORE,canvas);

      player.init();

      for(var i:int=0;i<MAX_HOLE;i++){
        holePosition[i] = Const.LINE_SIZE+(i+1)*HOLE_GAP-1;
        holeSize[i] = 50;
        holeComboSize[i] = COMBO_GAP - i/5;
        holeHeight[i] = int(Math.random()*(HEIGHT-holeSize[i]-2*MARGIN));
      }
    }

    private function onEnterFrame(eventObject:Event):void{
      if(GS_PLAYING == gameState){
        drawAll();
      }
    }

    private function onTimer():void{
      if(GS_PLAYING == gameState){
        drawAll();
      }
    }

    private function drawAll():void{
      canvas.fillRect(new Rectangle(0,MARGIN,WIDTH,HEIGHT-MARGIN*2),0x0);
      var s:Shape = new Shape();
      s.graphics.lineStyle(1,0X0000FF);
      s.graphics.moveTo(0,MARGIN);
      s.graphics.lineTo(WIDTH,MARGIN);
      s.graphics.moveTo(0,HEIGHT-MARGIN-1);
      s.graphics.lineTo(WIDTH,HEIGHT-MARGIN-1);
      canvas.draw(s);

      if(Const.LINE_SIZE < holePosition[MAX_HOLE-1]+1){
        player.draw(canvas,myMouseDown);
        var c:int = combo;
        if (c > MAX_COMBO){
          c = MAX_COMBO;
        }
        score = score + Math.pow(2,c);
        drawScore();
      }else if(Const.LINE_SIZE == holePosition[MAX_HOLE-1] +1){
        drawScore();
        SoundPlayer.playSound(Const.S_COMPLETE);
      }else{
        player.drawWithoutMove(canvas);
      }

      drawHoles();

      if(isDead()){
        drawText.drawCenter("MISSION FAILED",120,Const.TYPE_SCORE,canvas);
        SoundPlayer.playSound(Const.S_MISS);
        if(score>highScore){
          highScore = score;
          drawScore();
        } 
        gameState = GS_STOP;
        startButton.visible = true;
        titleButton.visible = true;
      }else if(holePosition[MAX_HOLE-1] < 0){
        missionComplete();
      }
    }

    private function missionComplete():void{
      canvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      var cb:int = Math.pow(10,(int)(max_combo/6)+2);
      score = score + cb;
      score = score + Const.MAX_COMBO_BONUS*max_combo;
      if(score>highScore){
        highScore = score;
      }

      ending.show(score,max_combo,cb);
      gameState = GS_STOP;
    }

    private function drawScore():void{
      drawText.draw("  ",8,304,Const.TYPE_COMBO,canvas);
      drawText.draw(combo.toString(),8,304,Const.TYPE_COMBO,canvas);
      drawText.draw(score.toString(),160,304,Const.TYPE_SCORE,canvas);
      drawText.draw(highScore.toString(),120,0,Const.TYPE_HIGHSCORE,canvas);
      drawText.draw(passed_hole.toString()+" / " + MAX_HOLE.toString(),256,0,Const.TYPE_SCORE,canvas);
    }

    private function isDead():Boolean{
      const mh:int = (int)(player.getPosition());
      if(MARGIN == mh) return true;
      if(HEIGHT-MARGIN == mh) return true;
      for(var i:int =0;i<MAX_HOLE;i++){
        if(Const.LINE_SIZE==holePosition[i]+1){
          if(mh < holeHeight[i]+MARGIN)return true;
          if(mh > holeHeight[i]+holeSize[i]+MARGIN)return true;
          //combo check
          passed_hole++;
          if(mh < holeHeight[i]+holeComboSize[i]+MARGIN ||
             mh > holeHeight[i]+holeSize[i] - holeComboSize[i]+MARGIN){
             combo++;
             if(combo == BGM_CHANGE_COMBO){
               SoundPlayer.playBGM(Const.BGM_COMBO);
             }
             if(combo > max_combo){
               max_combo = combo;
             }
             SoundPlayer.playSound(Const.S_COMBO);
          }else{
             SoundPlayer.playSound(Const.S_PASS);
            combo--;
            if(combo == BGM_CHANGE_COMBO-1){
               SoundPlayer.playBGM(Const.BGM_PLAYING);
            }
            if(combo<0){
              combo = 0;
            }
          }
          var c:int = combo;
          if (c > MAX_COMBO){
            c = MAX_COMBO;
          }
          score = score + Math.pow(2,c)*100; 
        }
      }
      return false;
    }

    private function drawHoles():void{
      var i:int = 0;
      for(i=0;i<MAX_HOLE;i++){
        holePosition[i]--; 
      }

      var s:Shape = new Shape();
      s.graphics.lineStyle(1,0X00FFFF);
      canvas.draw(s);
      for(i=0;i<MAX_HOLE;i++){
        s.graphics.moveTo(holePosition[i]*Const.RESOLUTION,MARGIN);
        s.graphics.lineTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]);
        s.graphics.moveTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]+holeSize[i]);
        s.graphics.lineTo(holePosition[i]*Const.RESOLUTION,HEIGHT-MARGIN);
      }
      canvas.draw(s);
      s.graphics.lineStyle(1,0XFFFF00);
      for(i=0;i<MAX_HOLE;i++){
        s.graphics.moveTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]);
        s.graphics.lineTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]+holeComboSize[i]);
        s.graphics.moveTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]+holeSize[i]-holeComboSize[i]);
        s.graphics.lineTo(holePosition[i]*Const.RESOLUTION,MARGIN+holeHeight[i]+holeSize[i]);
      }
      canvas.draw(s);
    }

    private function start():void{
      if(GS_STOP == gameState){
        init();
        SoundPlayer.playBGM(Const.BGM_PLAYING);
        gameState=GS_PLAYING;
        title.hide();
        ending.hide();
        hideButtons();
      }
    }

    private function onStartClick(e:MouseEvent):void{
      start();
    }

    private function onTitleClick(e:MouseEvent):void{
      showTitle();
    }

    private function onSubmitClick(e:MouseEvent):void{
      canvas.fillRect(new Rectangle(0,0,WIDTH,HEIGHT),0x0);
      title.hide();
      hideButtons();
      ending.hide();
    }

    public function onKeyDown(e:KeyboardEvent):void {
      if(Keyboard.SPACE!=e.keyCode)return;
      myMouseDown = true;
    }

    public function onKeyUp(e:KeyboardEvent):void {
      if(Keyboard.SPACE!=e.keyCode)return;
      myMouseDown = false;
    }


    private function onMouseDown(e:MouseEvent):void{
      myMouseDown = true;
    }

    private function onMouseUp(e:MouseEvent):void{
      myMouseDown = false;
    }

    public function showButtons():void{
      startButton.visible = true;
      titleButton.visible = true;
    }

    public function hideButtons():void{
      startButton.visible = false;
      titleButton.visible = false;
    }

  }
}
