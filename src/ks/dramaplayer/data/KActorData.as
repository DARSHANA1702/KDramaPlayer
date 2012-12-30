package ks.dramaplayer.data
{
	import flash.utils.Dictionary;
	
	import ks.dramaplayer.present.KDramaPlayerRenderObject;
	
	import ks.dramaplayer.tlevent.KTimelineEvent;

	public class KActorData
	{
		
		private var _type:String = "none";
		private var _source:String = null;
		private var _label:String = null;
		
		private var _frames:Array = new Array();
		
		public function KActorData()
		{
		}
		
		/**
		 * 如果目标位置不存在关键帧，则新建一个关键桢。
		 */
		public function putKeyFrameAttribute(frame:int, attrLabel:String, value:*):void
		{
			var fData:KFrameData = null;
			
			for each (var item:KFrameData in _frames)
			{
				if (item.frame == frame)
				{
					fData = item;
					break;
				}
			}
			
			if (fData == null)
			{
				fData = new KFrameData();
				fData.frame = frame;
				if (_frames.length == 0 
					|| (_frames[_frames.length - 1] as KFrameData).frame < fData.frame)
				{
					_frames.push(fData);
				}
				else
				{
					for (var i:int = 0; i < _frames.length; ++i)
					{
						if ((_frames[i] as KFrameData).frame > fData.frame)
						{
							_frames.splice(i, 0, fData);
							break;
						}
					}
					
				}
			}
			
			fData.attributes[attrLabel] = value;
		}
		
		/**
		 * 如果目标位置不存在关键帧，则什么也不做。
		 */
		public function removeKeyFrameAttribute(frame:int, attrLabel:String):void
		{
			var fData:KFrameData = null;
			
			for each (var item:KFrameData in _frames)
			{
				if (item.frame == frame)
				{
					fData = item;
					break;
				}
			}
			
			if (fData != null && fData[attrLabel] != null)
			{
				delete fData[attrLabel];
			}
		}
		
		
		/**
		 * 如果目标位置不存在关键帧，则什么也不做。
		 * 如果希望取消插值，则赋值null。
		 */
		public function setKeyFrameInterpolation(frame:int, interpolation:Function):void
		{
			var fData:KFrameData = null;
			
			for each (var item:KFrameData in _frames)
			{
				if (item.frame == frame)
				{
					fData = item;
					break;
				}
			}
			
			if (fData != null)
			{
				fData.interpolation = interpolation;
			}
		}
		
		/**
		 * 如果目标位置不存在关键帧，则什么也不做。
		 */
		public function removeKeyFrame(frame:int):void
		{
			var i:int = 0;
			var pos:int = -1;
			for (i = 0; i < _frames.length; ++i)
			{
				if ((_frames[i] as KFrameData).frame == frame)
				{
					pos = i;
					break;
				}
			}
			if (pos != -1)
			{
				_frames.splice(pos, 1);
			}
		}
		
		public function setKeyFrameEvent(frame:int, event:KTimelineEvent):void
		{
			if (event == null)
			{
				return;
			}
			
			var fData:KFrameData = null;
			
			for each (var item:KFrameData in _frames)
			{
				if (item.frame == frame)
				{
					fData = item;
					break;
				}
			}
			
			if (fData != null)
			{
				fData.events[event.type] = event;
			}
		}
		
		public function removeKeyFrameEvent(frame:int, event:KTimelineEvent):void
		{
			if (event == null)
			{
				return;
			}
			
			var fData:KFrameData = null;
			
			for each (var item:KFrameData in _frames)
			{
				if (item.frame == frame)
				{
					fData = item;
					break;
				}
			}
			
			if (fData != null && fData.events[event.type] != null)
			{
				delete fData.events[event.type];
			}
		}
		
		public function valueAt(frame:int):KDramaPlayerRenderObject
		{
			var f0:KFrameData = null;
			var f1:KFrameData = null;
			
			if (_frames.length == 0)
			{
				return null;
			}
			else if (_frames.length == 1)
			{
				if ((_frames[0] as KFrameData).frame == frame)
				{
					f0 = f1 = _frames[0] as KFrameData;
				}
			}
			else
			{
				for (var i:int = 0; i < _frames.length - 1; ++i)
				{
					if ((_frames[i] as KFrameData).frame <= frame 
						&& (_frames[i+1] as KFrameData).frame >= frame)
					{
						f0 = _frames[i] as KFrameData;
						f1 = _frames[i+1] as KFrameData;
					}
				}
			}
			
			if (f0 == null && f1 == null)
			{
				return null;
			}
			
			var obj:KDramaPlayerRenderObject = new KDramaPlayerRenderObject();
			obj.actorLabel = this.label;
			var kf:KFrameData = null;
			if (f0.frame == frame)
			{
				kf = f0;
			}
			else if (f1.frame == frame)
			{
				kf = f1;
			}
			
			if (kf != null)
			{
				obj.attrDict = kf.attributes;
				obj.evntDict = kf.events;
			}
			else if (f0.interpolation == null)
			{
				obj.attrDict = f0.attributes;
			}
			else
			{
				var attrDict:Dictionary = new Dictionary();
				for (var key:String in f0.attributes)
				{
					var v0:Number = parseFloat(f0.attributes[key]);
					var v1:Number = parseFloat(f1.attributes[key]);
					if (isNaN(v0) || isNaN(v1))
					{
						attrDict[key] = f0.attributes[key];
					}
					else
					{
						var factor:Number = f0.interpolation(f0.frame, f1.frame, frame);
						attrDict[key] = v0 + (v1 - v0) * factor;
					}
				}
				obj.attrDict = attrDict;
			}
			
			return obj;
		}

		public function get type():String
		{
			return _type;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
			// judge the type by extention
			if (value == null)
			{
				_type == "none";
			}
			else
			{
				var ext:String = value.substring(value.lastIndexOf(".") + 1);
				switch(ext)
				{
					case "png":
					case "jpg":
					case "bmp":
					case "gif":
					{
						_type = "image";
						break;
					}
						
					case "swf":
					{
						_type = "swf";
						break;
					}
						
					default:
					{
						_type = "none"
						break;
					}
				}
			}
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function get frames():Array
		{
			return _frames;
		}

		public function get length():int
		{
			return (_frames[_frames.length - 1] as KFrameData).frame + 1;
		}


	}
}