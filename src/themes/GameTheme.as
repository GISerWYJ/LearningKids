/**
 *作者：汪裕峻
 *日期：2017-07-18.
 *功能:
 *版本：1.0
 **/
package themes
{
    import feathers.controls.Button;
    import feathers.controls.ButtonState;
    import feathers.controls.ToggleButton;
    import feathers.controls.text.BitmapFontTextRenderer;
    import feathers.core.FeathersControl;
    import feathers.core.ITextRenderer;
    import feathers.skins.ImageSkin;
    import feathers.text.BitmapFontTextFormat;
    import feathers.themes.StyleNameFunctionTheme;

    import flash.filesystem.File;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.textures.Texture;
   
    import starling.utils.AssetManager;

    public class GameTheme extends StyleNameFunctionTheme
    {
        /**
         * 一些嵌入的资源，直接打包进入app内部
         */
        [Embed(source="/../assets/images/home_bg.png")]
        public static const home_bg_embedded:Class;
        
        
        public static var assets:AssetManager;

        /**
         * app初始背景
         */
        private var primaryBackground:Image;

        public function GameTheme()
        {
            super();
            //初始化背景，使得程序启动界面之后就出现此背景
            initializeStage();
            loadAssets();
        }

        override public function dispose():void
        {
            if (this.primaryBackground)
            {
                Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, resizeHandler);
                Starling.current.stage.removeChild(this.primaryBackground, true);
                this.primaryBackground = null;
            }
          
            super.dispose();
        }

        protected function assetManager_onProgress(ratio:Number):void
        {
            if (ratio < 1)
            {
                return;
            }


            this.initilize();
            this.dispatchEventWith(Event.COMPLETE);
        }

        protected function initializeStage():void
        {
           
            this.primaryBackground = new Image(Texture.fromEmbeddedAsset(home_bg_embedded));
            this.primaryBackground.width = Starling.current.stage.stageWidth;
            this.primaryBackground.height = Starling.current.stage.stageHeight;
            Starling.current.stage.addEventListener(ResizeEvent.RESIZE, resizeHandler);
            Starling.current.stage.addChildAt(this.primaryBackground, 0);
        }

        /**
         * 初始化全局设置
         */
        private function initilize():void
        {
            initilizeGlobals();
            initiliazeStyleProviders();
        }

        /**
         * 加载资源
         */
        private function loadAssets():void
        {
            assets = new AssetManager(2);
            var appDir:File = File.applicationDirectory;

            //enqueue the sound
            //assets.enqueue(appDir.resolvePath("assets/sounds"));
            //enqueue the atlas
            assets.enqueue(appDir.resolvePath("assets/textures/2x/atlas.png"));
            assets.enqueue(appDir.resolvePath("assets/textures/2x/atlas.xml"));
           
            //enqueue the font
            assets.enqueue(appDir.resolvePath("assets/fonts/font.png"));
            assets.enqueue(appDir.resolvePath("assets/fonts/font.fnt"));
            //monitor the loading process
            assets.loadQueue(assetManager_onProgress);
        }

        private function initilizeGlobals():void
        {
            FeathersControl.defaultTextRendererFactory = function ():ITextRenderer
            {
                var bitmapFontTextRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
                bitmapFontTextRenderer.textFormat = new BitmapFontTextFormat("font", 25);
                return bitmapFontTextRenderer;
            }
        }

        /**
         * 初始化控件的StyleProvider
         */
        private function initiliazeStyleProviders():void
        {
            //Button
            this.getStyleProviderForClass(Button).defaultStyleFunction = this.setGameButtonStyle;

            //ToggleButton
            this.getStyleProviderForClass(Button).setFunctionForStyleName("music_button_style", this.setMusicButtonStyle);
            
        }

        private function setGameButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("cute_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("cute_button_down"));
            //skin.scale9Grid = new Rectangle(68, 20, 9, 2);
            skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }

        private function setMusicButtonStyle(toggleButton:ToggleButton):void
        {
            var musicButtonSkin:ImageSkin = new ImageSkin(assets.getTexture("music_on"));
            musicButtonSkin.setTextureForState(ButtonState.DOWN, assets.getTexture("music_off"));
            musicButtonSkin.selectedTexture = assets.getTexture("music_off");
            toggleButton.defaultSkin = musicButtonSkin;
        }


        private function resizeHandler(event:ResizeEvent):void
        {
            this.primaryBackground.width = event.width;
            this.primaryBackground.height = event.height;
        }
    }
}
