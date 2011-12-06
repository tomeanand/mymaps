package com.mq.finder.processors
{
	import com.mapquest.LatLng;
	import com.mapquest.services.geocode.Geocoder;
	import com.mapquest.services.geocode.GeocoderEvent;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.services.geocode.GeocoderResponse;
	import com.mapquest.services.search.Search;
	import com.mapquest.services.search.SearchEvent;
	import com.mapquest.services.search.SearchHostedData;
	import com.mapquest.services.search.SearchRequestCorridor;
	import com.mapquest.services.search.SearchRequestRadius;
	import com.mapquest.services.search.SearchResponseCorridor;
	import com.mapquest.services.search.SearchResponseRadius;
	import com.mapquest.tilemap.ShapeCollection;
	import com.mapquest.tilemap.pois.ImageMapIcon;
	import com.mapquest.tilemap.pois.Poi;
	import com.mapquest.tilemap.pois.StarMapIcon;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	import com.mq.finder.view.InfoBubbleWindow;
	import com.mq.finder.vo.BusinessCategoryVO;
	import com.mq.finder.vo.BusinessListVO;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;

	public class BusinessSearch implements IEventDispatcher
	{
		private var search:Search;
		private var geoCoder:Geocoder;
		private var poiCollection:ShapeCollection;
		private var resultId:int = 0;
		private var searchMode:String = "";
		
		private var selectedBusiness:BusinessCategoryVO;
		private var selectedLocation:GeocoderLocation;
		private var listToRefresh:BusinessListVO;
		
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function BusinessSearch()
		{
			initialize();
		}
		
		private function initialize():void	{
			search = new Search(MQFConstants.MAP_KEY);
			geoCoder = new Geocoder(MQFConstants.MAP_KEY);
			
			this.search.addEventListener(SearchEvent.SEARCH_RESPONSE, onSearchSuccess);
			this.search.addEventListener(SearchEvent.SEARCH_ERROR_EVENT, onSearchError);
			this.search.addEventListener(SearchEvent.HTTP_ERROR_EVENT, onSearchHttpError);
			
			this.geoCoder.addEventListener(GeocoderEvent.GEOCODE_RESPONSE, onGeocodeSuccess);
			this.geoCoder.addEventListener(GeocoderEvent.REVERSE_GEOCODE_RESPONSE, onReverseGeocodeSuccess);
			this.geoCoder.addEventListener(GeocoderEvent.GEOCODE_ERROR_EVENT, onGeocodeError);
			this.geoCoder.addEventListener(GeocoderEvent.HTTP_ERROR_EVENT, onGeocodeHttpError);
			
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_BLOCATOR_SELECTED,businessSelectHandler);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_SEARCH_ADDR,searchNearLocation);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_REFRESH_BLOCATOR,refreshBusinessSearch);
			
			model.searchResults = new ArrayCollection();
			
		}
		
		private function onSearchSuccess(event:SearchEvent):void	{
			var poi:Poi 
			switch(this.searchMode)	{
				case MQFConstants.GEO_MODE_BUSINESS :
					if(event.searchResponse.resultsCount>0)	{
						if(event.searchResponse is SearchResponseRadius)	{
							var businessList:BusinessListVO = createBusinessListVO(event.searchResponse.pois);
							model.searchResults.addItem(businessList);
							MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_CREATE_TAB,businessList));
							removePois()
							model.map.addShapeCollection(businessList.shapeCollection);
							resultId ++;
							poi = event.searchResponse.pois[0] as Poi
							model.map.setCenter(poi.latLng,selectedBusiness.zoom);
							
						}
					}
					break
				
				case MQFConstants.GEO_MODE_BUSINESS_REFRESH :
					if(event.searchResponse.resultsCount>0)	{
						if(event.searchResponse is SearchResponseRadius)	{
							var freshList:BusinessListVO = createBusinessListVO(event.searchResponse.pois,true);
							//model.searchResults.addItem(businessList);
							MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_REFRESH_TABS,freshList));
							removePois()
							model.map.addShapeCollection(freshList.shapeCollection);
							resultId ++;
							poi = event.searchResponse.pois[0] as Poi
							model.map.setCenter(poi.latLng,selectedBusiness.zoom);
						}
					}
					
					break;
				
				case MQFConstants.GEO_MODE_CORRIDOR_SEARCH :
					
					if(event.searchResponse.resultsCount>0)	{
						if(event.searchResponse is SearchResponseCorridor)	{
							var businessList:BusinessListVO = createBusinessListVO(event.searchResponse.pois);
							model.searchResults.addItem(businessList);
							MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_CREATE_TAB,businessList));
							removePois()
							model.map.addShapeCollection(businessList.shapeCollection);
							resultId ++;
							poi = event.searchResponse.pois[0] as Poi
							model.map.setCenter(poi.latLng,selectedBusiness.zoom);
							
						}
					}
					break;
				
			}
		}
		private function onSearchError(event:SearchEvent):void	{
			
		}
		private function onSearchHttpError(event:SearchEvent):void	{
			
		}
		private function onGeocodeSuccess(event:GeocoderEvent):void	{
			if(event.geocoderResponse.locations.length > 1)	{
				
			}
			else if(event.geocoderResponse.locations.length == 1)	{
				var geoLocation:GeocoderLocation = event.geocoderResponse.locations[0] as GeocoderLocation;
				model.selectedLocation = geoLocation;
				selectedLocation = geoLocation;
				model.map.setCenter(geoLocation.displayLatLng);
				// send a notification to infopanel to refresh exisitng 
				//display of information (there it look for the current panel and refreshs it)
				MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_CHECK_SEARCH_CONTEXT,geoLocation));
			}
			else	{
				
			}
		}
		private function onReverseGeocodeSuccess(event:GeocoderEvent):void	{
			var locations:Array = event.geocoderResponse.locations;
			if(locations.length > 0)	{
				selectedLocation = locations[0] as GeocoderLocation;
				model.selectedLocation = selectedLocation;
				this.doBusinessSearch(geoLocationToString(selectedLocation,false));
			}
		}
		private function onGeocodeError(event:GeocoderEvent):void	{
			
		}
		private function onGeocodeHttpError(event:GeocoderEvent):void	{
			
		}
		
		
		/**
		 * 
		 * 
		 * */
		private function businessSelectHandler(event:MQFinderEvent):void	{
			selectedBusiness = event.data as BusinessCategoryVO;
			if(!model.isDirectionInitialised)	{
				searchMode = MQFConstants.GEO_MODE_BUSINESS;
				geoCoder.reverseGeocode(model.map.center);
			}
			else	{
				searchMode = MQFConstants.GEO_MODE_CORRIDOR_SEARCH;
				corridorSearch();
			}
		}
		
		private function searchNearLocation(event:MQFinderEvent):void	{
			searchMode = MQFConstants.GEO_MODE_SEARCH;
			geoCoder.geocode(event.data);
		}
		
		private function refreshBusinessSearch(event:MQFinderEvent):void	{
			listToRefresh = event.data as BusinessListVO;
			searchMode = MQFConstants.GEO_MODE_BUSINESS_REFRESH;
			this.doBusinessSearch(geoLocationToString(selectedLocation,false));
		}
		

		
		private function doBusinessSearch(address:String):void	{
			var request:SearchRequestRadius = new SearchRequestRadius(address,MQFConstants.SEARCH_RADIUS);
			request.maxMatches = MQFConstants.SEARCH_MAXMATCHES;
			request.units = Search.UNITS_DRIVE_MILES;
			
			var data:SearchHostedData = new SearchHostedData();
			var criteria:Number = (searchMode == MQFConstants.GEO_MODE_BUSINESS ? selectedBusiness.id : listToRefresh.businessCategory.id)
			data.name = "MQA.NTPois";
			data.extraCriteria = "T = "+criteria;
			request.hostedDataList = [data];
			search.search(request);
		}
		
		private function corridorSearch():void	{
			var crequest:SearchRequestCorridor = new SearchRequestCorridor();
			crequest.line = model.routeLatlngCollection;
			crequest.maxMatches = MQFConstants.SEARCH_MAXMATCHES;
			
			var data:SearchHostedData =  new SearchHostedData();
			data.name = "MQA.PBLNA";//"MQA.NTPois"//;
			data.extraCriteria = "T = "+selectedBusiness.id;
			crequest.hostedDataList = [data];
			
			
			crequest.width = .5;
			crequest.bufferedWidth = .25;
			
			search.search(crequest);
		}
		
		private function createBusinessListVO(poiResponse:Array,isRefresh:Boolean = false):BusinessListVO	{
			var busCatVO:BusinessCategoryVO = (!isRefresh ? selectedBusiness : listToRefresh.businessCategory);

			var poiResponse:Array = poiResponse;
			var businessList:BusinessListVO;
			var poiCollection:ShapeCollection = new ShapeCollection();
			poiCollection.name = "MQFinder_"+busCatVO.category;
			var info:InfoBubbleWindow;
			var content:String;
			var latLng:LatLng;
			for(var i:int =0; i<poiResponse.length; i++)	{
				var poi:Poi = poiResponse[i];
				poi.icon = new StarMapIcon(29,busCatVO.color);
				content = poi.infoContent as String;
				latLng = poi.latLng;
				info = new InfoBubbleWindow(model.map.tileMap,content,latLng);
				poi.infoContent = info
				
				poiCollection.add(poi);
			}
			
			businessList = new BusinessListVO(resultId,busCatVO,poiResponse,poiCollection.name,model.map.center);
			businessList.shapeCollection = poiCollection;
			
			return businessList
		}
		
		private function removePois():void	{
			var poiList:ArrayCollection = model.searchResults;
			var cursor:IViewCursor = poiList.createCursor();
			var resultVO:BusinessListVO;
			while(!cursor.afterLast)	{
				resultVO = cursor.current as BusinessListVO;
				model.map.removeShapeCollection(model.map.getShapeCollection(resultVO.shapeCollectionId));
				cursor.moveNext();
			}
		}
		private function geoLocationToString(g:GeocoderLocation, singleLine:Boolean = false):String {
			var addressString:String = "";
			if(g.street) addressString += g.street;
			if(!singleLine) addressString += "\n";
			var spacer:Boolean = false;
			if(g.city){
				addressString += g.city;
				spacer = true;
			}
			if(g.state){
				if(spacer){
					addressString += ", ";
				}
				addressString += g.state;	
				spacer = true;
			}
			if(g.postalCode){
				if(spacer){
					addressString += " ";	
				}
				addressString += g.postalCode;	
				spacer = true;
			}
			return addressString;
		}
		
		/**
		 * 
		 * 
		 * */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}