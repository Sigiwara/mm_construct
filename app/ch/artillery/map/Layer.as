//////////////////////////////////////////////////////////////////////////
//  Layer
//
//  Created by Benjamin Wiederkehr on 081228.
//  Copyright (c) 2008 Benjamin Wiederkehr / Artillery.ch. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
package ch.artillery.map {
	//--------------------------------------
	// IMPORT
	//--------------------------------------
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	/**
	 *	Layer that gets layed over a ModestMap.
	 *
	 *	@langversion		ActionScript 3.0
	 *	@playerversion	Flash 9.0
	 *	@author					Benjamin Wiederkehr
	 *	@since					2008-11-29
	 *	@version				0.1
	 */
	public class Layer extends Sprite {
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		private var layers		:Layers;
		private var path			:String;
		private var overlays	:Array;
		private var layer			:Sprite;
		/**
		 *	@Constructor
		 */
		public function Layer(_index:uint, _layers:Layers, _path:String):void{
			//  DEFINITIONS
			//--------------------------------------
			layers			= _layers;
			path				= _path;
			layer				= new Sprite();
			//  ADDINGS
			//--------------------------------------
			addChild(layer);
			//  CALLS
			//--------------------------------------
			draw();
			loadLayer();
		}
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		private function draw():void{
			layer.graphics.clear();
			layer.graphics.beginFill(0x000000, 0);
			layer.graphics.drawRect(0,0,200,200)
			layer.graphics.endFill();
		} // END draw()
		private function clear():void{
			layer.graphics.clear();
		} // END clear()
		private function loadLayer():void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadedLayer);
			loader.load(new URLRequest(path));
		} // END loadLayers()
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function onloadedLayer(_e:Event):void{
			var overlay:Sprite = new Sprite();
			overlay.addChild(_e.currentTarget.content);
			layer.addChild(overlay);
			layers.updateLayer(this);
		} // END onloadedLayers()
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function toggle():void{
			if(numChildren == 0){
				this.addChild(layer);
			}else{
				this.removeChild(layer);
			};
		} // END toggle()
	} // END Layer Class
} // END package
