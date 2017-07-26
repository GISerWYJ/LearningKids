/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package screens
{
    import data.GameData;

    import feathers.controls.Button;
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

    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;

    public class GameScreen extends Screen
    {
        //主界面类别列表
        public var gameData:GameData;

        private var imgList:List;

        private var loadingBar:ProgressBar;

        private var currentPageNum:Number = 0;

        //负责加载游戏中各类资源
        private var gameAssetManager:AssetManager;

        public function GameScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();

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
            //itemRenderer.maxWidth = 80;
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
            var textures:Vector.<Texture> = gameAssetManager.getTextures();
            var textureNames:Vector.<String> = gameAssetManager.getTextureNames();
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
            imgList.layoutData = new AnchorLayoutData(0,10, 0, 10);
            imgList.addEventListener(Event.SCROLL, imgList_scrollHandler);

            imgList.dataProvider = createDataforList();

            addChild(imgList);

            //left button
            var leftButton:Button = new Button();
            leftButton.label = "<";
            leftButton.width = leftButton.height = 50;
            leftButton.layoutData = new AnchorLayoutData(NaN, NaN, 10, 10, NaN, NaN);
            leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
            addChild(leftButton);

            //left button
            var rightButton:Button = new Button();
            rightButton.label = ">";
            rightButton.width = rightButton.height = 50;
            rightButton.layoutData = new AnchorLayoutData(NaN, 10, 10, NaN, NaN, NaN);
            rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
            addChild(rightButton);


            var title:Button = new Button();
            title.addEventListener(Event.TRIGGERED, lb_triggeredHandler);
            title.layoutData = new AnchorLayoutData(10, NaN, NaN, NaN, 0, NaN);
            addChild(title);


        }

        private function lb_triggeredHandler(event:Event):void
        {
            dispatchEventWith(Event.COMPLETE);

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
            var touchedItem:Object = imgList.selectedItem;
            gameAssetManager.playSound(touchedItem.label);
            
        }
    }
}
