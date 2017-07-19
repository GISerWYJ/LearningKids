/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package assets
{
    import flash.media.SoundChannel;

    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    public class Assets
    {
        public static var assetManager:AssetManager = new AssetManager(2);

        

        public static var bgSound:SoundChannel;

        public static var isBgSoundMute:Boolean = false;


    }
}
