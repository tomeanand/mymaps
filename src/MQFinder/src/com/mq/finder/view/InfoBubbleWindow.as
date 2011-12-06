package com.mq.finder.view
{
	import com.mapquest.LatLng;
	import com.mapquest.services.geocode.GeocoderLocation;
	import com.mapquest.tilemap.DefaultInfoWindow;
	import com.mapquest.tilemap.TileMap;
	import com.mq.finder.controller.MapManager;
	import com.mq.finder.events.MQFinderEvent;
	import com.mq.finder.utils.MQFConstants;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class InfoBubbleWindow extends DefaultInfoWindow
	{
		private var _contentFieldTextFormat:TextFormat;
		private var _infoString : String;
		private var latlng:LatLng;
		
		private var dirlabel:TextField;
		private var searchlabel:TextField;
		private var mymaplabel:TextField;
		private var searchInput:TextField;
		
		private var fromLbl:TextField;
		private var toLbl:TextField;
		private var searchForLbl:TextField;
		
		private static const LBL_SEARCH : String = "Search Nearby";
		private static const LBL_DIRECTION : String = "Directions";
		private static const LBL_MYMAPS : String = "Save to My Maps";
		
		public var selectedAction:String = "";
		
		private var isActivated:Boolean = false;
		private var tabsItems:Sprite;
		
		public function InfoBubbleWindow(map:TileMap,poiInfoStr:String,latlng:LatLng)
		{
			super(map);
			_infoString =poiInfoStr; 
			this.latlng = latlng;
			makeInfoWindow()
		}
		
		/*
		used to keep constructor thin to increase performance
		*/
		private function makeInfoWindow():void {
			this.makeShadowAndBackground();			
			this.makeTitleBackground();
			this.makeTitleField();			
			this.makeContentField();
			this.moveCloseButtonToTop();
		}
		
		
		
		private function makeShadowAndBackground():void {
			this._shadow = new Shape();
			this._shadow.filters = [new BlurFilter(5, 5)];
			this._bkg = new Shape();
			this.addChild(this._shadow);
			this.addChild(this._bkg);			
		}
		
		private function makeContentFieldTextFormat():void {
			this._contentFieldTextFormat = new TextFormat();
			this._contentFieldTextFormat.font = "Arial";
			this._contentFieldTextFormat.size = 12;
			this._contentFieldTextFormat.color = 0x000000;			
		}
		
		
		private function makeContentField():void {			
			this.makeContentFieldTextFormat();	
			
			this._contentField = new TextField();
			this._contentField.addEventListener(TextEvent.LINK, this.dispatchEvent, false, 0, true);
			this._contentField.setTextFormat(this._contentFieldTextFormat);
			this._contentField.defaultTextFormat = this._contentFieldTextFormat;
			//jfb - if selectable is false it disables mouse click on anchor tag in text field
			this._contentField.selectable = true;
			this._contentField.alwaysShowSelection = true;
			this._contentField.autoSize = TextFieldAutoSize.LEFT;
			this._contentField.wordWrap = true;
			this._contentField.multiline = true;
			this._contentField.x = this._horizontalMargin;
			this._contentField.y = 0;
			this._contentField.backgroundColor = 0x00FF00;
			_contentField.text = _infoString.split("\n\n").join("\n");
			this._contentField.width = 300;
			this._contentField.height = 160;
			this.addChild(this._contentField);
			tabsItems = createTab();
			this.addChild(tabsItems);
			
		}
		
		
		private function makeTitleField():void {
			this._titleField = new TextField();
			this._titleField.addEventListener(TextEvent.LINK, this.dispatchEvent, false, 0, true);
			this._titleField.selectable = true;
			this._titleField.alwaysShowSelection = true;
			this._titleField.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(this._titleField);	
			this.makeTitleFieldTextFormat();		
		}
		private function makeTitleFieldTextFormat():void {
			this._titleFieldTextFormat = new TextFormat();
			this._titleFieldTextFormat.font = "Arial";
			this._titleFieldTextFormat.size = 16;
			this._titleFieldTextFormat.bold = true;
			this._titleField.defaultTextFormat = this._titleFieldTextFormat;
			this._titleField.setTextFormat(this._titleFieldTextFormat);
		}
		
		private function makeTitleBackground():void {
			this._titleBackground = new Sprite();
			var g:Graphics = this._titleBackground.graphics;
			
			if (this._contentField) {
				this._titleBackground.addEventListener(TextEvent.LINK, this.dispatchEvent, false, 0, true);
				//g.drawRect(0, 0, this._contentFieldWidth - (this._closeButton.width * .5), this._closeButton.height);
				g.drawRect(0, 0, 325, 140);
				g.endFill();
				this._titleBackground.x = this._horizontalMargin + this._borderSize;
				this._titleBackground.y = this._verticalMargin + 2 + this._borderSize;
			}
			this.addChild(this._titleBackground);
		}
		
		/*override protected function onClickedClosed(e:MouseEvent):void {
			this.hide();
			this.dispatchEvent(new InfoWindowEvent(InfoWindowEvent.CLICKED_CLOSED));
		}*/
		
		
		private function moveCloseButtonToTop():void {
			this.removeChild(this._closeButton);
			//this.addChild(this._closeButton);	
		}
		
		
		public function getInfoString():String	{
			var address:String =  this._infoString.substring(0,_infoString.indexOf("\n\n"));
			var phone:String = _infoString.substring(_infoString.indexOf("Phone:"),_infoString.length);
			var phoneStr:String = "";
			if(_infoString.indexOf("Phone:") > 0)	{
				phoneStr = phone.substring(0,phone.indexOf("\n"))
			}
			return address+"\n"+phoneStr;
		}
		
		private function createTab():Sprite	{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xEFF7E7,1);
			sp.graphics.lineStyle(1,0xDEE7D6,1);
			sp.graphics.drawRect(10,this._contentField.height+10,this.width-30,25);
			sp.graphics.endFill();
			
			dirlabel = new TextField();
			searchlabel = new TextField();
			mymaplabel = new TextField();
			searchInput = new TextField();
			
			dirlabel.text = LBL_DIRECTION;
			searchlabel.text = LBL_SEARCH;
			mymaplabel.text = LBL_MYMAPS;
			searchInput.text = LBL_MYMAPS;
			applyTextFormat(dirlabel);
			applyTextFormat(searchlabel);
			applyTextFormat(mymaplabel);
			applyInput(searchInput);
			
			dirlabel.y = searchlabel.y = mymaplabel.y = this._contentField.height+13;
			dirlabel.x = 15;
			searchlabel.x = dirlabel.x+dirlabel.width+5;
			mymaplabel.x = searchlabel.x+searchlabel.width+5;
			
			searchInput.y = dirlabel.height+dirlabel.y+25
			searchInput.x = 10;
			

				
			sp.addChild(dirlabel);
			sp.addChild(searchlabel);
			sp.addChild(mymaplabel);
			//sp.addChild(searchInput);
			//sp.addChild(btn);
			//sp.addChild(infoLabel);
			
			//showInfoLabel(3);
			
			return sp;
		}
		
		private function applyTextFormat(txtField:TextField):void	{
			txtField.autoSize = TextFieldAutoSize.LEFT;
			txtField.selectable = false;
			
			txtField.mouseEnabled = true;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.color = 0x009ADE
			txtFormat.size = 12;
			txtField.setTextFormat(txtFormat); 
			txtField.addEventListener(MouseEvent.CLICK,clickEventHandler)
		}
		private function applyInput(txtField:TextField):void	{
			txtField.type = TextFieldType.INPUT;
			txtField.border = true;
			txtField.width = 180;
			txtField.height= 18;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.color = 0x000000
			txtField.borderColor = 0x999999;
			txtFormat.size = 12;
			txtField.setTextFormat(txtFormat); 
		}
		private function highLight(txtField:TextField):void	{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.bold = false;
			txtFormat.color = 0x009ADE
			txtFormat.size = 12;
			dirlabel.setTextFormat(txtFormat); 
			searchlabel.setTextFormat(txtFormat); 
			mymaplabel.setTextFormat(txtFormat); 
			txtFormat.color = 0x000000;
			txtFormat.bold = true;
			txtField.setTextFormat(txtFormat); 

			
		}
		
		private function clickEventHandler(event:MouseEvent):void	{
			if(!isActivated)	{
				activateInfo();
			}
			this.selectedAction = event.target.text;
			this.showInfoLabel()
			highLight(event.target as TextField)
		}
		
		private function createButton():Sprite	{
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x9CCB5A, 0x7BAA31];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, 20, -30, 2, 2);
			var spreadMethod:String = SpreadMethod.PAD;

			var bt:Sprite = new Sprite();
			bt.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			bt.graphics.drawRoundRect(0,0,80,25,10,10);
			bt.mouseEnabled = bt.useHandCursor = bt.buttonMode = true;
			
			var lb:TextField = new TextField();
			lb.text = "Sumbit";
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 12;
			format.color = 0xFFFFFF;
			format.font = "Arial";
			lb.autoSize = TextFieldAutoSize.LEFT;
			lb.selectable = false;
			lb.mouseEnabled = false;
			lb.setTextFormat(format)
			bt.addEventListener(MouseEvent.CLICK,onSumbit);
			bt.addChild(lb);
			lb.y =3;
			lb.x = bt.width/2 - lb.width/2 
			return bt;
		}
		
		private function onSumbit(event:MouseEvent):void	{
			if(selectedAction == LBL_DIRECTION)	{
				var geoLocation:GeocoderLocation = new GeocoderLocation();
				geoLocation.location = this._infoString.substring(0,_infoString.indexOf("\n\n"));
				geoLocation.displayLatLng = latlng;
				var locations:Array = [geoLocation,searchInput.text]
				MapManager.getInstance().dispatchEvent(new MQFinderEvent(MQFConstants.EVENT_DIRECTION_GEOCODE,locations));
			}
			else if(selectedAction == LBL_SEARCH)	{
				
			}
			else	{
				//do nothing
			}
		}
		private function fromToSelectHandler(event:MouseEvent):void	{
			var format:TextFormat = new TextFormat();
			format.color = 0x009ADE;
			format.bold = false
			fromLbl.setTextFormat(format)
			toLbl.setTextFormat(format)
			format.color = 0x000000;
			format.bold = true;
			event.target.setTextFormat(format)
		}
		private function typeDisplay():Sprite	{
			var holder:Sprite = new Sprite();
			fromLbl = new TextField();
			toLbl = new TextField();
			searchForLbl = new TextField();
			
			fromLbl.text = "From";
			toLbl.text = "To";
			searchForLbl.text = "Search For";
			
			applyLabelStyle(fromLbl)
			applyLabelStyle(toLbl)
			applyLabelStyle(searchForLbl)
			toLbl.selectable = fromLbl.selectable = false;
			toLbl.mouseEnabled = fromLbl.mouseEnabled = true;
			
			toLbl.addEventListener(MouseEvent.CLICK,fromToSelectHandler)
			fromLbl.addEventListener(MouseEvent.CLICK,fromToSelectHandler)
			
			searchForLbl.x = 0
			toLbl.x = 0;
			fromLbl.x = toLbl.x+toLbl.width+5;
			
			holder.addChild(this.searchForLbl);
			holder.addChild(this.fromLbl);
			holder.addChild(this.toLbl);
			
			
			
			return holder;
		}
		private function applyLabelStyle(txtField:TextField):void	{
			txtField.autoSize = TextFieldAutoSize.LEFT;
			txtField.selectable = false;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.bold = false;
			txtFormat.color = 0x009ADE
			txtFormat.size = 11;
			txtField.setTextFormat(txtFormat); 
		}
		
		private function showInfoLabel():void	{
			searchForLbl.visible = false;	
			fromLbl.visible = false;	
			toLbl.visible = false;	
			if(this.selectedAction == LBL_DIRECTION)	{
				toLbl.visible = true;	
				fromLbl.visible = true;	
			}
			else if(this.selectedAction == LBL_SEARCH)	{
				searchForLbl.visible = true;	
			}
		}
		
		private function activateInfo():void	{
			var btn:Sprite = createButton();
			btn.x = searchInput.x+searchInput.width+8;
			btn.y = searchInput.y - 3;
			
			var infoLabel:Sprite = typeDisplay();
			infoLabel.y = dirlabel.height+dirlabel.y+5;
			infoLabel.x = 10;
			
			tabsItems.addChild(searchInput);
			tabsItems.addChild(btn);
			tabsItems.addChild(infoLabel);
			
			var format:TextFormat = new TextFormat();
			format.color = 0x00000;
			format.bold = true
			fromLbl.setTextFormat(format)
			format.bold = false;
			format.size = 12;
			format.font = "Arial";
			searchInput.text = "San Diego,CA";
			searchInput.setTextFormat(format)
			
			isActivated = true;
		}
		
		
	}
}