package ks.dramaplayer.data
{
	import flash.utils.Dictionary;
	
	import ks.dramaplayer.present.KDramaPlayerRenderObject;

	public class KDramaData
	{
		private var _reader:IKDramaScriptReader = null;
		private var _writer:IKDramaScriptWriter = null;
		private var _actorDict:Dictionary = new Dictionary();
		
		public function KDramaData(reader:IKDramaScriptReader, writer:IKDramaScriptWriter = null)
		{
			_reader = reader;
			_writer = writer;
		}
		
		public function getRenderObjectsAt(frame:int):Dictionary
		{
			var objs:Dictionary = new Dictionary();
			for each (var actData:KActorData in _actorDict)
			{
				var obj:KDramaPlayerRenderObject = null;
				obj = actData.valueAt(frame);
				if (obj != null)
				{
					objs[obj.actorLabel] = obj;
				}
			}
			return objs;
		}
		
		public function createActor(actLabel:String, source:String):void
		{
			var actData:KActorData = new KActorData();
			actData.label = actLabel;
			actData.source = source;
			_actorDict[actLabel] = actData;
		}
		
		public function removeActor(actLabel:String):void
		{
			delete _actorDict[actLabel];
		}
		
		public function getAcotr(actLabel:String):KActorData
		{
			return _actorDict[actLabel];
		}
		
		public function removeAllActors():void
		{
			_actorDict = new Dictionary();
		}
		
		public function readScript(path:String):void
		{
			_reader.readScript(path, this);
		}
		
		public function writeScript(path:String):void
		{
			_writer.writeScript(path, this);
		}

		public function get actors():Dictionary
		{
			return _actorDict;
		}
		
		public function get length():int
		{
			var max:int = 0;
			for each (var actor:KActorData in _actorDict)
			{
				var len:int = actor.length;
				if (len > max)
				{
					max = len
				}
			}
			return max;
		}
		
	}
}