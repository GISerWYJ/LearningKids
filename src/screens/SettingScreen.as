/**
 *作者：汪裕峻
 *日期：2017-06-26.
 *功能:
 *版本：1.0
 **/
package screens
{
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Screen;
    import feathers.controls.ToggleButton;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import starling.display.Image;
    import starling.events.Event;

    import themes.GameTheme;

    public class SettingScreen extends Screen
    {


        public function SettingScreen()
        {
            super();
        }


        override public function dispose():void
        {

            super.dispose();
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
            //添加aboutInfo
            var aboutPanel:Image = new Image(GameTheme.assets.getTexture("setting_bg"));
            aboutPanel.x = (stage.width - aboutPanel.width) / 2;
            aboutPanel.y = (stage.height - aboutPanel.height) / 2 - 30;
            addChild(aboutPanel);

            //声音控制按钮

            var controlGroup:LayoutGroup = new LayoutGroup();
            var controlLayout:VerticalLayout = new VerticalLayout();
            controlLayout.gap = 10;
            controlGroup.layout = controlLayout;
            controlGroup.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
            addChild(controlGroup);

            var itemHLayout:HorizontalLayout = new HorizontalLayout();
            itemHLayout.gap = 15;
            var musicGroup:LayoutGroup = new LayoutGroup();
            var musicLabel:Label = new Label();
            musicLabel.text = "音乐";
            musicGroup.layout = itemHLayout;
            var musicToggleButton:ToggleButton = new ToggleButton();
            musicGroup.addChild(musicLabel);
            musicGroup.addChild(musicToggleButton);
            controlGroup.addChild(musicGroup);

            var effectGroup:LayoutGroup = new LayoutGroup();
            var effectLabel:Label = new Label();
            effectLabel.text = "音效";
            effectGroup.layout = itemHLayout;
            var effectToggleButton:ToggleButton = new ToggleButton();
            effectGroup.addChild(effectLabel);
            effectGroup.addChild(effectToggleButton);
            controlGroup.addChild(effectGroup);

            //添加返回按钮
            var backButton:Button = new Button();
            backButton.styleNameList.add(GameTheme.BACK_BUTTON_STYLE);
            backButton.validate();
            backButton.x = (stage.width - backButton.width) / 2;
            backButton.y = aboutPanel.y + aboutPanel.height + 20;

            backButton.addEventListener(Event.TRIGGERED, button_triggeredHandler);
            addChild(backButton);

        }

        private function button_triggeredHandler(event:Event):void
        {
            dispatchEventWith(Event.COMPLETE);
        }
    }
}
