package ks.dramaplayer.present
{
	public class KSWFActorFactory extends KActorFactory
	{
		public function KSWFActorFactory(player:KDramaPlayer)
		{
			super(player);
		}
		
		override public function create(source:String):KActor
		{
			var actor:KSWFActor = new KSWFActor(player);
			actor.source = source;
			return actor;
		}
		
		override public function get type():String
		{
			return "swf";
		}
		
	}
}