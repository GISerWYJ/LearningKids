/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package screens
{
    import assets.GameSound;

    import data.GameData;

    import feathers.controls.Button;
    import feathers.controls.ImageLoader;
    import feathers.controls.List;
    import feathers.controls.ProgressBar;
    import feathers.controls.Screen;
    import feathers.controls.ScrollBarDisplayMode;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ArrayCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalAlign;
    import feathers.layout.SlideShowLayout;
    import feathers.layout.VerticalAlign;

    import flash.filesystem.File;

    import so.cuo.platform.admob.Admob;
    import so.cuo.platform.admob.AdmobEvent;
    import so.cuo.platform.admob.AdmobPosition;
    import so.cuo.platform.admob.AdmobSize;

    import starling.display.Image;
    import starling.events.Event;
    import starling.filters.DropShadowFilter;
    import starling.textures.Texture;
    import starling.utils.AssetManager;

    import themes.GameTheme;

    public class GameScreen extends Screen
    {
        //主界面类别列表
        public var gameData:GameData;

        private var imgList:List;

        private var loadingBar:ProgressBar;

        private var currentPageNum:Number = 0;

        private var borderIndex:Number = 0;

        private var itemNameButton:Button;

        private var borderImage:Image;

        //负责加载游戏中各类资源
        private var gameAssetManager:AssetManager;

        public function GameScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();

            //进入游戏界面，停止音乐
            GameSound.stopBgSound();
            this.layout = new AnchorLayout();

            this.loadingBar = new ProgressBar();
            this.loadingBar.minimum = 0;
            this.loadingBar.maximum = 1;
            this.loadingBar.value = 0;
            this.loadingBar.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);

            addChild(loadingBar);

            gameAssetManager = new AssetManager(2);
            var appDir:File = File.applicationDirectory;


            //load the assets according to the gameCategory passed in
            //1.enqueue the pictures.
            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/" + gameData.gameCatergory + ".png"));
            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/" + gameData.gameCatergory + ".xml"));

            //2.enqueue the sound effects.
            gameAssetManager.enqueue(appDir.resolvePath("assets/sounds/" + gameData.gameCatergory));
            //3.enqueue the borders
            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/borders.png"));
            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/borders.xml"));

            gameAssetManager.enqueue(File.applicationStorageDirectory.resolvePath("a_test.png"));
           
            //2.load the queue.
            gameAssetManager.loadQueue(assetManager_onProgress);


        }

        override public function dispose():void
        {
            if (gameAssetManager)
            {
                gameAssetManager.purge();
            }
            super.dispose();
        }

        protected function assetManager_onProgress(ratio:Number):void
        {
            if (ratio < 1)
            {
                trace("ration:" + ratio);
                this.loadingBar.value = ratio;
                return;
            }

            removeChild(loadingBar, true);
            createUI();
        }

        protected function imgListItemRendererFactory():IListItemRenderer
        {
            var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
            //itemRenderer.labelField = "label";
            itemRenderer.itemHasLabel = false;
            itemRenderer.iconSourceField = "texture";

            //itemRenderer.iconPosition = RelativePosition.;
            itemRenderer.horizontalAlign = HorizontalAlign.CENTER;
            itemRenderer.verticalAlign = VerticalAlign.MIDDLE;
            itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
            itemRenderer.iconLoaderFactory = function ():ImageLoader
            {
                var imgLoader:ImageLoader = new ImageLoader();
                imgLoader.width = 245;
                imgLoader.height = 175;
                imgLoader.maintainAspectRatio = false;
                return imgLoader;

            };


            //itemRenderer.gap = 2;

            return itemRenderer;
        }

        /**
         * 根据加载的图片资源构建图片列表的数据源
         * @return 新的数据源
         */
        private function createDataforList():ArrayCollection
        {
            var listData:ArrayCollection = new ArrayCollection();
            var textures:Vector.<Texture> = gameAssetManager.getTextures("a_");
            var textureNames:Vector.<String> = gameAssetManager.getTextureNames("a_");
            for (var i:int = 0; i < textureNames.length; i++)
            {
                listData.addItem({
                    label: textureNames[i],
                    texture: textures[i]
                });
            }

            return listData;
        }

        private function createUI():void
        {


            imgList = new List();
            imgList.snapToPages = true;
            imgList.itemRendererFactory = imgListItemRendererFactory;
            imgList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;


            var sliderShowLayout:SlideShowLayout = new SlideShowLayout();

            imgList.layout = sliderShowLayout;
            imgList.layoutData = new AnchorLayoutData(NaN, 0, NaN, 0, 0, 0);
            imgList.addEventListener(Event.SCROLL, imgList_scrollHandler);

            imgList.dataProvider = createDataforList();

            addChild(imgList);

            //border
            borderImage = new Image(gameAssetManager.getTexture("border0"));
            borderImage.x = (stage.width - borderImage.width) / 2;
            borderImage.y = (stage.height - borderImage.height) / 2;
            borderImage.touchable = false;
            borderImage.filter = new DropShadowFilter();
            addChild(borderImage);

            //back to start Screen button
            var backButton:Button = new Button();
            backButton.styleNameList.add(GameTheme.BACK_BUTTON_STYLE);
            backButton.layoutData = new AnchorLayoutData(70, NaN, NaN, 10);
            backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
            addChild(backButton);


            //left button
            var leftButton:Button = new Button();
            leftButton.styleNameList.add(GameTheme.PRE_IMAGE_BUTTON_STYLE);
            leftButton.layoutData = new AnchorLayoutData(NaN, NaN, 10, 10, NaN, NaN);
            leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
            addChild(leftButton);

            //left button
            var rightButton:Button = new Button();
            rightButton.styleNameList.add(GameTheme.NEXT_IMAGE_BUTTON_STYLE);
            rightButton.layoutData = new AnchorLayoutData(NaN, 10, 10, NaN, NaN, NaN);
            rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
            addChild(rightButton);


            //itemNames
            itemNameButton = new Button();
            itemNameButton.styleNameList.add(GameTheme.ITEM_NAME_BUTTON);
            var anchorLayout:AnchorLayoutData = new AnchorLayoutData();
            anchorLayout.left = -5;
            anchorLayout.leftAnchorDisplayObject = leftButton;
            anchorLayout.right = -5;
            anchorLayout.rightAnchorDisplayObject = rightButton;
            anchorLayout.verticalCenter = 0;
            anchorLayout.verticalCenterAnchorDisplayObject = leftButton;
            itemNameButton.layoutData = anchorLayout;
            itemNameButton.label = imgList.dataProvider.getItemAt(0).label;
            itemNameButton.addEventListener(Event.TRIGGERED, itemNameButton_triggeredHandler);
            addChildAt(itemNameButton, 0);

            Admob.getInstance().showBanner(AdmobSize.SMART_BANNER, AdmobPosition.TOP_CENTER);
            
            
            //Admob.getInstance().cacheInterstitial();


        }




        private function leftButton_triggeredHandler(event:Event):void
        {
            if (currentPageNum > 0)
            {
                imgList.scrollToPageIndex(--currentPageNum, 0);
            }
        }

        private function imgList_scrollHandler(event:Event):void
        {
            currentPageNum = imgList.horizontalPageIndex;
            itemNameButton.label = imgList.dataProvider.getItemAt(currentPageNum).label;
        }

        private function rightButton_triggeredHandler(event:Event):void
        {
            if (currentPageNum < imgList.horizontalPageCount - 1)
            {
                imgList.scrollToPageIndex(++currentPageNum, 0);
            }
        }

        private function itemRenderer_triggeredHandler(event:Event):void
        {
          //  var touchedItem:Object = imgList.selectedItem;
           // gameAssetManager.playSound(touchedItem.label);

        }

        private function backButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(Event.COMPLETE);
            //离开游戏界面，恢复音乐
            GameSound.playBgSound();

//            if (Admob.getInstance().isInterstitialReady())
//            {
//                Admob.getInstance().showInterstitial();
//            }

            if(Admob.getInstance().isVideoReady())
            {
                Admob.getInstance().showVideo();
                //Admob.getInstance().cacheVideo("ca-app-pub-9744164684092475/5290065689");
            }



        }

        private function itemNameButton_triggeredHandler(event:Event):void
        {
            borderIndex++;
            if (borderIndex > 9)
            {
                borderIndex = 0;
            }
            borderImage.texture = gameAssetManager.getTexture("border" + borderIndex);
        }


        
    }
}
