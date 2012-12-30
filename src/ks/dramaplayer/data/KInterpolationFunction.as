package ks.dramaplayer.data
{
	public class KInterpolationFunction
	{
		public static const LINEAR:String = "linear";
		
		private static function linear(t0:Number, t1:Number, t:Number):Number
		{
			return (t - t0) / (t1 - t0);
		}
		
		public static function func(label:String):Function
		{
			switch(label)
			{
				case LINEAR:
				{
					return linear;
				}
					
				default:
				{
					return null;
				}
			}
		}
	}
}