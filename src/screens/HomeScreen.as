/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能:
 *版本：1.0
 **/
package screens
{
    import assets.GameSound;

    import com.freshplanet.ane.AirImagePicker.AirImagePicker;
    import com.freshplanet.ane.AirImagePicker.AirImagePickerImageData;
    import com.freshplanet.ane.AirImagePicker.events.AirImagePickerDataEvent;
    import com.freshplanet.ane.AirImagePicker.events.AirImagePickerRecentImagesEvent;
    import com.sbhave.nativeExtensions.zbar.Config;
    import com.sbhave.nativeExtensions.zbar.Scanner;
    import com.sbhave.nativeExtensions.zbar.ScannerEvent;
    import com.sbhave.nativeExtensions.zbar.Symbology;

    import feathers.controls.Alert;
    import feathers.controls.Button;
    import feathers.controls.ImageLoader;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Screen;
    import feathers.controls.ToggleButton;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feathers.skins.ImageSkin;

    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.PNGEncoderOptions;
    import flash.events.ErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Matrix;
    import flash.media.CameraUI;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;

    import starling.animation.Juggler;
    import starling.animation.Tween;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.events.Event;
    import starling.textures.Texture;

    import themes.GameTheme;

    public class HomeScreen extends Screen
    {
        var stopLocation:Number = 0;
        private var logo:Image;
        private var juggler:Juggler;
        private var clouds:Image;
        private var walkerMovie:MovieClip;
        private var camera:CameraUI;
        private var loader:Loader;
        private var img:ImageLoader;
        private var dataSource:IDataInput;
        private var ctr:Number = 0;
        private var scanner:Scanner;

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

            if (CameraUI.isSupported)
            {
                camera = new CameraUI();
            }

            scanner = new Scanner();
        }

        override public function dispose():void
        {
            super.dispose();
            trace("disopsed");
            //移除事件监听
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            //释放资源
            logo.dispose();
            scanner.dispose();
            scanner = null;
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

            //添加按钮组
            var buttonGroup:LayoutGroup = new LayoutGroup();
            var vLayout:VerticalLayout = new VerticalLayout();
            vLayout.gap = 20;
            buttonGroup.layout = vLayout;
            buttonGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
            addChild(buttonGroup);
            //开始按钮
            var startButton:Button = new Button();
            startButton.styleNameList.add(GameTheme.START_GAME_BUTTON_STYLE);
            startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
            buttonGroup.addChild(startButton);

            //设置按钮
            var settingButton:Button = new Button();
            settingButton.styleNameList.add(GameTheme.SETTING_BUTTON_STYLE);
            settingButton.addEventListener(Event.TRIGGERED, aboutButton_triggeredHandler);
            buttonGroup.addChild(settingButton);

            //底部按钮组
            var bottomButtonGroup:LayoutGroup = new LayoutGroup();
            var hLayout:HorizontalLayout = new HorizontalLayout();
            hLayout.gap = 10;
            bottomButtonGroup.layout = hLayout;
            bottomButtonGroup.layoutData = new AnchorLayoutData(NaN, NaN, 5, NaN, 0, NaN);
            addChild(bottomButtonGroup);

            var rateButton:Button = new Button();
            rateButton.styleNameList.add(GameTheme.RATE_BUTTON_STYLE);
            bottomButtonGroup.addChild(rateButton);
            rateButton.addEventListener(Event.TRIGGERED, rateButton_triggeredHandler);

            var shareButton:Button = new Button();
            shareButton.styleNameList.add(GameTheme.SHARE_BUTTON_STYLE);
            shareButton.addEventListener(Event.TRIGGERED, shareButton_triggeredHandler);
            bottomButtonGroup.addChild(shareButton);


            var walkerFrames:Vector.<Texture> = GameTheme.assets.getTextures("walker");
            walkerMovie = new MovieClip(walkerFrames, 10);
            walkerMovie.x = 50;
            walkerMovie.y = 50;
            walkerMovie.pivotX = walkerMovie.width / 2;

            addChild(walkerMovie);
            juggler.add(walkerMovie);
            walkerMovie.stop();

            img = new ImageLoader();
            img.width = 300;
            img.height = 220;
            addChild(img);
        }

        private function enterFrameHandler(event:Event, passedTime:Number):void
        {
            advanceTime(passedTime);

        }

        private function scaleBMD(originalBitmapData:BitmapData, mode:String):BitmapData
        {
            var contentWidth:Number = originalBitmapData.width;
            var contentHeight:Number = originalBitmapData.height;

            var targetWidth:Number = 0;
            var targetHeight:Number = 0;

            if (mode == "thumbnail")
            {
                //If we want a thumbnail we hardcode its size to be 100x100px
                targetWidth = 100;
                targetHeight = 100;
            }
            else if (mode == "scale")
            {
                //Textures larger than 2048px are not supported on limited Stage3d profiles, so we scale them to a safe size
                if (contentWidth >= 2000 || contentHeight >= 2000)
                {
                    targetWidth = 2000;
                    targetHeight = 2000;
                }
                else
                {
                    //If they are smaller we leave them as is
                    return originalBitmapData;
                }
            }
            else
            {
                //Do nothing;
                return originalBitmapData;
            }

            var containerRatio:Number = targetWidth / targetHeight;
            var imageRatio:Number = contentWidth / contentHeight;

            if (containerRatio < imageRatio)
            {
                targetHeight = targetWidth / imageRatio;
            }
            else
            {
                targetWidth = targetHeight * imageRatio;
            }

            var matrix:Matrix = new Matrix();
            matrix.scale(targetWidth / contentWidth, targetHeight / contentHeight);
            //matrix.rotate(deg2rad(90));


            var scaledBitmapData:BitmapData = new BitmapData(targetWidth, targetHeight, false, 0x000000);
            scaledBitmapData.draw(originalBitmapData, matrix, null, null, null, true);

            return scaledBitmapData;
        }

        private function startButton_triggeredHandler(event:Event):void
        {
            GameSound.playSoundEffect("start_game");
            //GameSound.stopBgSound();
            dispatchEventWith("start");
        }

        private function aboutButton_triggeredHandler(event:Event):void
        {
            GameSound.playSoundEffect("start_game");
            dispatchEventWith("setting");
        }

        private function musicButton_changeHandler(event:Event):void
        {
            var musicButton:ToggleButton = event.currentTarget as ToggleButton;

            trace(musicButton.isSelected);
            if (musicButton.isSelected)
            {
                stopLocation = GameSound.bgSound.position;
                GameSound.bgSound.stop();
                //GameSound.isBgSoundMute = true;
            }
            else
            {
                GameSound.bgSound = GameTheme.assets.getSound("bg").play(stopLocation);
                //GameSound.isBgSoundMute = false;
            }
        }

        private function rateButton_triggeredHandler(event:Event):void
        {
            //            walkerMovie.scaleX = -1;
            //            walkerMovie.stop();
            //            walkerMovie.play();
            //            if (walkerMovie.x > 0)
            //            {
            //
            //                var moveWalkerTween:Tween = new Tween(walkerMovie, 1);
            //                moveWalkerTween.animate("x", walkerMovie.x - 20);
            //                moveWalkerTween.onComplete = function ():void
            //                {
            //                    walkerMovie.pause();
            //                };
            //                juggler.add(moveWalkerTween);
            //            }
            // AirImagePicker.instance.displayImagePicker();
            scanner.setConfig(Symbology.ALL, Config.ENABLE, 1);
            scanner.addEventListener(ScannerEvent.SCAN, scanner_scanEventHandler);
            scanner.startPreview("back",(stage.width-300)/2,(stage.height-200)/2,300,200);
            scanner.attachScannerToPreview();
        }

        private function shareButton_triggeredHandler(event:Event):void
        {
            //            walkerMovie.scale = 1;
            //            walkerMovie.stop();
            //            walkerMovie.play();
            //            if (walkerMovie.x < stage.width-20)
            //            {
            //                var moveWalkerTween:Tween = new Tween(walkerMovie,1);
            //                moveWalkerTween.animate("x", walkerMovie.x+20);
            //                moveWalkerTween.onComplete = function ():void
            //                {
            //                    walkerMovie.pause();
            //                };
            //                juggler.add(moveWalkerTween);
            //            }

            if (!AirImagePicker.isSupported)
            {
                return;
            }

            AirImagePicker.instance.addEventListener(AirImagePickerDataEvent.CANCELLED, AirImagePickerDataEvent_cancelledHandler);
            AirImagePicker.instance.addEventListener(AirImagePickerDataEvent.IMAGE_CHOSEN, AirImagePickerDataEvent_onImageChosenHandler);
            AirImagePicker.instance.addEventListener(AirImagePickerRecentImagesEvent.ON_LOAD_RESULT, AirImagePickerRecentImagesEvent_onLoadResultHandler);
            AirImagePicker.instance.displayCamera();

        }


        private function AirImagePickerDataEvent_cancelledHandler(event:AirImagePickerDataEvent):void
        {

        }

        private function AirImagePickerDataEvent_onImageChosenHandler(event:AirImagePickerDataEvent):void
        {
            var ba:ByteArray = new ByteArray();
            //scale down,air最大尺寸2048!
            var scaleDownBitmapData:BitmapData = scaleBMD(event.imageData.bitmapData, "scale");
            img.source = Texture.fromBitmapData(scaleDownBitmapData);

            scaleDownBitmapData.encode(scaleDownBitmapData.rect, new PNGEncoderOptions(true), ba);
            var file:File = File.applicationStorageDirectory.resolvePath("a_test.png");
            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeBytes(ba);
            fileStream.addEventListener(flash.events.Event.COMPLETE, function (event:flash.events.Event):void
            {
                Alert.show("OK");
            });
            fileStream.close();

        }

        private function AirImagePickerRecentImagesEvent_onLoadResultHandler(event:AirImagePickerRecentImagesEvent):void
        {
            var images:Vector.<AirImagePickerImageData> = event.imagesData;
            img.source = Texture.fromBitmapData(images[0].bitmapData);
        }

        private function scanner_scanEventHandler(event:ScannerEvent):void
        {
//            if (ctr < 1)
//            {
//                trace("Scann Code:" + event.data);
//                ctr++;
//            }
//            else
//            {
//                scanner.stopPreview();
//                ctr = 0;
//            }
            trace("Scann Code:" + event.data);
            scanner.stopPreview();
        }
    }
}
