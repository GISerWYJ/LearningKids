/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能: App主框架
 *版本：1.0
 **/
package
{
    import assets.GameSound;

    import data.GameData;
    import data.GameSettingData;

    import feathers.controls.StackScreenNavigator;
    import feathers.controls.StackScreenNavigatorItem;
    import feathers.motion.Cover;
    import feathers.motion.Fade;
    import feathers.motion.Reveal;

    import screens.GameScreen;
    import screens.HomeScreen;
    import screens.SettingScreen;
    import screens.StartScreen;

    import so.cuo.platform.admob.Admob;
    import so.cuo.platform.admob.AdmobEvent;

    import starling.events.Event;

    import themes.GameTheme;

    public class Main extends StackScreenNavigator
    {

        private static const HOME_SCREEN:String = "homeScreen";
        private static const SETTING_SCREEN:String = "aboutScreen";
        private static const GAME_SCREEN:String = "gameScreen";
        private static const START_SCREEN:String = "startScreen";

        public static var settings:GameSettingData = new GameSettingData();


        private var gameTheme:GameTheme;

        public function Main()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();


            gameTheme = new GameTheme();
            gameTheme.addEventListener(Event.COMPLETE, gameTheme_completeHandler);

        }


        private function createGameFramework():void
        {
            //欢迎界面
            var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
            homeScreenItem.setScreenIDForPushEvent("setting", SETTING_SCREEN);
            homeScreenItem.setScreenIDForPushEvent("game", GAME_SCREEN);
            homeScreenItem.setScreenIDForPushEvent("start", START_SCREEN);
            this.addScreen(HOME_SCREEN, homeScreenItem);
            //设置界面
            //设置数据存储在settings里
            //var settings:GameSettingData = new GameSettingData();
            var settingScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SettingScreen);
            settingScreenItem.addPopEvent(Event.COMPLETE);
            settingScreenItem.properties.settingData = settings;
            settingScreenItem.pushTransition = Cover.createCoverUpTransition();
            settingScreenItem.popTransition = Reveal.createRevealDownTransition();
            this.addScreen(SETTING_SCREEN, settingScreenItem);
            //开始界面
            var gameData:GameData = new GameData();
            var startScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(StartScreen);
            startScreenItem.setScreenIDForPushEvent("game", GAME_SCREEN);
            startScreenItem.setScreenIDForPushEvent("setting", SETTING_SCREEN);
            startScreenItem.addPopEvent(Event.COMPLETE);
            startScreenItem.properties.gameData = gameData;
            this.addScreen(START_SCREEN, startScreenItem);
            //游戏界面
            var gameScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GameScreen);
            gameScreenItem.addPopEvent(Event.COMPLETE);
            gameScreenItem.properties.gameData = gameData;
            this.addScreen(GAME_SCREEN, gameScreenItem);

            this.rootScreenID = HOME_SCREEN;

            this.pushTransition = Fade.createFadeInTransition();
            this.popTransition = Fade.createFadeOutTransition();
        }

        //主题资源加载完毕
        private function gameTheme_completeHandler(event:Event):void
        {
            createGameFramework();

            //设置Admob的横幅广告ID、插屏广告的ID
            Admob.getInstance().setKeys("ca-app-pub-9744164684092475/5863052740", "ca-app-pub-9744164684092475/1246634747");//"ca-app-pub-9744164684092475/1246634747"
            //开始缓存插屏广告
            Admob.getInstance().cacheVideo("ca-app-pub-9744164684092475/5290065689");
            //Admob.getInstance().cacheInterstitial();
            Admob.getInstance().addEventListener(AdmobEvent.onBannerReceive, onBannerReceiveHandler);
            Admob.getInstance().addEventListener(AdmobEvent.onBannerFailedReceive, onBannerFailedReceiveHandler);
            
            //play the bgSound
            GameSound.playBgSound();
        }


        private function onBannerReceiveHandler(event:AdmobEvent):void
        {
            trace("Ad recieved");
            // Alert.show("ok");
        }


        private function onBannerFailedReceiveHandler(event:AdmobEvent):void
        {
            trace("Ad error occured");
            //Alert.show(event.data.toString());
        }
    }
}
