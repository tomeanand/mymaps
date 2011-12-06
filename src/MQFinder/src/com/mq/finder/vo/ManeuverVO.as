package com.mq.finder.vo
{
	import com.mapquest.LatLng;

	public class ManeuverVO
	{
		public var latlng:LatLng;
		public var distance:String;
		public var time:String;
		public var attribute:String;
		public var turnType:String;
		public var narrative:String;
		public var direction:String;
		public var directionName:String;
		public var index:String;
		public var streets:String;
		public var iconUrl:String;
		public var mapUrl:String;
		public var count:Number
		public function ManeuverVO(latlng:LatLng,distance:String,time:String,
								   attribute:String, trnType:String, narration:String,direction:String,directName:String,
								   index:String, street:String, icon:String, map:String)
		{
			this.latlng = latlng;
			this.distance = distance;
			this.time = time;
			this.attribute =attribute;
			this.turnType = trnType;
			this.narrative = narration;
			this.direction = direction;
			this.index = index;
			this.streets = street;
			this.iconUrl = icon;
			this.mapUrl = map;
			this.count = (Number(index)+1)
		}
	}
}