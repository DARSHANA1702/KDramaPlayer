package ks.dramaplayer.tlevent
{
	import ks.dramaplayer.present.IKActor;
	import ks.dramaplayer.present.KDramaPlayer;

	public class KTimelineEvent
	{
//		public static const PAUSE:String = "pause";
//		public static const RESUME:String = "resume";
//		public static const PAUSE_MAIN:String = "pause_main";
//		public static const RESUME_MAIN:String = "resume_main";
		
		public static const NONE_TRIGGER:String = "none";
		public static const MOUSE_TRIGGER:String = "mouse";
		public static const KEY_TRIGGER:String = "key";
		
		public static const LEFT_CONDITION:String = "left";
		public static const RIGHT_CONDITION:String = "right";
		
		
		public function execute(player:KDramaPlayer, actor:IKActor, frame:int):void
		{
		}
		
		public function get type():String
		{
			return "none";
		}

		public function get trigger():String
		{
			return _trigger;
		}

		public function set trigger(value:String):void
		{
			_trigger = value;
		}

		public function get condition():String
		{
			return _condition;
		}

		public function set condition(value:String):void
		{
			_condition = value;
		}

		
		private var _trigger:String = null;
		private var _condition:String = null;
	}
}