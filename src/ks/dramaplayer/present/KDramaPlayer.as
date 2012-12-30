package ks.dramaplayer.present 
{
	import ks.dramaplayer.data.KActorData;
	import ks.dramaplayer.data.KDramaData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	
	public class KDramaPlayer extends Sprite implements IKActor
	{
		private var _currentFrame:int = 0;
		private var _length:int = 0;
		private var _playing:Boolean = true;
		
		private var _actorFactoryDict:Dictionary = new Dictionary();
		private var _actorDict:Dictionary = new Dictionary();
		
		private var _actorLayer:Sprite = new Sprite();
		
		private var _data:KDramaData = null;
		
		public function KDramaPlayer(data:KDramaData)
		{
//			KLogger.assert(data != null, "Data must not be null!");
			_data = data;
			
			addChild(_actorLayer);
		}
		
		//-------------------------------------------------
		// Initialize
		
		public function addActorFactory(factory:KActorFactory):void
		{
			_actorFactoryDict[factory.type] = factory;
		}
		
		public function updateActors():void
		{
			removeAllActors();
			for each (var actData:KActorData in _data.actors)
			{
				createActor(actData.label, actData.type, actData.source);
			}
			this._length = _data.length;
		}
		
		private function createActor(actorLabel:String, type:String, source:String):void
		{
			var factory:KActorFactory = _actorFactoryDict[type] as KActorFactory;
			var actor:KActor = factory.create(source);
			actor.actorLabel = actorLabel;
			_actorDict[actorLabel] = actor;
			_actorLayer.addChild(actor);
		}
		
		private function removeAllActors():void
		{
			_actorLayer.removeChildren();
			_actorDict = new Dictionary();
		}
		
		//-------------------------------------------------
		// Render
		
		public function clear():void
		{
			for each (var actor:KActor in _actorDict)
			{
				actor.visible = false;
			}
		}
		
		public function render(obj:KDramaPlayerRenderObject):void
		{
//			trace(_currentFrame);
//			stage.stageFocusRect = false;
			clear();
			
			var objs:Dictionary = _data.getRenderObjectsAt(_currentFrame);
			for each (obj in objs)
			{
				var actor:KActor = _actorDict[obj.actorLabel] as KActor; 
				actor.visible = true;
				actor.render(obj);
			}
			
			if (_playing)
			{
				++_currentFrame;
				if (_currentFrame >= _length)
				{
					_currentFrame = 0;
				}
			}
		}
		
		//-------------------------------------------------
		// Timeline Control
		
		public function goto(frame:int):void
		{
			if (frame < 0)
			{
				_currentFrame += frame % _length;
			}
			else
			{
				_currentFrame %= _length;
			}
		}
		
		public function play():void
		{
			_playing = true;
		}
		
		public function stop():void
		{
			_playing = false;
		}
		
		public function next():void
		{
			++currentFrame;
		}
		
		public function prev():void
		{
			--currentFrame;
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
		
		
		//-------------------------------------------------
		// Getter and Setter
		
	}
}