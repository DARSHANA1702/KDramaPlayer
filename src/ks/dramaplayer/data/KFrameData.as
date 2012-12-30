package ks.dramaplayer.data
{
	import flash.utils.Dictionary;

	public class KFrameData
	{
		private var _frame:int = 0;
		private var _interpolation:Function = null;
		private var _attributes:Dictionary = new Dictionary();
		private var _events:Dictionary = new Dictionary();
		
		public function KFrameData()
		{
		}

		public function get frame():int
		{
			return _frame;
		}

		public function set frame(value:int):void
		{
			_frame = value;
		}

		public function get interpolation():Function
		{
			return _interpolation;
		}

		public function set interpolation(value:Function):void
		{
			_interpolation = value;
		}

		public function get attributes():Dictionary
		{
			return _attributes;
		}

		public function set attributes(value:Dictionary):void
		{
			_attributes = value;
		}

		public function get events():Dictionary
		{
			return _events;
		}

		public function set events(value:Dictionary):void
		{
			_events = value;
		}


	}
}