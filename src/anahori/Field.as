package{
  import flash.text.*;
  import flash.display.*;
  import flash.utils.*;
  public class Field{
    private var data:Array = new Array(Const.SX*Const.SY);
    private var stageStr:String = new String();
    private var drawer:Drawer;
    private var stageData:Array = new Array();

    public function Field(d:Drawer){
      drawer = d;
      for(var i:int;i<Const.SX*Const.SY;i++){
        data[i] = Const.T_NULL;
      }
      loadAll();
    }

    public function getLastStage():int{
      return 18;
    }

    private function setStageData(ix:int, iy:int, value:int): void{
      var index:int = ix + iy * Const.SX;
      data[index] = value;
    }

    public function getStageData(ix:int, iy:int): int{
      var index:int = ix + iy * Const.SX;
      return data[index];
    }

    public function draw():void {
     for(var iy:int =0; iy < Const.SY; iy++){
        for(var ix:int =0; ix < Const.SX; ix++){
          drawer.drawChar(ix,iy,getStageData(ix,iy));
        }
      }
    }

    public function load(index:int):void {
      var str:String = stageData[index];
      var a:Array = str.split(/\,/);
      for(var i:int;i<Const.SX*Const.SY;i++){
        data[i] = parseInt(a[i]);
      }
    }

    public function canPush(ix:int, iy:int,dir:int):Boolean{
      switch(dir){
        case Const.D_LEFT:
          if(ix<2) {return false;}
          if(Const.T_STONE != getStageData(ix-1,iy)){return false;}
          if(Const.T_NULL != getStageData(ix-2,iy)){return false;}
          return true;
        break;

        case Const.D_RIGHT:
          if(ix>Const.SX-3) {return false;}
          if(Const.T_STONE != getStageData(ix+1,iy)){return false;}
          if(Const.T_NULL != getStageData(ix+2,iy)){return false;}
          return true;
        break;
      }
      return false;
    }

    public function drawFallDeath():void {
      drawer.drawEvent(Const.E_RAKUSHI);
    }
    private function drawDeath(ix:int , iy:int):void {
      switch(getStageData(ix,iy)){
        case Const.T_STONE:
          drawer.drawEvent(Const.E_ASSHI);
        break;
        case Const.T_TUTI:
          drawer.drawEvent(Const.E_MAISHI);
        break;
        case Const.T_LADDER:
          drawer.drawEvent(Const.E_SASHISHI);
        break;
      }
    }

    public function push(ix:int, iy:int,dir:int):Boolean{
      switch(dir){
        case Const.D_LEFT:
          setStageData(ix-1,iy,Const.T_NULL);
          setStageData(ix-2,iy,Const.T_STONE);
          fall(ix-2);
          if(fall(ix-1)){
            draw();
            drawDeath(ix-1,iy);
            return true;
          }
        break;

        case Const.D_RIGHT:
          setStageData(ix+1,iy,Const.T_NULL);
          setStageData(ix+2,iy,Const.T_STONE);
          fall(ix+2);
          if(fall(ix+1)){
            draw();
            drawDeath(ix+1,iy);
            return true;
          }
        break;
      }
      draw();
      return false;
    }

    public function canMove(ix:int, iy:int,dir:int):Boolean{
      switch(dir){
        case Const.D_LEFT:
          if(0 == ix) {return false;}
          if(Const.T_NULL == getStageData(ix-1,iy)){return true;}
          if(Const.T_LADDER == getStageData(ix-1,iy)){return true;}
          if(Const.T_LOVE == getStageData(ix-1,iy)){return true;}
        break;
        case Const.D_RIGHT:
          if(Const.SX-1 == ix) {return false;}
          if(Const.T_NULL == getStageData(ix+1,iy)){return true;}
          if(Const.T_LADDER == getStageData(ix+1,iy)){return true;}
          if(Const.T_LOVE == getStageData(ix+1,iy)){return true;}
        break;
        case Const.D_UP:
          if(0 == iy) {return false;}
          if(Const.T_LADDER != getStageData(ix,iy)) {return false;}
          if(Const.T_NULL == getStageData(ix,iy-1) ){return true;}
          if(Const.T_LADDER == getStageData(ix,iy-1)){return true;}
          if(Const.T_LOVE == getStageData(ix,iy-1)){return true;}
        break;
        case Const.D_DOWN:
          if(Const.SY-1 == iy) {return false;}
          if(Const.T_STONE == getStageData(ix,iy+1)) {return false;}
          if(Const.T_TUTI == getStageData(ix,iy+1)) {return false;}
          return true;
        break;
      }
      return false;
    }

    public function wait(count:uint ):void{
      var start:uint = getTimer();
      while(getTimer() - start < count){
      }
    }

    public function clearCheck(ix:int, iy:int): Boolean {
      if (Const.T_LOVE == getStageData(ix,iy)){
        return true;
      }else{
        return false;
      }
    }

    private function fall(line:int): Boolean {
      if(fallStone(line)){
        SoundPlayer.playSound(Const.S_FALL);
        return true; 
      }else if(fallLadder(line)){
        return true; 
      }
      return false;
    }

    private function fallStone(line:int): Boolean {
      var stonePos:int = Const.SY;
      for(var i:int=0;i<Const.SY;i++){
        if(Const.T_STONE == getStageData(line, i)){
          stonePos = i;
          break;
        }
      }
      if(Const.SY == stonePos){
        return false;
      }

      var nullNum:int = 0;
      var moveNum:Array = new Array(Const.SY);

      for(var k:int=0;k<Const.SY;k++){
        moveNum[k] = 0;
      }
      for(var j:int = Const.SY-1;j >=0;j--){
        if(j < stonePos && Const.T_LADDER != getStageData(line,j)){
          break;
        }
        moveNum[j] = nullNum;
        if(Const.T_NULL == getStageData(line, j)){
          nullNum++;
        }
      }
      if(0 == nullNum){
        return false;
      }

      for(var i2:int = Const.SY-1;i2 >=0;i2--){
        if(0 == moveNum[i2]){
          continue;
        }
        var value:int = getStageData(line,i2);
        setStageData(line,i2+moveNum[i2],value);
        setStageData(line,i2,Const.T_NULL);
      }
      return true;
    }

    public function fallLadder(line:int):Boolean {
      var nullNum:int = 0;
      var moveNum:Array = new Array(Const.SY);
      for(var i2:int; i2<Const.SY;i2++){
        moveNum[i2] = 0;
      }

      for(var j:int = Const.SY-1;j >=0;j--){
        if(Const.T_NULL == getStageData(line, j)){
          nullNum++;
        }else if (Const.T_LADDER != getStageData(line, j)){
          nullNum = 0;
        }
        moveNum[j] = nullNum;
      }
      var fallFlag:Boolean = false;
      for(var i:int = Const.SY-1;i >=0;i--){
        if(0 == moveNum[i]){
          continue;
        }
        if(Const.T_NULL == getStageData(line,i)){
          continue;
        }
        fallFlag = true;
        var value:int = getStageData(line,i);
        setStageData(line,i+moveNum[i],value);
        setStageData(line,i,Const.T_NULL);
      }
      return fallFlag;
    }

    public function digAnimation(ix:int, iy:int ,dir:int, count:int):void{
      var r_right:Array = new Array(11,12,13,14);
      var r_left:Array = new Array(16,17,18,19);
      if(Const.D_LEFT == dir){
        drawer.drawChar(ix-1,iy,r_left[count]);
      }else{
        drawer.drawChar(ix+1,iy,r_right[count]);
      }
    }

    public function canDig(ix:int, iy:int ,dir:int):Boolean{
      if(Const.D_LEFT == dir){
        if (0 == ix){return false;}
        if (Const.T_TUTI != getStageData(ix-1,iy)){return false;}
      }else{
        if (Const.SX - 1 == ix){return false;}
        if (Const.T_TUTI != getStageData(ix+1,iy)){return false;}
      }
      return true;
    }

    public function dig(ix:int, iy:int ,dir:int):void{
      if(Const.D_LEFT == dir){
        if (0 == ix){return;}
        if (Const.T_TUTI != getStageData(ix-1,iy)){return;}
        setStageData(ix-1,iy,Const.T_NULL);
        if(fall(ix-1)){
        }
        draw();
      }else{
        if (Const.SX - 1 == ix){return;}
        if (Const.T_TUTI != getStageData(ix+1,iy)){return;}
        setStageData(ix+1,iy,Const.T_NULL);
        if(fall(ix+1)){
        }
        draw();
      }
    }

    private function loadAll():void {
      stageData.push("1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,3,1,3,1,1,1,1,0,1,1,3,1,3,1,1,1,1,0,1,1,3,1,3,1,1,1,1,2,1,0,3,1,3,1,1,1,1,2,0,0,3,1,3,1,1,1,1,3,0,1,3,1,3,1,1,1,1,1,0,1,3,1,3,1,1,1,1,2,0,1,3,0,3,1,1,1,1,2,0,1,3,");
      stageData.push("1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,1,3,1,3,1,1,1,1,1,1,1,3,1,3,1,1,1,2,0,1,1,3,1,3,1,1,1,2,0,0,1,3,1,3,1,1,1,2,1,0,1,3,1,3,1,2,1,2,1,0,1,3,1,3,1,1,0,2,1,1,1,3,1,3,1,2,0,1,1,1,1,3,0,3,1,1,0,1,1,1,1,1,");
      stageData.push("1,1,1,1,1,1,2,2,0,4,1,3,1,2,1,1,3,3,0,3,1,3,1,2,0,3,1,3,0,3,1,3,1,2,2,1,3,1,0,3,1,3,1,3,2,3,3,1,0,3,1,3,1,3,1,3,1,2,0,3,1,3,1,3,3,3,1,2,0,3,1,3,2,2,3,2,3,2,0,3,1,3,2,2,3,2,3,2,0,3,0,3,2,1,3,3,1,1,0,3,");
      stageData.push("1,1,1,1,1,1,1,1,1,4,1,3,1,1,1,1,1,0,0,3,1,3,1,1,1,1,1,0,0,3,1,3,1,1,1,1,1,0,0,3,1,3,1,1,1,1,1,0,0,3,1,3,2,3,1,1,1,0,0,3,1,3,3,3,1,1,2,0,0,3,1,3,3,1,2,1,2,0,0,3,1,3,1,1,2,1,2,0,0,3,0,3,1,1,1,1,1,0,0,1,");
      stageData.push("1,0,0,0,0,0,0,0,0,4,1,0,0,0,0,0,0,0,0,3,1,0,0,0,0,0,0,0,0,3,1,3,0,0,0,0,0,0,0,3,1,3,1,1,1,1,1,1,0,3,1,3,1,1,2,0,1,1,0,3,1,3,1,1,2,0,1,1,1,3,1,3,1,1,1,0,1,0,1,3,1,3,1,1,1,0,1,0,1,3,0,3,1,1,1,0,1,0,1,3,");
      stageData.push("1,1,1,1,1,1,1,1,1,4,1,1,3,3,2,3,2,3,0,3,1,1,3,3,1,3,2,3,0,3,1,1,3,1,2,3,3,2,0,3,1,1,2,2,2,2,2,1,0,3,1,2,3,3,3,1,3,1,0,3,1,2,1,3,2,3,3,2,0,3,1,3,3,3,3,3,1,2,0,3,1,3,1,3,3,1,1,2,0,3,0,3,2,2,1,1,3,1,0,3,");
      stageData.push("1,1,1,1,1,1,1,1,1,4,1,1,0,0,1,1,1,1,1,3,1,3,2,0,0,1,1,1,1,3,1,3,1,0,0,0,1,1,1,3,1,3,1,2,0,0,0,1,1,3,1,3,1,1,0,0,0,0,1,3,1,3,1,1,2,0,0,0,0,3,1,3,1,1,1,2,0,2,0,3,1,3,1,1,1,1,0,1,0,3,0,3,1,1,1,1,1,1,1,1,");
      stageData.push("0,2,3,2,3,0,3,0,0,4,3,2,2,2,2,0,2,2,0,3,3,3,1,1,3,3,3,2,0,3,3,3,3,3,3,1,1,2,0,3,3,1,1,2,3,2,2,2,0,3,1,3,2,1,1,3,1,3,0,3,1,3,1,3,1,2,3,2,0,2,1,3,3,3,3,1,3,3,0,2,1,3,1,3,2,1,3,3,0,2,0,3,1,1,2,3,1,3,2,2,");
      stageData.push("1,2,1,1,3,1,0,1,1,4,1,2,1,1,3,1,0,1,1,3,3,3,2,1,3,1,0,2,1,3,3,1,1,0,3,2,0,2,1,3,3,3,2,0,3,2,1,2,1,3,3,1,1,0,2,3,3,1,1,3,3,2,3,2,3,2,2,2,1,3,1,1,3,3,1,2,3,3,2,3,1,3,3,3,3,2,3,1,2,3,0,1,3,1,3,1,3,3,2,1,");
      stageData.push("1,2,1,1,3,1,0,1,1,4,1,2,1,1,3,1,0,1,1,3,3,3,2,1,3,1,0,2,1,3,3,1,1,0,3,2,0,2,1,3,3,3,2,0,3,1,1,2,1,3,3,1,1,0,2,3,3,1,1,3,3,2,3,2,3,2,2,2,1,3,1,1,3,2,3,2,3,3,2,3,1,3,3,3,3,2,3,1,2,3,0,1,3,1,3,1,3,3,2,1,");
      stageData.push("3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,1,1,1,1,3,3,0,0,0,0,0,0,0,0,3,3,0,0,2,0,2,1,1,1,3,3,0,0,3,2,2,1,3,2,3,3,0,1,2,4,2,3,1,2,3,3,0,2,1,2,3,1,3,2,3,3,0,1,1,3,1,1,1,3,3,1,3,1,3,1,1,1,1,2,3,0,3,3,1,2,1,1,1,2,3,");
      stageData.push("1,1,3,1,1,1,3,3,3,3,1,3,3,1,1,3,1,1,1,3,1,3,1,1,1,3,0,2,1,3,1,3,1,1,1,3,0,2,1,3,1,3,2,1,1,3,0,2,1,3,1,3,2,0,1,3,0,2,1,3,1,3,2,0,1,3,0,2,1,3,1,3,2,0,1,1,0,2,1,3,1,3,2,0,1,1,0,2,1,3,0,3,2,0,1,4,0,2,1,3,");
      stageData.push("3,1,1,1,1,1,1,1,1,0,3,1,1,3,1,2,1,1,1,3,3,1,1,3,2,2,2,3,1,3,3,1,1,3,2,2,2,3,1,3,3,3,1,3,2,4,1,1,1,3,3,3,2,2,2,2,2,2,1,3,3,2,1,1,3,3,3,3,1,3,3,3,3,3,1,2,2,3,1,3,1,3,3,3,3,3,3,3,1,3,0,3,1,1,1,1,1,1,1,3,");
      stageData.push("1,1,1,1,3,1,2,2,2,3,1,3,1,1,3,1,2,2,2,3,1,3,1,2,3,1,2,1,2,3,1,3,0,1,3,1,1,4,1,3,1,3,1,2,1,1,2,1,2,3,1,3,0,1,0,1,3,2,3,3,1,3,1,3,2,1,3,3,3,3,1,3,3,2,1,3,1,1,1,3,1,3,1,3,1,1,2,3,2,1,0,3,1,2,1,1,1,3,1,3,");
      stageData.push("3,1,1,1,1,1,1,1,1,3,3,1,1,1,1,1,1,1,1,3,3,1,1,1,1,1,2,1,1,3,3,2,1,2,3,1,1,1,1,3,3,1,1,2,3,1,1,1,1,1,3,2,1,2,3,1,2,1,1,3,3,1,2,1,2,1,1,1,2,3,3,1,1,1,3,1,1,2,1,3,3,3,1,3,1,3,3,1,3,1,0,3,1,1,1,1,2,1,3,4,");
      stageData.push("1,3,1,1,1,1,1,1,1,3,1,3,1,1,1,2,2,1,1,3,1,3,1,2,2,4,2,1,1,3,1,3,1,1,2,2,2,2,1,3,1,3,1,3,1,2,1,2,1,3,1,3,1,1,3,1,1,1,1,3,1,3,1,1,2,1,3,1,3,3,1,3,1,1,2,1,3,1,3,1,1,3,1,1,2,1,1,1,3,1,0,3,1,1,2,1,1,1,1,1,");
      stageData.push("3,2,1,1,1,1,1,1,1,3,3,1,2,1,1,1,1,2,1,3,3,1,2,2,1,3,2,3,2,3,3,1,2,1,2,1,1,1,1,3,3,2,1,2,4,2,1,2,1,3,3,1,2,3,2,2,3,1,2,3,3,1,3,2,1,1,2,3,1,3,3,3,1,1,3,2,3,1,2,3,1,3,1,2,1,1,1,1,1,3,0,3,3,3,3,3,3,3,3,3,");
      stageData.push("3,2,2,2,1,3,3,2,1,2,3,2,3,3,2,2,1,3,2,4,3,3,2,3,3,2,2,2,2,2,3,2,2,3,2,2,3,3,3,1,3,1,2,2,1,3,2,3,2,1,3,2,1,1,3,2,3,1,3,1,3,1,3,3,3,1,3,1,1,2,3,3,1,3,1,3,1,1,2,2,1,3,1,1,3,3,3,3,1,1,0,3,1,3,3,1,1,1,1,1,");
      }
  }
}
