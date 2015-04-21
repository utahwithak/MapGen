public final class SiteList:IDisposable
{
//		private var sites:[Site];
//		private var currentIndex:UInt;
//		
//		private var sorted:Bool;
		
//		public func SiteList()
//		{
//			_sites = new [Site>();
//			_sorted = false;
//		}
//		
		public func dispose()
		{
//			if (_sites)
//			{
//				for each (var site:Site in _sites)
//				{
//					site.dispose();
//				}
//				_sites.length = 0;
//				_sites = nil;
//			}
		}
//
//		public func push(site:Site):uint
//		{
//			_sorted = false;
//			return _sites.push(site);
//		}
//		
//		public func get length()->uint
//		{
//			return _sites.length;
//		}
//		
//		public func next()->Site
//		{
//			if (_sorted == false)
//			{
//				throw new Error("SiteList::next()->  sites have not been sorted");
//			}
//			if (_currentIndex < _sites.length)
//			{
//				return _sites[_currentIndex++];
//			}
//			else
//			{
//				return nil;
//			}
//		}
//
//		internal func getSitesBounds()->Rectangle
//		{
//			if (_sorted == false)
//			{
//				Site.sortSites(_sites);
//				_currentIndex = 0;
//				_sorted = true;
//			}
//			var xmin:CGFloat, xmax:CGFloat, ymin:CGFloat, ymax:CGFloat;
//			if (_sites.length == 0)
//			{
//				return new Rectangle(0, 0, 0, 0);
//			}
//			xmin = Number.MAX_VALUE;
//			xmax = Number.MIN_VALUE;
//			for each (var site:Site in _sites)
//			{
//				if (site.x < xmin)
//				{
//					xmin = site.x;
//				}
//				if (site.x > xmax)
//				{
//					xmax = site.x;
//				}
//			}
//			// here's where we assume that the sites have been sorted on y:
//			ymin = _sites[0].y;
//			ymax = _sites[_sites.length - 1].y;
//			
//			return new Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
//		}
//
//		public func siteColors(referenceImage:BitmapData = nil):[uint>
//		{
//			var colors:[uint> = new [uint>();
//			for each (var site:Site in _sites)
//			{
//				colors.push(referenceImage ? referenceImage.getPixel(site.x, site.y) : site.color);
//			}
//			return colors;
//		}
//
//		public func siteCoords()->[Point>
//		{
//			var coords:[Point> = new [Point>();
//			for each (var site:Site in _sites)
//			{
//				coords.push(site.coord);
//			}
//			return coords;
//		}
//
//		/**
//		 * 
//		 * @return the largest circle centered at each site that fits in its region;
//		 * if the region is infinite, return a circle of radius 0.
//		 * 
//		 */
//		public func circles()->[Circle>
//		{
//			var circles:[Circle> = new [Circle>();
//			for each (var site:Site in _sites)
//			{
//				var radius:CGFloat = 0;
//				var nearestEdge:Edge = site.nearestEdge();
//				
//				!nearestEdge.isPartOfConvexHull() && (radius = nearestEdge.sitesDistance() * 0.5);
//				circles.push(new Circle(site.x, site.y, radius));
//			}
//			return circles;
//		}
//
//		public func regions(plotBounds:Rectangle):[[Point>>
//		{
//			var regions:[[Point>> = new [[Point>>();
//			for each (var site:Site in _sites)
//			{
//				regions.push(site.region(plotBounds));
//			}
//			return regions;
//		}
//
//		/**
//		 * 
//		 * @param proximityMap a BitmapData whose regions are filled with the site index values; see PlanePointsCanvas::fillRegions()
//		 * @param x
//		 * @param y
//		 * @return coordinates of nearest Site to (x, y)
//		 * 
//		 */
//		public func nearestSitePoint(proximityMap:BitmapData, x:CGFloat, y:CGFloat):CGPoint
//		{
//			var index:uint = proximityMap.getPixel(x, y);
//			if (index > _sites.length - 1)
//			{
//				return nil;
//			}
//			return _sites[index].coord;
//		}
//		
//	}
}