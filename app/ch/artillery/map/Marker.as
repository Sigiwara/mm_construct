//////////////////////////////////////////////////////////////////////////
//  Marker
//
//  Created by Benjamin Wiederkehr on 081228.
//  Copyright (c) 2008 Benjamin Wiederkehr / Artillery.ch. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////
package ch.artillery.map{
	//--------------------------------------
	// IMPORT
	//--------------------------------------
	import gs.TweenLite;
	import flash.display.Sprite;
	/**
	 *	Marker that gets positioned on a ModestMap
	 *
	 */
	public class Marker extends Sprite{
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		private const M_COLOR		:uint		= 0x51BFF7;
		private const M_SIZE		:uint		= 12;
		/**
		*	@Constructor
		*/
		public function Marker(){
		} // END Marker()
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		public function draw():void{
			graphics.beginFill(M_COLOR, 0.75);
			graphics.drawCircle(0, 0, M_SIZE);
		} // END draw()
		public function clear():void{
			this.graphics.clear();
		} // END clear()
	} // END Marker()
}