/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package screens
{
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.Screen;
    import feathers.controls.ScrollBarDisplayMode;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalAlign;
    import feathers.layout.SlideShowLayout;
    import feathers.layout.VerticalAlign;

    import flash.filesystem.File;

    import starling.events.Event;
    import starling.utils.AssetManager;

    import themes.GameTheme;

    public class GameScreen extends Screen
    {

        private var imgList:List;

        private var title:Label;

        private var currentPageNum:Number = 0;

        private var gameAssetManager:AssetManager;

        public function GameScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();

            this.layout = new AnchorLayout();

            gameAssetManager = new AssetManager(2);
            var appDir:File = File.applicationDirectory;


            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/animals.png"));
            gameAssetManager.enqueue(appDir.resolvePath("assets/textures/2x/animals.xml"));

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
                return;
            }

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

        private function createUI():void
        {
            imgList = new List();
            imgList.snapToPages = true;
            imgList.itemRendererFactory = imgListItemRendererFactory;
            imgList.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;


            imgList.layout = new SlideShowLayout();
            imgList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            imgList.addEventListener(Event.SCROLL, imgList_scrollHandler);


            imgList.dataProvider = new ListCollection(
                    [
                        {
                            label: "baloon",
                            texture: gameAssetManager.getTexture("cat")
                        },
                        {
                            label: "cute_button_down",
                            texture: gameAssetManager.getTexture("horse")
                        },
                        {
                            label: "cute_button_normal",
                            texture: gameAssetManager.getTexture("lion")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("giraffe")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("bird")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("butterfly")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("fish")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("monkey")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("dog")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("elephant")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("wolf")
                        },
                        {
                            label: "logo",
                            texture: gameAssetManager.getTexture("rabbit")
                        }

                    ]);


            addChild(imgList);

            //left button
            var leftButton:Button = new Button();
            leftButton.label = "<";
            leftButton.width = leftButton.height = 50;
            leftButton.layoutData = new AnchorLayoutData(NaN, NaN, NaN, 10, NaN, 0);
            leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
            addChild(leftButton);

            //left button
            var rightButton:Button = new Button();
            rightButton.label = ">";
            rightButton.width = rightButton.height = 50;
            rightButton.layoutData = new AnchorLayoutData(NaN, 10, NaN, NaN, NaN, 0);
            rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
            addChild(rightButton);


            var title:Button = new Button();
            title.addEventListener(Event.TRIGGERED, lb_triggeredHandler);
            title.layoutData = new AnchorLayoutData(10, NaN, NaN, NaN, 0, NaN);
            addChild(title);


        }

        private function lb_triggeredHandler(event:Event):void
        {
            dispatchEventWith("backHome");
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
            //title.text = (event.currentTarget as DefaultListItemRenderer).data.label;
        }
    }
}
