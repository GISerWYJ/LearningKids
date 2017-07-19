/**
 *作者：汪裕峻
 *日期：2017-06-30.
 *功能:
 *版本：1.0
 **/
package screens
{
    import assets.EmbeddedAssets;

    import feathers.controls.Button;
    import feathers.controls.Screen;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.skins.ImageSkin;

    import starling.events.Event;

    public class GameScreen extends Screen
    {
        public function GameScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();
            this.layout = new AnchorLayout();
            createUI();
        }

        private function createUI():void
        {


            var lb:Button = new Button();
            lb.label = "Hello WYJ";
            lb.layoutData = new AnchorLayoutData(NaN, NaN, NaN, NaN, 0, 0);
            addChild(lb);
            lb.addEventListener(Event.TRIGGERED, lb_triggeredHandler);
        }

        private function lb_triggeredHandler(event:Event):void
        {
            dispatchEventWith("backHome");
        }
    }
}
