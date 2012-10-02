package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class AtividadeInterativa extends MovieClip
	{
		//Telas de informações e CC
		private var infoScreen:InfoScreen;
		private var aboutScreen:AboutScreen;
		
		//Botões padrão
		private var btn_Reset:Btn_Reset;
		private var btn_Instructions:Btn_Instructions;
		private var btn_CC:Btn_CC;
		
		//Moldura padrão
		private var moldura:Moldura;
		
		//Barra de menu padrão
		private var _menuBar:MenuBar;
		
		//Camadas
		private var cmd_Buttons:Sprite;
		private var cmd_Moldura:Sprite;
		private var cmd_Menu:Sprite;
		private var cmd_Atividade:Sprite;
		private var cmd_Screen:Sprite;
		
		//Botões
		//private var botao1:Botao1;
		//private var botao2:Botao1;
		//private var botao3:Botao1;
		
		private var bla:int = 0;
		
		
		public function AtividadeInterativa() 
		{
			init();
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.scrollRect = new Rectangle(0, 0, 640, 480);			
			createLayers();		
			//configStage();			

			
		}
		
		private function createLayers():void
		{
			cmd_Atividade = new Sprite();
			cmd_Buttons = new Sprite();
			cmd_Menu = new Sprite();
			cmd_Moldura = new Sprite();
			cmd_Screen = new Sprite();
			orderLayers();
		}
		
		public function orderLayers():void {
			addChild(cmd_Atividade);
			addChild(cmd_Menu);
			addChild(cmd_Moldura);
			addChild(cmd_Buttons);
			addChild(cmd_Screen);
			
		}
		
		private function configStage():void
		{
			menuBar = new MenuBar();
			cmd_Menu.addChild(menuBar);
			
			moldura = new Moldura();
			cmd_Moldura.addChild(moldura);
			
			btn_Instructions = new Btn_Instructions();
			btn_CC = new Btn_CC();
			btn_Reset = new Btn_Reset();
			cmd_Buttons.addChild(btn_Instructions);
			cmd_Buttons.addChild(btn_CC);
			cmd_Buttons.addChild(btn_Reset);
			
			btn_Instructions.x = 629.2;
			btn_Instructions.y = 25;
			btn_Instructions.addEventListener(MouseEvent.CLICK, showInstructions);
			
			btn_CC.x = 629.2;
			btn_CC.y = 52;
			btn_CC.addEventListener(MouseEvent.CLICK, showCC);
			
			btn_Reset.x = 629.2;
			btn_Reset.y = 79;
			
			infoScreen = new InfoScreen();
			cmd_Screen.addChild(infoScreen);
			
			aboutScreen = new AboutScreen();
			cmd_Screen.addChild(aboutScreen);
		}
		
		private function showCC(e:MouseEvent):void 
		{
			aboutScreen.openScreen();
		}
		
		private function showInstructions(e:MouseEvent):void 
		{
			infoScreen.openScreen();
		}
		

		
		public function get menuBar():MenuBar 
		{
			return _menuBar;
		}
		
		public function set menuBar(value:MenuBar):void 
		{
			_menuBar = value;
		}
		
		public function get Atividade():Sprite 
		{
			return cmd_Atividade;
		}
		
		public function set Atividade(value:Sprite):void 
		{
			cmd_Atividade = value;
		}
		
		public function get btnReset():Btn_Reset 
		{
			return btn_Reset;
		}
		
		public function set btnReset(value:Btn_Reset):void 
		{
			btn_Reset = value;
		}
		
		public function get btnCC():Btn_CC 
		{
			return btn_CC;
		}
		
		public function set btnCC(value:Btn_CC):void 
		{
			btn_CC = value;
		}
		
		public function get btnInstructions():Btn_Instructions 
		{
			return btn_Instructions;
		}
		
		public function set btnInstructions(value:Btn_Instructions):void 
		{
			btn_Instructions = value;
		}
		
	}
	
}