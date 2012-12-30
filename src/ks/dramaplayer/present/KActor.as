package ks.dramaplayer.present
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import ks.dramaplayer.tlevent.KTimelineEvent;

	public class KActor extends Sprite implements IKActor
	{
		private var _player:KDramaPlayer = null;
		private var _currentFrame:int = 0;
		private var _length:int = 0;
		private var _playing:Boolean = true;
		private var _actorLabel:String = null;
		private var _source:String;
		
		private var _mouseEvnts:Array = null;
		private var _keyEvnts:Array = null;
		
		public function KActor(player:KDramaPlayer)
		{
			_player = player;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function goto(frame:int):void
		{
			currentFrame = frame;
		}
		
		public function play():void
		{
			playing = true;
		}
		
		public function stop():void
		{
			playing = false;
			
		}
		
		public function next():void
		{
			++currentFrame;
		}
		
		public function prev():void
		{
			--currentFrame;
		}
		
		public function render(obj:KDramaPlayerRenderObject):void
		{
			processAttributes(obj.attrDict);
			processEvents(obj.evntDict);
		}
		
		private function processAttributes(attrDict:Dictionary):void
		{
			if (attrDict == null)
			{
				return;
			}
			for (var attrKey:String in attrDict)
			{
				if (this[attrKey] != null)
				{
					this[attrKey] = attrDict[attrKey];
				}
			}
		}
		
		private function processEvents(evntDict:Dictionary):void
		{
			if (!playing || evntDict == null)
			{
				return;
			}
			
			_mouseEvnts = null;
			_keyEvnts = null;
			
			for each (var event:KTimelineEvent in evntDict)
			{
				switch(event.trigger)
				{
					case  KTimelineEvent.NONE_TRIGGER:
					{
						event.execute(player, this, currentFrame);
						break;
					}
						
					case  KTimelineEvent.MOUSE_TRIGGER:
					{
						if (_mouseEvnts == null)
						{
							_mouseEvnts = new Array();
						}
						_mouseEvnts.push(event);
						break;
					}
						
					case  KTimelineEvent.KEY_TRIGGER:
					{
						stage.focus = this;
						if (_keyEvnts == null)
						{
							_keyEvnts = new Array();
						}
						_keyEvnts.push(event);
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
		}
		
		public function onMouseDown(event:MouseEvent):void
		{
			if (_mouseEvnts == null)
			{
				return;
			}
			for each (var tlEvent:KTimelineEvent in _mouseEvnts)
			{
				if (tlEvent.condition == KTimelineEvent.LEFT_CONDITION)
				{
					tlEvent.execute(player, this, currentFrame);
				}
			}
		}
		
		public function onKeyDown(event:KeyboardEvent):void
		{
			if (_keyEvnts == null)
			{
				return;
			}
			for each (var tlEvent:KTimelineEvent in _keyEvnts)
			{
				if (tlEvent.condition == String.fromCharCode(event.charCode))
				{
					tlEvent.execute(player, this, currentFrame);
				}
			}
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			if (value < 0)
			{
				_currentFrame += value % _length;
			}
			else
			{
				_currentFrame = value % _length;
			}
		}

		public function get length():int
		{
			return _length;
		}

		public function set length(value:int):void
		{
			_length = value;
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function set playing(value:Boolean):void
		{
			_playing = value;
		}

		public function get actorLabel():String
		{
			return _actorLabel;
		}

		public function set actorLabel(value:String):void
		{
			_actorLabel = value;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
		}

		protected function get player():KDramaPlayer
		{
			return _player;
		}

		
	}
}