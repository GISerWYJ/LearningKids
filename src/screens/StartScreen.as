/**
 *作者：汪裕峻
 *日期：2017-07-24.
 *功能:
 *版本：1.0
 **/
package screens
{
    import data.GameData;

    import feathers.controls.Button;
    import feathers.controls.List;
    import feathers.controls.Screen;
    import feathers.controls.ScrollPolicy;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ArrayCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.TiledRowsLayout;

    import flash.utils.Dictionary;

    import so.cuo.platform.admob.Admob;
    import so.cuo.platform.admob.AdmobPosition;
    import so.cuo.platform.admob.AdmobSize;

    import starling.display.DisplayObject;
    import starling.events.Event;

    import themes.GameTheme;

    public class StartScreen extends Screen
    {
        public var gameData:GameData;
        private var categoryList:List;
        private var cachedAccessories:Dictionary = new Dictionary();

        public function StartScreen()
        {
            super();
        }


        override public function dispose():void
        {
            //dispose list button

//            categoryList.dataProvider.dispose(function ():void
//            {
//                for each(var item in cachedAccessories)
//                {
//                    item.dispose();
//                }
//            });


            super.dispose();
        }

        override protected function initialize():void
        {
            super.initialize();
            //set the screen layout
            this.layout = new AnchorLayout();
            //add UI
            createUI();
        }

        private function createUI():void
        {

            //Back Home Button
            var homeButton:Button = new Button();
            homeButton.styleNameList.add(GameTheme.HOME_BUTTON_STYLE);
            homeButton.layoutData = new AnchorLayoutData(10, NaN, NaN, 10, NaN, NaN);
            homeButton.addEventListener(Event.TRIGGERED, homeButton_triggeredHandler);
            addChild(homeButton);
            //Setting Button
            var settingButton:Button = new Button();
            settingButton.styleNameList.add(GameTheme.INGAME_SETTING_BUTTON_STYLE);
            settingButton.layoutData = new AnchorLayoutData(10, 10, NaN, NaN, NaN, NaN);
            settingButton.addEventListener(Event.TRIGGERED, settingButton_triggeredHandler);
            addChild(settingButton);

            categoryList = new List();
            categoryList.dataProvider = new ArrayCollection([{label: 'animals',data:'动物',texture:GameTheme.assets.getTexture("animal")},
                {label: 'fruites',data:'果蔬',texture:GameTheme.assets.getTexture("fruite")},
                {label: 'life',data:'汽车',texture:GameTheme.assets.getTexture("car")},
                {label: 'buildings',data:'建筑',texture:GameTheme.assets.getTexture("building")}]);
            var tileRowLayout:TiledRowsLayout = new TiledRowsLayout();
            tileRowLayout.requestedColumnCount = 2;
            tileRowLayout.gap = 5;
            categoryList.layout = tileRowLayout;
            categoryList.itemRendererFactory = function ():IListItemRenderer
            {
                var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

                renderer.itemHasLabel = false;
                renderer.iconSourceField = "texture";
                
                renderer.addEventListener(Event.TRIGGERED, accessory_triggeredHandler);
//                renderer.accessoryFunction = function (item:Object):DisplayObject
//                {
//                    if (item in cachedAccessories)
//                    {
//                        return cachedAccessories[item];
//                    }
//                    trace("accessory function");
//                    var accessory:Button = new Button();
//                    accessory.styleNameList.add(GameTheme.CATEGORY_BUTTON_STYLE);
//                    accessory.addEventListener(Event.TRIGGERED, accessory_triggeredHandler);
//                    accessory.label = item.data;
//                    accessory.name = item.label;
//                    accessory.width = accessory.height = 100;
//                    cachedAccessories[item] = accessory;
//                    return accessory;
//                };

                return renderer;
            };
            categoryList.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
            categoryList.verticalScrollPolicy = ScrollPolicy.OFF;
            addChild(categoryList);

            Admob.getInstance().showBanner(AdmobSize.SMART_BANNER,AdmobPosition.BOTTOM_CENTER);
        }

        private function accessory_triggeredHandler(event:Event):void
        {
            var itemRenderer:DefaultListItemRenderer = (event.currentTarget as DefaultListItemRenderer);
            gameData.gameCatergory = itemRenderer.data.label;
            dispatchEventWith("game");
        }

        private function homeButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(Event.COMPLETE);
        }

        private function settingButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith("setting");
        }
    }
}
