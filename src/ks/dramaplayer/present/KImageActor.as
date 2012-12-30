package ks.dramaplayer.present
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;

	public class KImageActor extends KActor
	{
		private var _loader:Loader = new Loader();
		private var _file:File = null;
		
		public function KImageActor(player:KDramaPlayer)
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
		
		private function onFileComplete(event:Event):void
		{
			_loader.loadBytes(_file.data);
			_file.removeEventListener(Event.COMPLETE, onFileComplete);
		}
		
		private function onLoadComplete(event:Event):void
		{
			var img:Bitmap = Bitmap(_loader.content);
			removeChildren();
			addChild(img);
		}
		
		
	}
}