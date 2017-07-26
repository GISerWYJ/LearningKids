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
    import feathers.controls.ProgressBar;
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
         * Constants
         */
        public static var PRE_IMAGE_BUTTON_STYLE = "preImageButtonStyle";

        public static var NEXT_IMAGE_BUTTON_STYLE = "nextImageButtonStyle";

        public static var START_GAME_BUTTON_STYLE = "startGameButtonStyle";

        public static var SETTING_BUTTON_STYLE = "settingButtonStyle";

        public static var CATEGORY_BUTTON_STYLE = "categoryButtonStyle";

        public static var RATE_BUTTON_STYLE = "rateButtonStyle";

        public static var SHARE_BUTTON_STYLE = "shareButtonStyle";

        public static var BACK_BUTTON_STYLE = "backButtonStyle";

        public static var TOGGLE_BUTTON_STYLE = "toggleButtonStyle";



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
            assets.enqueue(appDir.resolvePath("assets/textures/2x/gameui.png"));
            assets.enqueue(appDir.resolvePath("assets/textures/2x/gameui.xml"));

            //enqueue the font
            assets.enqueue(appDir.resolvePath("assets/fonts/font.png"));
            assets.enqueue(appDir.resolvePath("assets/fonts/font.fnt"));
            assets.enqueue(appDir.resolvePath("assets/textures/2x/progress_bg.png"));
            assets.enqueue(appDir.resolvePath("assets/textures/2x/progress_fill.png"));

            //assets.enqueue(appDir.resolvePath("assets/images/about_bg.png"));
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
            //Normal Button
            this.getStyleProviderForClass(Button).defaultStyleFunction = this.setGameButtonStyle;

            //startGame button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(START_GAME_BUTTON_STYLE,setStartGameButtonStyle);

            //settingGame Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(SETTING_BUTTON_STYLE,setSettingGameButtonStyle);

            //rate Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(RATE_BUTTON_STYLE,setRateButtonStyle);

            //rate Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(SHARE_BUTTON_STYLE,setShareButtonStyle);

            //category Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(CATEGORY_BUTTON_STYLE,setCategoryButtonStyle);

            //back Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(BACK_BUTTON_STYLE,setBackButtonStyle);

            //PreImage Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(PRE_IMAGE_BUTTON_STYLE,setPreImageButtonStyle);

            //NextImage Button
            this.getStyleProviderForClass(Button).setFunctionForStyleName(NEXT_IMAGE_BUTTON_STYLE,setNextImageButtonStyle);

            //ToggleButton
            this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setToggleButtonStyle;

            //Progressbar
            this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressbarStyle;
            
        }

        private function setGameButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("cute_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("cute_button_down"));
            skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;

        }

        private function setStartGameButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("start_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("start_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }



        private function setSettingGameButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("setting_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("setting_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }


        private function setRateButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("rate_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("rate_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }


        private function setShareButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("share_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("share_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }


        private function setBackButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("back_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("back_button_down"));

            button.defaultSkin = skin;
        }


        private function setCategoryButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("category_button_normal"));
            //skin.setTextureForState(ButtonState.DOWN, assets.getTexture("setting_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }

        private function setPreImageButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("preimage_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("cute_button_down"));
            //skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }

        private function setNextImageButtonStyle(button:Button):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("cute_button_normal"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("cute_button_down"));
            skin.scale9Grid= new Rectangle(40,20,83,10);
            button.defaultSkin = skin;
        }

        private function setProgressbarStyle(progressbar:ProgressBar):void
        {
            var backgroundSkin:Image = new Image(assets.getTexture("progress_bg"));
            backgroundSkin.scale9Grid = new Rectangle(8,0,240,32);
            progressbar.backgroundSkin = backgroundSkin;


            var fillSkin:Image = new Image(assets.getTexture("progress_fill"));
            fillSkin.scale9Grid = new Rectangle(8,0,184,21);
            //此处宽度用来当作进度条的最小宽度。
            fillSkin.width = 15;
            progressbar.fillSkin = fillSkin;
            
            progressbar.padding = 5;
        }

        private function setToggleButtonStyle(toggleButton:ToggleButton):void
        {
            var skin:ImageSkin = new ImageSkin(assets.getTexture("toggle_button_on"));
            skin.setTextureForState(ButtonState.DOWN, assets.getTexture("toggle_button_off"));
            skin.selectedTexture = assets.getTexture("toggle_button_off");
            toggleButton.defaultSkin = skin;
        }


        private function resizeHandler(event:ResizeEvent):void
        {
            this.primaryBackground.width = event.width;
            this.primaryBackground.height = event.height;
        }
    }
}
