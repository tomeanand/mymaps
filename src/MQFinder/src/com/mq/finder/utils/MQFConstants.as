package com.mq.finder.utils
{
	public class MQFConstants
	{
		public static const MAP_KEY : String = "Dmjtd|lu612007nq%2C20%3Do5-50zah";
		
		public static const EVENT_RESIZEMAP : String = "ResizeMap";
		public static const EVENT_BLOCATOR_SELECTED : String = "BusinessLocatorSelected";
		public static const EVENT_BLOCATOR_REMOVE : String = "BusinessLocatorRemove";
		public static const EVENT_CREATE_TAB : String = "CreateTab";
		public static const EVENT_DELETE_TAB : String = "DeleteTab";
		
		public static const EVENT_REFRESH_BLOCATOR: String = "RefreshBusinessSearch";
		public static const EVENT_REFRESH_TABS: String = "RefreshTabs";

		public static const EVENT_SEARCH_ADDR: String = "SearchAddress";
		public static const EVENT_CHECK_SEARCH_CONTEXT: String = "EventCheckSearchContext";
		
		public static const EVENT_DIRECTION_GEOCODE: String = "EventDirectionGeocode";
		
		public static const EVENT_SHOW_DIRECTION: String = "EventShowDirection";
		public static const EVENT_DELETE_DIRECTIONS_TAB: String = "RemoveDirectionsTab";
		
		public static const SEARCH_RADIUS : Number = 25;
		public static const SEARCH_MAXMATCHES : Number = 30;
		
		public static const GEO_MODE_SEARCH : String = "GeoSearch";
		public static const GEO_MODE_BUSINESS : String = "GeoBusiness";
		public static const GEO_MODE_BUSINESS_REFRESH : String = "GeoBusinessReresh";
		public static const GEO_MODE_CORRIDOR_SEARCH : String = "SearchCorridor";
		
		public static const GEO_MODE_TRAFFIC : String = "GeoTraffic";
		public static const GEO_MODE_POIS : String = "GeoPoi";
		
		public static const MODE_SEARCH :String = "SearchMode";
		public static const MODE_ROUTE :String = "RouteMode";
		
			
		[Embed (source="assets/images/mqlogo.jpg")] public static const  IMG_LOGO:Class;
		[Embed (source="assets/images/dock_open.png")] public static const  IMG_DOCOPEN:Class;
		[Embed (source="assets/images/dock_close.png")] public static const  IMG_DOCCLOSE:Class;
		
		[Embed (source="assets/images/b_bwestern.png")] public static const  IMG_BESTWESTERN:Class;
		[Embed (source="assets/images/b_airport.png")] public static const  IMG_AIRPORT:Class;
		[Embed (source="assets/images/b_cinn.png")] public static const  IMG_COMFINN:Class;
		[Embed (source="assets/images/b_restaurant.png")] public static const  IMG_RESTAURANT:Class;
		[Embed (source="assets/images/b_hotel.png")] public static const  IMG_HOTEL:Class;
		[Embed (source="assets/images/b_movies.png")] public static const  IMG_MOVIES:Class;
		[Embed (source="assets/images/b_postoffice.png")] public static const  IMG_POSTOFFICE:Class;
		[Embed (source="assets/images/b_dcleaners.png")] public static const  IMG_DCLEAN:Class;
		[Embed (source="assets/images/b_coffee.png")] public static const  IMG_COFFEE:Class;
		
		[Embed (source="assets/images/b_shopping.png")] public static const  IMG_SHOPPING:Class;
		[Embed (source="assets/images/b_atm.png")] public static const  IMG_ATM:Class;
		[Embed (source="assets/images/b_bar.png")] public static const  IMG_BAR:Class;
		[Embed (source="assets/images/b_golf.png")] public static const  IMG_GOLF:Class;
		[Embed (source="assets/images/b_hospital.png")] public static const  IMG_HOSPITAL:Class;
		[Embed (source="assets/images/b_park.png")] public static const  IMG_PARK:Class;

		[Embed (source="assets/images/c_airport.jpg")] public static const  IMG_SELCTD_AIRPORT:Class;
		[Embed (source="assets/images/c_movies.jpg")] public static const  IMG_SELCTD_MOVIES:Class;
		[Embed (source="assets/images/c_restaurant.jpg")] public static const  IMG_SELCTD_RESTAURANT:Class;
		[Embed (source="assets/images/c_atm.jpg")] public static const  IMG_SELCTD_ATM:Class;
		[Embed (source="assets/images/c_bar.jpg")] public static const  IMG_SELCTD_BAR:Class;
		[Embed (source="assets/images/c_hospital.jpg")] public static const  IMG_SELCTD_HOSPITAL:Class;
		[Embed (source="assets/images/c_golf.jpg")] public static const  IMG_SELCTD_GOLF:Class;
		[Embed (source="assets/images/c_park.jpg")] public static const  IMG_SELCTD_PARK:Class;
		
		// skin the tabs and remove the selected property 
		
		public static const BIZ_LOCATOR_LIST : Array = new Array(
			{name:"Airport", selected:IMG_SELCTD_AIRPORT, img:IMG_AIRPORT ,color:0x8543AF,id:3010,zoom:8},
			/*{name:"Rest Area", selected:"", img:IMG_HOTEL ,color:0xD53638,id:3030},*/
			{name:"Cinema", selected:IMG_SELCTD_MOVIES, img:IMG_MOVIES ,color:0xF12BA9,id:3029,zoom:8},
			{name:"Restaurant", selected:IMG_SELCTD_RESTAURANT, img:IMG_RESTAURANT ,color:0xFF8A00,id:3016,zoom:12},
			{name:"ATM", selected:IMG_SELCTD_ATM, img:IMG_ATM ,color:0x659B18,id:3002,zoom:12},
			{name:"Winery", selected:IMG_SELCTD_BAR, img:IMG_BAR,color:0x006968,id:3001,zoom:9},
			{name:"Hospital", selected:IMG_SELCTD_HOSPITAL, img:IMG_HOSPITAL ,color:0xBA4CFF,id:3043,zoom:9},
			{name:"Golf Course", selected:IMG_SELCTD_GOLF, img:IMG_GOLF ,color:0x4DBF55,id:3037,zoom:8},
			{name:"Park &amp; Ride", selected:IMG_SELCTD_PARK, img:IMG_PARK,color:0x01BAFF,id:3027,zoom:8}
		);
		
		
	}
}