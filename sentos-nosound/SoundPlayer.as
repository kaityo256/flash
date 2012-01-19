package {
  import flash.display.*;
  import flash.events.*;
  import flash.media.*;
  public class SoundPlayer {

    private static const DEFAULT_VOLUME:Number = 0.5;
    private static var bgms:Array = new Array();
    private static var sounds:Array = new Array();
    private static var currentBGM:int = 0;
    private static var nowPlayingBGM:Boolean = false;
    private static var channel:SoundChannel; 
    public static function init():void{
    }
    public static function stopBGM():void{
    }
    public static function playBGM(index:int):void{
    }
    public static function playSound(index:int):void{
    }
  }
}
