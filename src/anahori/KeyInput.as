package {

  import flash.events.*;
  import flash.ui.*;

  public class KeyInput {
    private var key_left:Boolean = false;
    private var key_right:Boolean = false;
    private var key_up:Boolean = false;
    private var key_down:Boolean = false;
    private var key_space:Boolean = false;
    private var key_escape:Boolean = false;

    private var lastKey:int = 0;
    public var callback:Function;
    private var movedOnDown:Boolean = false;
 
    public function moved():Boolean{
      if(movedOnDown){
        lastKey = 0;
        movedOnDown = false;
        return true;
      }else{
        return false;
      }
    }

    public function getLastKey():int {
 
      if(0 != lastKey){
        var k:int =lastKey;
        lastKey = 0;
        return k;
      }else{
        if(key_left) return Keyboard.LEFT;
        if(key_right) return Keyboard.RIGHT;
        if(key_up) return Keyboard.UP;
        if(key_down) return Keyboard.DOWN;
      }
      return 0;
    }

    public function onKeyDown(e:KeyboardEvent):void {
      switch (e.keyCode){
         case Keyboard.LEFT:
           if(key_left)return;
           key_left = true;
           lastKey = e.keyCode;
         break;
         case Keyboard.RIGHT:
           if(key_right)return;
           key_right = true;
         break;
         case Keyboard.UP:
           if(key_up)return;
           key_up = true;
         break;
         case Keyboard.DOWN:
           if(key_down)return;
           key_down = true;
         break;
         case Keyboard.SPACE:
           if(key_space)return;
           key_space = true;
         break;
         case Keyboard.ESCAPE:
           lastKey = e.keyCode;
         break;
      }
      movedOnDown = true;
      callback(e.keyCode);
    }

    public function onKeyUp(e:KeyboardEvent):void {
      switch (e.keyCode){
         case Keyboard.LEFT:
           key_left = false;
         break;
         case Keyboard.RIGHT:
           key_right = false;
         break;
         case Keyboard.UP:
           key_up = false;
         break;
         case Keyboard.DOWN:
           key_down = false;
         break;
         case Keyboard.SPACE:
           key_space = false;
         break;
      }
    }
  }
}
