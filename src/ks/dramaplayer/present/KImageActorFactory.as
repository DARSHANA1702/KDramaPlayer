package ks.dramaplayer.present
{
	public class KImageActorFactory extends KActorFactory
	{
		public function KImageActorFactory(player:KDramaPlayer)
		{
			super(player);
		}
		
		override public function create(source:String):KActor
		{
			var actor:KImageActor = new KImageActor(player);
			actor.source = source;
			return actor;
		}
		
		override public function get type():String
		{
			return "image";
		}
	}
}