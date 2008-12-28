//////////////////////////////////////////////////////////////////////////
//  Layers
//
//  Created by Benjamin Wiederkehr on 081228.
//  Copyright (c) 2008 Benjamin Wiederkehr / Artillery.ch. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
package ch.artillery.map{
	//--------------------------------------
	// IMPORT
	//--------------------------------------
	import com.modestmaps.Map;
	import com.modestmaps.events.MapEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 *	Layers Class
	 *
	 */
	public class Layers extends Sprite{
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		private var map								:Map;
		private var starting					:Point;
		private var coordinates				:Array;
		private var params						:Array;
		public var points							:Array;
		public var layers							:Array;
		/**
		*	@Constructor
		*/
		public function Layers(_dc:DocumentClass, _map:Map, _coordinates:Array, _params:Array){
			//  DEFINITIONS
			//--------------------------------------
			this.map						= _map;
			this.coordinates		= _coordinates;
			this.params					= _params;
			this.points					= new Array();
			this.layers					= new Array();
			//  ADDINGS
			//--------------------------------------
			this.x 									= map.getWidth() / 2;
			this.y 									= map.getHeight() / 2;
			//  LISTENERS
			//--------------------------------------			
			this.addEventListener(MouseEvent.MOUSE_DOWN, map.grid.mousePressed, true);
			this.addEventListener(MouseEvent.MOUSE_UP, map.grid.mouseReleased);
			this.map.addEventListener(MapEvent.START_ZOOMING, onMapStartZooming);
			this.map.addEventListener(MapEvent.STOP_ZOOMING, onMapStopZooming);
			this.map.addEventListener(MapEvent.ZOOMED_BY, onMapZoomedBy);
			this.map.addEventListener(MapEvent.START_PANNING, onMapStartPanning);
			this.map.addEventListener(MapEvent.STOP_PANNING, onMapStopPanning);
			this.map.addEventListener(MapEvent.PANNED, onMapPanned);
			//  CALLS
			//--------------------------------------
			setCoordinates();
			setLayers();
		}
		private function setCoordinates():void{
			var p:Point;
			for (var i:int = 0; i < coordinates.length; i++) {
				p = map.locationPoint(coordinates[i], this);
				points[i] = p;
			};
		} // END setCoordinates()
		private function setLayers():void{
			for (var i:int = 0; i < params.length; i++){
				var layer:Layer = new Layer(i, this, params[i].klasse);
				this.addChild(layer);
				layer.x				= points[0].x;
				layer.y				= points[0].y;
				layer.width		= points[1].x - points[0].x;
				layer.height	= points[1].y - points[0].y;
				layers.push(layer);
			};
		} // END setLayers()
		private function updatePoints():void{
			setCoordinates();
			for (var i:int = 0; i < layers.length; i++) {
				layers[i].x				= points[0].x;
				layers[i].y				= points[0].y;
				layers[i].width		= points[1].x - points[0].x;
				layers[i].height	= points[1].y - points[0].y;
			};
		} // END updatePoints()
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function toggleLayers(_e:MouseEvent):void{
			for (var j:int = 0; j < layers.length; j++) {
				layers[j].toggle();
			};
		} // END toggleLayers()
		public function updateLayer(_layer):void{
			_layer.x				= points[0].x;
			_layer.y				= points[0].y;
			_layer.width		= points[1].x - points[0].x;
			_layer.height		= points[1].y - points[0].y;
		} // END updateLayer()
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function onMapStartZooming(event:MapEvent):void{
			toggleLayers();
		} // END onMapStartZooming()
		private function onMapStopZooming(event:MapEvent):void{
			toggleLayers();
			updatePoints();
		} // END onMapStopZooming()
		private function onMapZoomedBy(event:MapEvent):void{
		} // END onMapZoomedBy()
		private function onMapStartPanning(event:MapEvent):void{
			starting = new Point(this.x, this.y);
		} // END onMapStartPanning()
		private function onMapPanned(event:MapEvent):void{
			if (starting) {
				this.x = starting.x + event.panDelta.x;
				this.y = starting.y + event.panDelta.y;
			}else{
				this.x = event.panDelta.x;
				this.y = event.panDelta.y;
			};
		} // END onMapPanned()
		private function onMapStopPanning(event:MapEvent):void{
		} // END onMapStopPanning()
		private function onExtentChanged(event:MapEvent):void{
			updatePoints();
		} // END onExtentChanged()
		private function onMapResized(event:MapEvent):void{
			this.x = event.newSize[0]/2;
			this.y = event.newSize[1]/2;
			updatePoints();
		} // END onMapResized()
	} // END Layers
} // END package ch.artillery.map