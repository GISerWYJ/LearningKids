/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能:
 *版本：1.0
 **/
package screens
{
    import assets.Assets;

    import feathers.controls.Button;
    import feathers.controls.ButtonState;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Screen;
    import feathers.controls.ToggleButton;
    import feathers.controls.text.BitmapFontTextRenderer;
    import feathers.core.ITextRenderer;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feathers.skins.ImageSkin;

    import flash.geom.Rectangle;

    import starling.animation.Juggler;
    import starling.animation.Tween;
    import starling.display.Image;
    import starling.events.Event;

    import themes.GameTheme;

    public class HomeScreen extends Screen
    {
        var stopLocation:Number = 0;
        private var logo:Image;
        private var juggler:Juggler;
        private var clouds:Image;
        private var label:Label;


        public function HomeScreen()
        {
            super();
            juggler = new Juggler();
        }

        override protected function initialize():void
        {
            super.initialize();
            //布局
            this.layout = new AnchorLayout();
            //添加主页UI元素
            createUI();
            //播放背景音乐，先停掉已有的音乐
//            if (Assets.bgSound)
//            {
//                if (!Assets.isBgSoundMute)
//                {
//                    Assets.bgSound.stop();
//                    Assets.bgSound = GameTheme.assets.getSound("bg").play();
//                }
//
//            }
//            else
//            {
//                Assets.bgSound = Assets.assetManager.getSound("bg").play();
//            }


            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            trace("initilized");


            var yoyoTween:Tween = new Tween(logo, 1);
            yoyoTween.moveTo((stage.width - logo.width) / 2, 30);
            yoyoTween.repeatCount = 0;
            yoyoTween.reverse = true;

            var showLogoTween:Tween = new Tween(logo, 1);
            showLogoTween.moveTo((stage.width - logo.width) / 2, 20);
            showLogoTween.fadeTo(1);
            showLogoTween.nextTween = yoyoTween;
            juggler.add(showLogoTween);

            var cloudsTween:Tween = new Tween(clouds, 1);
            cloudsTween.moveTo(20, 40);
            cloudsTween.repeatCount = 0;
            cloudsTween.reverse = true;
            juggler.add(cloudsTween);
        }

        override public function dispose():void
        {
            super.dispose();
            trace("disopsed");
            //移除事件监听
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            //释放资源
            logo.dispose();
        }

        public function advanceTime(passedTime:Number):void
        {
            juggler.advanceTime(passedTime);
        }

        private function createUI():void
        {
            //添加背景
            this.backgroundSkin = new ImageSkin(GameTheme.assets.getTexture("home_bg"));

            //添加云彩
            clouds = new Image(GameTheme.assets.getTexture("clouds"));
            clouds.x = 20;
            clouds.y = 20;
            addChild(clouds);
            //添加Logo
            logo = new Image(GameTheme.assets.getTexture("logo"));
            logo.x = -200;
            logo.y = 20;
            logo.alpha = 0;
            addChild(logo);
            //添加声音控制按钮
            var soundButtonGroup:LayoutGroup = new LayoutGroup();
            var soundButtonGroupLayout:HorizontalLayout = new HorizontalLayout();
            soundButtonGroupLayout.gap = 10;
            soundButtonGroup.layout = soundButtonGroupLayout;
            soundButtonGroup.layoutData = new AnchorLayoutData(5, 5);
            var musicButton:ToggleButton = new ToggleButton();
            musicButton.styleNameList.add("music_button_style");
           // musicButton.addEventListener(Event.CHANGE, musicButton_changeHandler);

            var soundButton:ToggleButton = new ToggleButton();
            var soundButtonSkin:ImageSkin = new ImageSkin(GameTheme.assets.getTexture("sounds_on"));
            soundButtonSkin.setTextureForState(ButtonState.DOWN, GameTheme.assets.getTexture("sounds_off"));
            soundButtonSkin.selectedTexture = GameTheme.assets.getTexture("sounds_off");
            soundButton.defaultSkin = soundButtonSkin;
            soundButton.defaultSelectedSkin = soundButtonSkin;
            //soundButton.addEventListener(Event.TRIGGERED, soundButton_triggeredHandler);

            soundButtonGroup.addChild(musicButton);
            soundButtonGroup.addChild(soundButton);

            addChild(soundButtonGroup);

            //添加按钮组
            var buttonGroup:LayoutGroup = new LayoutGroup();
            var vLayout:VerticalLayout = new VerticalLayout();
            vLayout.gap = 20;
            buttonGroup.layout = vLayout;
            buttonGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
            addChild(buttonGroup);
            //开始按钮
            var startButton:Button = new Button();
            startButton.label = "开始";
            startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
            buttonGroup.addChild(startButton);

            //关于按钮
            var aboutButton:Button = new Button();
            aboutButton.label = "关于";
            aboutButton.addEventListener(Event.TRIGGERED, aboutButton_triggeredHandler);
            buttonGroup.addChild(aboutButton);

        }

        private function enterFrameHandler(event:Event, passedTime:Number):void
        {
            advanceTime(passedTime);

        }

        private function startButton_triggeredHandler(event:Event):void
        {
            GameTheme.assets.playSound("start_game");
            //Assets.bgSound.stop();
            dispatchEventWith("game");
        }

        private function aboutButton_triggeredHandler(event:Event):void
        {
           // GameTheme.assets.playSound("start_game");
            dispatchEventWith("about");

        }


        private function soundButton_triggeredHandler(event:Event):void
        {

        }

        private function musicButton_changeHandler(event:Event):void
        {
            var musicButton:ToggleButton = event.currentTarget as ToggleButton;

            trace(musicButton.isSelected);
            if (musicButton.isSelected)
            {
                stopLocation = Assets.bgSound.position;
                Assets.bgSound.stop();
                Assets.isBgSoundMute = true;
            }
            else
            {
                Assets.bgSound = GameTheme.assets.getSound("bg").play(stopLocation);
                Assets.isBgSoundMute = false;
            }
        }
    }
}
