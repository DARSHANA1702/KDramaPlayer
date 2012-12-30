package ks.dramaplayer.tlevent
{
	import ks.dramaplayer.present.IKActor;
	import ks.dramaplayer.present.KDramaPlayer;

	public class KPauseEvent extends KTimelineEvent
	{
		
		override public function execute(player:KDramaPlayer, actor:IKActor, frame:int):void
		{
			actor.stop();
		}
		
		override public function get type():String
		{
			return "pause";
		}
		
	}
}