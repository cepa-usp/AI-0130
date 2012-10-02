package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Forma extends Sprite 
	{
		
		private var maxParticulas:int = 3;
		private var minParticulas:int = 1;
		public var children:Vector.<Forma> = new Vector.<Forma>();
		public var particulas:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		public var cargasPositivas:Boolean;
		public var borda:Borda;
		public var condutor:Condutor;
		
		public function Forma() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			getChildren();
			if(children.length == 0) addParticulas();
		}
		
		private function getChildren():void 
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if (getChildAt(i) is Forma) {
					children.push(Forma(getChildAt(i)));
				}
				
				if (getChildAt(i) is Borda) {
					borda = Borda(getChildAt(i));
					borda.alpha = 0;
				}
				
				if (getChildAt(i) is Condutor) {
					condutor = Condutor(getChildAt(i));
				}
			}
		}
		
		private function addParticulas():void 
		{
			var nParticulas:int = Math.random() * maxParticulas + minParticulas;
			cargasPositivas = Math.round(Math.random()) == 0 ? true: false;
			
			for (var i:int = 0; i < nParticulas; i++) 
			{
				particulas.push(new Particula(cargasPositivas));
			}
			
			addParticulasToForma(nParticulas);
		}
		
		private function addParticulasToForma(nParticulas:int):void 
		{
			if(particulas.length > 0) var raio:Number = particulas[0].width / 2;
			
			switch(nParticulas) {
				case 1:
					addChild(particulas[0]);
					break;
				case 2:
					addChild(particulas[0]);
					particulas[0].x = -raio;
					addChild(particulas[1]);
					particulas[1].x = raio;
					break;
				case 3:
					addChild(particulas[0]);
					particulas[0].x = -raio;
					particulas[0].y = Math.sqrt(3) * raio / 3;
					addChild(particulas[1]);
					particulas[1].x = raio;
					particulas[1].y = Math.sqrt(3) * raio / 3;
					addChild(particulas[2]);
					particulas[2].x = 0;
					particulas[2].y = - Math.sqrt(3) * 2 * raio / 3;
					break;
				
			}
		}
		
	}

}