package ks.dramaplayer.tlevent
{
	import ks.dramaplayer.present.IKActor;
	import ks.dramaplayer.present.KDramaPlayer;

	public class KResumeMainEvent extends KTimelineEvent
	{
		
		override public function execute(player:KDramaPlayer, actor:IKActor, frame:int):void
		{
			player.next();
			player.play();
		}
		
		override public function get type():String
		{
			return "resume_main";
		}
		
	}
}