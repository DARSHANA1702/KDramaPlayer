package ks.dramaplayer.present
{
	public interface IKActor
	{
		function render(obj:KDramaPlayerRenderObject):void;
		
		function play():void;
		
		function stop():void;
		
		function goto(frame:int):void;
		
		function next():void;
		
		function prev():void;
	}
}