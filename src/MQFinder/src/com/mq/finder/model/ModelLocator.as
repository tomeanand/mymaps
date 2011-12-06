package com.mq.finder.model
{
	import com.mapquest.LatLngCollection;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.tilemap.TilemapComponent;
	import com.mq.finder.vo.BusinessListVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;

	[Bidnable]
	public class ModelLocator
	{
		private static var _instance:ModelLocator;
		public var myGod : String = "OMGS!";
		public var map:TilemapComponent;
		public var searchResults:ArrayCollection;
		public var selectedLocation:GeocoderLocation;
		public var routeLatlngCollection:LatLngCollection;
		public var isDirectionInitialised:Boolean = false;
		
		
		public static function getInstance():ModelLocator	{
			if(_instance == null)	{
				_instance = new ModelLocator();
			}
			return _instance;
		}
		public function refreshSearchResults(buVO:BusinessListVO):void	{
			var cursor:IViewCursor = searchResults.createCursor();
			var businessVO:BusinessListVO
			while(!cursor.afterLast)	{
				businessVO = cursor.current as BusinessListVO;
				if(businessVO.businessCategory.category == buVO.businessCategory.category)	{
					businessVO = buVO;
				}
			}
		}

		public function removeShapeCollection(id:String):void	{
			var cursor:IViewCursor = searchResults.createCursor();
			var businessVO:BusinessListVO
			while(!cursor.afterLast)	{
				businessVO = cursor.current as BusinessListVO;
				if(businessVO.businessCategory.category == id)	{
					cursor.remove();
				}
				cursor.moveNext();
			}
		}
	}
}