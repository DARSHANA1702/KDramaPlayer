package ks.dramaplayer.present
{
	import flash.net.drm.VoucherAccessInfo;

	public class KActorFactory
	{
		private var _player:KDramaPlayer = null;
		
		public function KActorFactory(player:KDramaPlayer)
		{
			_player = player;
		}
		
		public function create(source:String):KActor
		{
			return new KActor(_player);
		}
		
		public function get type():String
		{
			return "none";
		}

		protected function get player():KDramaPlayer
		{
			return _player;
		}

	}
}