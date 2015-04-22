public final class SiteList:IDisposable
{
		private var sites:[Site];
		private var currentIndex:Int = 0;

		private var sorted:Bool;
		
		public init()
		{
			sites = [Site]();
            sorted = false;
		}

		public func dispose()
		{
				for site in sites
				{
					site.dispose();
				}
				sites.removeAll(keepCapacity: true);

		}
//
		public func push(site:Site)->UInt
		{
			sorted = false;
			sites.append(site);
            return UInt(sites.count)
		}

    public var length:Int
    {
        return sites.count
    }
		
		public func next()->Site?
		{
            assert(sorted, "SiteList::next()->  sites have not been sorted")

            if(currentIndex < sites.count)
			{
				return sites[currentIndex++];
			}
			else
			{
				return nil;
			}
		}

		func getSitesBounds()->CGRect
		{
			if (sorted == false)
			{
				Site.sortSites(&sites);
				currentIndex = 0;
				sorted = true;
			}
			var xmin:CGFloat, xmax:CGFloat, ymin:CGFloat, ymax:CGFloat;
			if (sites.count == 0)
			{
				return CGRect(x: 0, y: 0, width: 0, height: 0);
			}
			xmin = CGFloat.max
			xmax = CGFloat.min;
			for site in sites
			{
				if (site.x < xmin)
				{
					xmin = site.x;
				}
				if (site.x > xmax)
				{
					xmax = site.x;
				}
			}
			// here's where we assume that the sites have been sorted on y:
			ymin = sites[0].y;
			ymax = sites[sites.count - 1].y;
			
			return CGRect(x: xmin, y: ymin, width: xmax - xmin, height: ymax - ymin);
		}
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

		public func siteCoords()->[CGPoint]
		{
			var coords:[CGPoint] = [CGPoint]();
			for site in sites{
				coords.append(site.coord);
			}
			return coords;
		}

		/**
		 * 
		 * @return the largest circle centered at each site that fits in its region;
		 * if the region is infinite, return a circle of radius 0.
		 * 
		 */
		public func circles()->[Circle]
		{
			var circles = [Circle]();
            for site in sites{
				var radius:CGFloat = 0;
				var nearestEdge:Edge = site.nearestEdge();
				
                if(!nearestEdge.isPartOfConvexHull()){
                    radius = nearestEdge.sitesDistance() * 0.5;
                }
				circles.append(Circle(centerX: site.x, centerY: site.y, radius: radius));
			}
			return circles;
		}

		public func regions(plotBounds:CGRect)->[[CGPoint]]
		{
			var regions:[[CGPoint]] = [[CGPoint]]();
			for site in sites{
				regions.append(site.region(plotBounds));
			}
			return regions;
		}

//		/**
//		 * 
//		 * @param proximityMap a BitmapData whose regions are filled with the site index values; see PlanePointsCanvas::fillRegions()
//		 * @param x
//		 * @param y
//		 * @return coordinates of nearest Site to (x, y)
//		 * 
//		 */
//		public func nearestSitePoint(proximityMap:BitmapData, x:CGFloat, y:CGFloat)->CGPoint?
//		{
//			var index:uint = proximityMap.getPixel(x, y);
//			if (index > sites.count - 1)
//			{
//				return nil;
//			}
//			return sites[index].coord;
//		}
}