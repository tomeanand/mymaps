package com.mq.finder.processors
{
	import com.mapquest.LatLng;
	import com.mapquest.LatLngCollection;
	import com.mapquest.services.directions.Directions;
	import com.mapquest.services.directions.DirectionsEvent;
	import com.mapquest.services.directions.DirectionsOptions;
	import com.mapquest.services.geocode.Geocoder;
	import com.mapquest.services.geocode.GeocoderEvent;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.services.geocode.GeocoderOptions;
	import com.mapquest.services.geocode.GeocoderResponse;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	import com.mq.finder.vo.ManeuverVO;
	import com.mq.finder.vo.RouteVO;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class DirectionSearch extends EventDispatcher
	{
		private var directions:Directions;
		private var geoCoder:Geocoder;
		private var locations:Array;
		private var model:ModelLocator = ModelLocator.getInstance();
		private var locationCollection:ArrayCollection;
		private var isInitialised:Boolean = false;
		public function DirectionSearch()
		{
			initialise();
		}
		
		private function initialise():void	{
			
			
			var geoeOption:GeocoderOptions = new GeocoderOptions(6,true,null,true);
			geoCoder = new Geocoder(MQFConstants.MAP_KEY,geoeOption);
			
			directions = new Directions(MQFConstants.MAP_KEY);
			directions.addEventListener(DirectionsEvent.DIRECTIONS_SUCCESS,onDirectionSuccessHandler);
				
			this.geoCoder.addEventListener(GeocoderEvent.GEOCODE_RESPONSE, onGeocodeSuccess);
			this.geoCoder.addEventListener(GeocoderEvent.GEOCODE_ERROR_EVENT, onGeocodeError);
			this.geoCoder.addEventListener(GeocoderEvent.HTTP_ERROR_EVENT, onGeocodeHttpError);
			
			
			
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_DIRECTION_GEOCODE,directionGeocodeHandler);
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_DELETE_DIRECTIONS_TAB,removeDirections);
		} 
		
		private function findRoutes():void	{
			var dirOption:DirectionsOptions = new DirectionsOptions();
			dirOption.narrativeType = "html"; 
			var locationList:Array = [locations[0].displayLatLng,locations[1].displayLatLng];
			if(directions != null)	{
				directions.removeEventListener(DirectionsEvent.DIRECTIONS_SUCCESS,onDirectionSuccessHandler);
				directions.removeRoute()
			}
			
			directions = new Directions(model.map.tileMap,locationList,dirOption);
			directions.addEventListener(DirectionsEvent.DIRECTIONS_SUCCESS,onDirectionSuccessHandler);
			directions.route();
			
		}
		private function onDirectionSuccessHandler(event:DirectionsEvent):void	{
			var manvrList:ArrayCollection = new ArrayCollection();
			var routeVO:RouteVO;
			var streetsStr:String = "";
			var latlng:LatLng
			if(event.type == DirectionsEvent.DIRECTIONS_SUCCESS)	{
				if(event.routeType == "route")	{
					var location:XML = event.locationsXml as XML;
					var locs:XMLList = location.location;
					var street,city:String = "";
					var destOrig:Array = new Array();
					for each(var lc:XML in locs)	{
						street = lc.hasOwnProperty("street") ? lc.street : null;
						city = lc.hasOwnProperty("adminArea5") ? lc.adminArea5 : null;
						destOrig.push((street+", "+city))
					}
					
					
					var route:XML = event.legsXml as XML;
					
					var maneuvers:XMLList = route.leg.maneuvers.maneuver;
					model.routeLatlngCollection = new LatLngCollection();
					for each(var manuervs:XML in maneuvers)	{
						latlng = new LatLng(Number(manuervs.startPoint.lat),Number(manuervs.startPoint.lng));
						streetsStr = ""
						if(manuervs.streets.street.length()>0)	{
							for each(var strt:XML in manuervs.streets.street) {
								streetsStr+= strt+", "; 
							}
						}
						model.routeLatlngCollection.add(latlng);
						var manVO:ManeuverVO = new ManeuverVO(latlng,
							manuervs.distance,
							manuervs.time,
							manuervs.attributes,
							manuervs.turnType,
							manuervs.narrative,
							manuervs.direction,
							manuervs.directionName,
							manuervs.index,
							streetsStr,
							manuervs.iconUrl,
							manuervs.mapUrl);
						manvrList.addItem(manVO);
					}
					routeVO = new RouteVO(route.leg.distance,route.leg.time,route.leg.formattedTime,manvrList,destOrig);
					//model.routeVO = routeVO;
					MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_SHOW_DIRECTION,routeVO));
					
				}
			}
		}
		private function onGeocodeSuccess(event:GeocoderEvent):void	{
			var geoCoderResponse:GeocoderResponse = event.geocoderResponse as GeocoderResponse;
			if(geoCoderResponse.locations.length == 1)	{
				this.locations[1] = geoCoderResponse.locations[0];
				findRoutes()
			}
			else if(geoCoderResponse.locations.length > 1)	{
				locationCollection.addItem(geoCoderResponse.locations);
				this.locations[1] = geoCoderResponse.locations[0];
				findRoutes()
				Alert.show("Multi result, dispatch event to show ambiguities!");
			}
			else	{
				Alert.show("No result");
			}
		}
		private function onGeocodeError(event:GeocoderEvent):void	{
			
		}
		private function onGeocodeHttpError(event:GeocoderEvent):void	{
			
		}
		
		private function directionGeocodeHandler(event:MQFinderEvent):void	{
			this.locations = event.data;
			this.locationCollection = new ArrayCollection();
			this.geoCoder.geocode(this.locations[1]);
		}
		
		private function removeDirections(event:MQFinderEvent):void	{
			this.directions.removeRoute();
		}
		
	}
}