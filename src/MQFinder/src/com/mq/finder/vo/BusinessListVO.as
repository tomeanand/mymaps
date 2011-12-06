package com.mq.finder.vo
{
	import com.mapquest.LatLng;
	import com.mapquest.tilemap.ShapeCollection;
	

	public class BusinessListVO
	{
		public var list:Array;
		public var id:Number;
		public var businessCategory:BusinessCategoryVO
		public var shapeCollectionId:String;
		private var sc:ShapeCollection;
		public var latLng:LatLng
		
		
		public function BusinessListVO(id:Number, category:BusinessCategoryVO, resultList:Array,sid:String,latLng:LatLng)
		{
			this.id = id;
			this.businessCategory = category;
			this.list = resultList;
			this.shapeCollectionId = sid;
			this.latLng = latLng;
		}
		
		public function set shapeCollection(scollction:ShapeCollection):void	{	this.sc = scollction;	}
		public function get shapeCollection():ShapeCollection	{	return this.sc;	}
	}
}