package 
{
	import cepa.ai.AIConstants;
	import cepa.ai.IPlayInstance;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayInstance130 implements IPlayInstance 
	{
		private var _score:Number;
		
		private var _playMode:int = AIConstants.PLAYMODE_FREEPLAY;
		
		public function PlayInstance130() 
		{
			
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function get playMode():int 
		{
			return _playMode;
		}
		
		public function set playMode(value:int):void 
		{
			_playMode = value;
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function returnAsObject():Object 
		{
			var o:Object = new Object();
			o.score = _score;
			o.playMode = _playMode;
			return o;
		}
		
		public function bind(obj:Object):void 
		{
			_score = obj.score;
			_playMode = obj.playMode;
		}
		
		public function getScore():Number 
		{
			return score;
		}
		
		public function evaluate():void 
		{
			return;
		}
		
	}

}