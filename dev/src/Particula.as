package  
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Particula extends Sprite 
	{
		private var _positivo:Boolean;
		private var selectedFilter:GlowFilter = new GlowFilter(0xFF0000, 1, 10, 10);
		private var _selected:Boolean = false;
		
		public function Particula(positivo:Boolean) 
		{
			this.mouseChildren = false;
			this._positivo = positivo;
			if (positivo) {
				this.addChild(new CargaPos());
			}else {
				this.addChild(new CargaNeg());
			}
		}
		
		public function get positivo():Boolean 
		{
			return _positivo;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if (value) {
				this.filters = [selectedFilter];
			}else {
				this.filters = [];
			}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
	}

}