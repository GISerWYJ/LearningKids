/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能: 初始化嵌入资源
 *版本：1.0
 **/
package assets
{
    import flash.media.Sound;

    import starling.core.Starling;
    import starling.textures.Texture;

    public class EmbeddedAssets
    {


        [Embed(source="/../assets/images/home_bg.png")]
        public static const home_bg1:Class;

//        [Embed(source="/../assets/images/logo.png")]
//        public static const HOME_LOGO_EMBEDDED:Class;
//
//
//        //Sound Assets
//        [Embed(source="/../assets/sounds/start_game.mp3")]
//        public static const SND_START_GAME_EMBEDDED:Class;
//
//        [Embed(source="/../assets/sounds/start_click.mp3")]
//        public static const SND_OPTION_GAME_EMBEDDED:Class;

//
//        public static var START_GAME:Texture;
//        public static var OPTIONS:Texture;
//        public static var ABOUT_GAME:Texture;
//        public static var HOME_BG:Texture;
//        public static var HOME_LOGO:Texture;
//
//        public static var SND_STATRT_GAME:Sound;
//        public static var SND_OPTION:Sound;

//        public static function initialize():void
//        {
//            //Images
//            START_GAME = Texture.fromEmbeddedAsset(START_GAME_EMBEDDED, false, false,1.5);
//            OPTIONS = Texture.fromEmbeddedAsset(OPTIONS_EMBEDDED, false, false, 1.5);
//            ABOUT_GAME = Texture.fromEmbeddedAsset(ABOUT_GAME_EMBEDDED, false, false, 1.5);
//            HOME_BG = Texture.fromEmbeddedAsset(HOME_BG_EMBEDDED,false,false,1.5);
//            HOME_LOGO = Texture.fromEmbeddedAsset(HOME_LOGO_EMBEDDED,false,false,1.5);
//           //Sounds
//            SND_STATRT_GAME = new SND_START_GAME_EMBEDDED() as Sound;
//            SND_OPTION = new SND_OPTION_GAME_EMBEDDED() as Sound;
//        }
    }
}
