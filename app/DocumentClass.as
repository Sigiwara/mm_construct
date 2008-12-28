//////////////////////////////////////////////////////////////////////////
//  Document Class
//
//  Created by Benjamin Wiederkehr on 081228.
//  Copyright (c) 2008 Benjamin Wiederkehr / Artillery.ch. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
package {
	//--------------------------------------
	// IMPORT
	//--------------------------------------
	import ch.artillery.map.Markers;
	import ch.artillery.map.Layers;
	import ch.artillery.ui.GUI;
	import com.modestmaps.Map;
	import com.modestmaps.TweenMap;
	import com.modestmaps.core.MapExtent;
	import com.modestmaps.geo.Location;
	import com.modestmaps.mapproviders.yahoo.*;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.motion.easing.*;
	//--------------------------------------
	// METADATA
	//--------------------------------------
	[SWF(width="900", height="600", frameRate="32", backgroundColor="#000000")]

	/**
	 *	DocumentClass of the MM_Construct.
	 *
	 *	@langversion		ActionScript 3.0
	 *	@playerversion	Flash 9.0
	 *	@author					Benjamin Wiederkehr
	 *	@since					081228
	 *	@version				0.1
	 */
	public class DocumentClass extends Sprite{
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var map					:Map;
		private var mapEx				:MapExtent;
		private var mapProv			:YahooRoadMapProvider;
		private var origo				:Location;
		private var markers			:Markers;
		private var gui					:GUI;
		private var urlLoader		:URLLoader;
		private var locations		:Array;
		private var waiter			:TextField;
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		private const FONT			:String	= 'Arial';
		private const T_COLOR		:uint		= 0xFFFFFF;
		private const T_SIZE		:uint		= 16;
		/**
		*	@Constructor
		*/
		public function DocumentClass(){
			//  SETTINGS
			//--------------------------------------
			this.stage.scaleMode		= StageScaleMode.NO_SCALE;
			this.stage.quality			= StageQuality.BEST;
			this.stage.align				= StageAlign.TOP_LEFT;
			//  DEFINITIONS
			//--------------------------------------
			locations							= new Array();
			//  LISTENERS
			//--------------------------------------
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeysDown);
			this.stage.addEventListener(Event.RESIZE, onResize);
			//  CALLS
			//--------------------------------------
			setWaiter();
			setMap();
			colorizeMap();
			setGUI();
			loadData('data/locations.xml', onLoadParcells);
		} // END DocumentClass()
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		private function setWaiter():void{
			waiter				= new TextField();
			waiter.text		= 'loading data';
			formatText(waiter, T_COLOR, 60)
			waiter.width	= waiter.textWidth + 10;
			waiter.height	= waiter.textHeight + 10;
			waiter.x			= this.stage.stageWidth / 2 - waiter.textWidth / 2;
			waiter.y			= this.stage.stageHeight / 2 - waiter.textHeight / 2;
			addChild(waiter);
		} // END setWaiter()
		private function setMap():void{
			mapProv	= new YahooRoadMapProvider();
			mapEx		= new MapExtent(47.40, 47.35, 8.70, 8.45);
			map			= new TweenMap(stage.stageWidth, stage.stageHeight, true, mapProv);
			map.x		= 0;
			map.y		= 0;
			map.setExtent(mapEx);
			map.doubleClickEnabled	= true;
			addChild(map);
			origo = map.getCenter();
		} // END setMap()
		private function colorizeMap():void{
			var mat:Array = [
			0.2,0.5,0.1,0,50,
			0.2,0.5,0.1,0,50,
			0.2,0.5,0.1,0,50,
			0,0,0,1,0
			];
			var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
			map.grid.filters = [colorMat];
		} // END colorizeMap()
		private function setMarkers():void{
			markers = new Markers(map, locations);
			map.addChild(markers);
		} // END setMarkers()
		private function setGUI():void{
			gui = new GUI(this);
			this.addChild(gui);
		} // END setGUI()
		private function loadData(_xmlPath:String, _callback:Function):void{
			var urlRequest:URLRequest = new URLRequest(_xmlPath);
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, _callback);
			urlLoader.load(urlRequest);
		} // END loadData()
		private function formatText(_tf:TextField, _color = false, _size = false):void {
			var tFormat:TextFormat = new TextFormat();
			tFormat.font		= FONT;
			tFormat.color		= (_color) ? _color : T_COLOR;
			tFormat.size		= (_size) ? _size : T_SIZE;
			_tf.setTextFormat(tFormat);
		} // END onLoadData()
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function onLoadParcells(e:Event):void{
			var xml:XML = new XML(e.target.data);
			for each(var p:* in xml.parcell) {
				locations.push(new Location(p.latitude, p.longitude));
			};
			setMarkers();
		} // END onLoadParcells()
		private function onMouseWheel(e:MouseEvent):void{
			if(e.delta > 0){
				map.zoomIn();
			};
			if(e.delta < 0){
				map.zoomOut();
			};
		} // END onMouseWheel()
		private function onKeysDown(e:KeyboardEvent):void{
			switch (e.keyCode){
				case 32:
				//map.panTo(origo);
				break;
				case 37:
				map.panLeft();
				break;
				case 38:
				map.panUp();
				break;
				case 39:
				map.panRight();
				break;
				case 40:
				map.panDown();
				break;
			}
		} // END onKeyDown()
		private function onResize(e:Event):void{
			gui.layoutAssets();
			map.setSize(stage.stageWidth, stage.stageHeight);
			markers.setSize();
			waiter.x = this.stage.stageWidth / 2 - waiter.textWidth / 2;
			waiter.y = this.stage.stageHeight / 2 - waiter.textHeight / 2;
		} // END onResize();
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function goFullScreen(e:MouseEvent):void{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		} // END goFullScreen();
		public function exitFullScreen(e:MouseEvent):void{
			stage.displayState = StageDisplayState.NORMAL;
		} // END exitFullScreen();
	} // END DocumentClass
} // END package