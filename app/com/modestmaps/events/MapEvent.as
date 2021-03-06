/*
 * $Id$
 */

package com.modestmaps.events
{
	import com.modestmaps.core.MapExtent;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class MapEvent extends Event
	{
	    public static const START_ZOOMING:String = 'startZooming';
	    public static const STOP_ZOOMING:String = 'stopZooming';
		public var zoomLevel:Number;

	    public static const ZOOMED_BY:String = 'zoomedBy';
		public var zoomDelta:Number;
	    
	    public static const START_PANNING:String = 'startPanning';
	    public static const STOP_PANNING:String = 'stopPanning';

	    public static const PANNED:String = 'panned';
		public var panDelta:Point;
	    
	    public static const RESIZED:String = 'resized';
	    public var newSize:Array;
	    	    
	    public static const COPYRIGHT_CHANGED:String = 'copyrightChanged';
	    public var newCopyright:String;

	    public static const BEGIN_EXTENT_CHANGE:String = 'beginExtentChange';
		public var oldExtent:MapExtent;
	    
	    public static const EXTENT_CHANGED:String = 'extentChanged';
		public var newExtent:MapExtent;

	    public static const BEGIN_TILE_LOADING:String = 'beginTileLoading';
	    public static const ALL_TILES_LOADED:String = 'alLTilesLoaded';

		public function MapEvent(type:String, ...rest)
		{
			super(type, true, true);
			
			switch(type) {
				case PANNED:
					if (rest.length > 0 && rest[0] is Point) {
						panDelta = rest[0];
					}
					break;
				case ZOOMED_BY:
					if (rest.length > 0 && rest[0] is Number) {
						zoomDelta = rest[0];
					}
					break;
				case START_ZOOMING:
				case STOP_ZOOMING:
					if (rest.length > 0 && rest[0] is Number) {
						zoomLevel = rest[0];
					}
					break;					
	    		case RESIZED:
	    			if (rest.length > 0 && rest[0] is Array) {
	    				newSize = rest[0];
	    			}
					break	    	    
				case COPYRIGHT_CHANGED:
	    			if (rest.length > 0 && rest[0] is String) {
	    				newCopyright = rest[0];
	    			}
					break;	    	    
				case EXTENT_CHANGED:
	    			if (rest.length > 0 && rest[0] is MapExtent) {
	    				newExtent = rest[0];
	    			}
					break;	    	    
				case BEGIN_EXTENT_CHANGE:
	    			if (rest.length > 0 && rest[0] is MapExtent) {
	    				oldExtent = rest[0];
	    			}
					break;	    	    
			}
			
		}
		
		override public function clone():Event
		{
			return this;
		}
	}
}
