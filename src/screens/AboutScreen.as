/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能:
 *版本：1.0
 **/
package screens
{
    import feathers.controls.Button;
    import feathers.controls.Screen;
    import feathers.layout.AnchorLayout;

    import starling.display.Image;
    import starling.events.Event;

    import themes.GameTheme;

    public class AboutScreen extends Screen
    {


        private var ballon:Image;

        public function AboutScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();
            //布局
            this.layout = new AnchorLayout();
            //添加主页UI元素
            createUI();

        }

        private function createUI():void
        {

            //添加背景


            //添加气球
            ballon = new Image(GameTheme.assets.getTexture("baloon"));
            ballon.x = (stage.width - ballon.width) / 2;
            ballon.y = (stage.height - ballon.height) / 2;
            addChild(ballon);

            //添加aboutInfo
            var aboutPanel:Image = new Image(GameTheme.assets.getTexture("about_info"));
            aboutPanel.x = (stage.width - aboutPanel.width) / 2;
            aboutPanel.y = (stage.height - ballon.height) / 2 - 30;
            addChild(aboutPanel);
            //添加返回按钮
            var backButton:Button = new Button();
            backButton.validate();
            backButton.label = "返回";
            backButton.width = backButton.height = 50;
            backButton.x = (stage.width - backButton.width) / 2;
            backButton.y = aboutPanel.y + aboutPanel.height + 20;
            backButton.addEventListener(Event.TRIGGERED, button_triggeredHandler);
            addChild(backButton);

        }

        private function button_triggeredHandler(event:Event):void
        {
            dispatchEventWith("backHome");
        }
    }
}
