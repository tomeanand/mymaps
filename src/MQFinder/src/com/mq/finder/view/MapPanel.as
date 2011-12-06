package com.mq.finder.view
{
	import com.mapquest.LatLng;
	import com.mapquest.tilemap.MapCorner;
	import com.mapquest.tilemap.MapCornerPlacement;
	import com.mapquest.tilemap.Size;
	import com.mapquest.tilemap.TilemapComponent;
	import com.mapquest.tilemap.controls.oceanbreeze.OBViewControl;
	import com.mapquest.tilemap.controls.shadymeadow.SMLargeZoomControl;
	import com.mapquest.tilemap.controls.shadymeadow.SMZoomControl;
	import com.mapquest.tilemap.controls.standard.ZoomBarControl;
	import com.mapquest.tilemap.controls.standard.ZoomControl;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.model.ModelLocator;
	import com.mq.finder.utils.MQFConstants;
	
	import mx.core.UIComponent;
	import mx.skins.halo.WindowBackground;
	
	import spark.effects.Resize;

	public class MapPanel extends UIComponent
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var map:TilemapComponent;
		private var resizer:Resize = new Resize(this);

		public function MapPanel()
		{
			super();
		}
		
		public override function initialize():void	{
			super.initialize();
			MapManager.getInstance().addEventListener(MQFConstants.EVENT_RESIZEMAP,mapResizeHandler);
			
			map = new TilemapComponent();
			map.key = MQFConstants.MAP_KEY;
			map.setActualSize(this.width,this.height);
			this.addChild(map);
			this.map.setCenter(new LatLng(34.0522,-118.242798),8);
			model.map = this.map;
			var zoom:SMLargeZoomControl = new SMLargeZoomControl();
			zoom.symbolColor =0xffffff;
			zoom.highContrastBorderColor = 0xFFFFFF;
			zoom.baseColor = 0x7BAA31;
			zoom.position = new MapCornerPlacement(MapCorner.TOP_RIGHT,new Size(20,40));
			this.map.addControl(zoom);
			
		}
		
		
		
		
		
		private function mapResizeHandler(event:MQFinderEvent):void	{
			if(!event.data)	{
				map.setActualSize(this.width+350,this.height);
			}
			else	{
				map.setActualSize(this.width-350,this.height);
			}
		}
	}
}