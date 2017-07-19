/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能: App主框架
 *版本：1.0
 **/
package
{
    import feathers.controls.StackScreenNavigator;
    import feathers.controls.StackScreenNavigatorItem;
    import feathers.motion.Fade;
    import feathers.motion.Slide;

    import screens.AboutScreen;
    import screens.GameScreen;
    import screens.HomeScreen;

    import starling.events.Event;

    import themes.GameTheme;

    public class Main extends StackScreenNavigator
    {

        private static const HOME_SCREEN:String = "homeScreen";
        private static const ABOUT_SCREEN:String = "about";
        private static const GAME_SCREEN:String = "game";

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
            var homeScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HomeScreen);
            homeScreenItem.setScreenIDForPushEvent("about", ABOUT_SCREEN);
            homeScreenItem.setScreenIDForPushEvent("game", GAME_SCREEN);
            this.addScreen(HOME_SCREEN, homeScreenItem);

            var aboutScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AboutScreen);
            aboutScreenItem.addPopEvent("backHome");
            this.addScreen(ABOUT_SCREEN, aboutScreenItem);

            var gameScreen:StackScreenNavigatorItem = new StackScreenNavigatorItem(GameScreen);
            gameScreen.addPopEvent("backHome");
//            gameScreen.pushTransition = Fade.createFadeInTransition();
//            gameScreen.popTransition = Fade.createFadeOutTransition();
            this.addScreen(GAME_SCREEN, gameScreen);

            this.rootScreenID = HOME_SCREEN;

            this.pushTransition = Fade.createFadeInTransition();
            this.popTransition = Fade.createFadeOutTransition();
        }

        //主题资源加载完毕
        private function gameTheme_completeHandler(event:Event):void
        {
            createGameFramework();
        }
    }
}
