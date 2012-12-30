package ks.dramaplayer.present
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.LoaderContext;

	public class KSWFActor extends KActor
	{
		private var _loader:Loader = new Loader();
		private var _file:File = null;
		private var _mc:MovieClip = null;
		
		public function KSWFActor(player:KDramaPlayer)
		{
			super(player);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		override public function set source(value:String):void
		{
			super.source = value;
			_file = new File(value);
			_file.addEventListener(Event.COMPLETE, onFileComplete);
			_file.load();
		}
		
		override public function render(obj:KDramaPlayerRenderObject):void
		{
			super.render(obj);
			if (playing)
			{
				if (_mc.currentFrame >= _mc.framesLoaded - 1)
				{
					_mc.gotoAndStop(1);
				}
				else
				{
					_mc.nextFrame();
				}
			}
		}
		
		override public function goto(frame:int):void
		{
			super.goto(frame);
			if (_mc != null)
			{
				_mc.gotoAndStop(frame + 1);
			}
		}
		
		override public function get currentFrame():int
		{
			if (_mc != null)
			{
				return _mc.currentFrame - 1;
			}
			return super.currentFrame;
		}
		
		override public function get length():int
		{
			if (_mc != null)
			{
				return _mc.framesLoaded;
			}
			return super.length;
		}
		
		
		private function onFileComplete(event:Event):void
		{
			var lc:LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			_loader.loadBytes(_file.data, lc);
			_file.removeEventListener(Event.COMPLETE, onFileComplete);
		}
		
		private function onLoadComplete(event:Event):void
		{
			_mc = MovieClip(_loader.content);
			removeChildren();
			addChild(_mc);
		}
		
	}
}