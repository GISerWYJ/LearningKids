/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package assets
{
    import flash.media.SoundChannel;

    import themes.GameTheme;

    public class GameSound
    {
        public static var bgSound:SoundChannel;

        public static var isPlayingWhenLeft:Boolean = false;

        public static function playBgSound():void
        {
            if (Main.settings.soundOn)
            {
                bgSound = GameTheme.assets.playSound("bg");
            }
        }

        public static function stopBgSound():void
        {
            bgSound.stop();
        }

        public static function playSoundEffect(name:String):void
        {
            if (Main.settings.effectOn)
            {
                GameTheme.assets.playSound(name);
            }
        }


    }
}
