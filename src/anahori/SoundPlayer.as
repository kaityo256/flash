package {
  import flash.display.*;
  import flash.events.*;
  import flash.media.*;
  public class SoundPlayer {
    [Embed(source='bgm01.mp3')]
    private static const bgm01:Class;
    [Embed(source='bgm02.mp3')]
    private static const bgm02:Class;
    [Embed(source='bgm03.mp3')]
    private static const bgm03:Class;
    [Embed(source='bgm04.mp3')]
    private static const bgm04:Class;

    [Embed(source='sound01.mp3')]
    private static const sound01:Class;
    [Embed(source='sound02.mp3')]
    private static const sound02:Class;
    [Embed(source='sound03.mp3')]
    private static const sound03:Class;
    [Embed(source='sound04.mp3')]
    private static const sound04:Class;
    private static var bgms:Array = new Array();
    private static var sounds:Array = new Array();
    public static var currentBGM:int = 0;
    public static var nowPlayingBGM:Boolean = false;
    public static var channel:SoundChannel; 
    public static function init():void{
      bgms.push(new bgm01());
      bgms.push(new bgm02());
      bgms.push(new bgm03());
      bgms.push(new bgm04());
      sounds.push(new sound01());
      sounds.push(new sound02());
      sounds.push(new sound03());
      sounds.push(new sound04());
    }
    public static function stopBGM():void{
      if(nowPlayingBGM){
        channel.stop();
      }
      nowPlayingBGM = false;
    }
    public static function playBGM(index:int):void{
      if(nowPlayingBGM && index == currentBGM){
        return;
      }
      stopBGM();
      currentBGM=index;
      nowPlayingBGM = true;
      channel = bgms[index].play(0,256);
    }
    public static function playSound(index:int):void{
      sounds[index].play(0,0);
    }
  }
}
