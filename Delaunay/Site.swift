import Foundation

public final class Site:ICoord{
//		private static var pool:[Site] = [Site]();
//		public static func create(p:CGPoint, index:Int, weight:CGFloat, color:uint):Site
//		{
//			if (_pool.length > 0)
//			{
//				return _pool.pop().init(p, index, weight, color);
//			}
//			else
//			{
//				return new Site(PrivateConstructorEnforcer, p, index, weight, color);
//			}
//		}
//		
//		internal static func sortSites(sites:[Site>)
//		{
//			sites.sort(Site.compare);
//		}
//
//		/**
//		 * sort sites on y, then x, coord
//		 * also change each site's _siteIndex to match its new position in the list
//		 * so the _siteIndex can be used to identify the site for nearest-neighbor queries
//		 * 
//		 * haha "also" - means more than one responsibility...
//		 * 
//		 */
//		private static func compare(s1:Site, s2:Site):CGFloat
//		{
//			var returnValue:Int = Voronoi.compareByYThenX(s1, s2);
//			
//			// swap _siteIndex values if necessary to match new ordering:
//			var tempIndex:Int;
//			if (returnValue == -1)
//			{
//				if (s1._siteIndex > s2._siteIndex)
//				{
//					tempIndex = s1._siteIndex;
//					s1._siteIndex = s2._siteIndex;
//					s2._siteIndex = tempIndex;
//				}
//			}
//			else if (returnValue == 1)
//			{
//				if (s2._siteIndex > s1._siteIndex)
//				{
//					tempIndex = s2._siteIndex;
//					s2._siteIndex = s1._siteIndex;
//					s1._siteIndex = tempIndex;
//				}
//				
//			}
//			
//			return returnValue;
//		}
//
//
//		private static const EPSILON:CGFloat = .005;
//		private static func closeEnough(p0:CGPoint, p1:CGPoint)->Bool
//		{
//			return Point.distance(p0, p1) < EPSILON;
//		}
//				
		public var coord:CGPoint = CGPoint.zeroPoint;
//		public func get coord()->Point
//		{
//			return _coord;
//		}
//		
//		internal var color:uint;
//		internal var weight:CGFloat;
//		
//		private var _siteIndex:uint;
//		
		// the edges that define this Site's Voronoi region:
		private var edges:[Edge] = [Edge]();
    
		// which end of each edge hooks up with the previous edge in _edges:
		private var edgeOrientations = [LR]();
		// ordered list of points that define the region clipped to bounds:
		private var region = [CGPoint]();
//
//		public func Site(lock:Class, p:CGPoint, index:Int, weight:CGFloat, color:uint)
//		{
//			if (lock != PrivateConstructorEnforcer)
//			{
//				throw new Error("Site constructor is private");
//			}
//			init(p, index, weight, color);
//		}
//		
//		private func init(p:CGPoint, index:Int, weight:CGFloat, color:uint):Site
//		{
//			_coord = p;
//			_siteIndex = index;
//			this.weight = weight;
//			this.color = color;
//			_edges = new [Edge]();
//			_region = nil;
//			return this;
//		}
//		
//		public func toString()->String
//		{
//			return "Site " + _siteIndex + ": " + coord;
//		}
//		
//		private func move(p:CGPoint)
//		{
//			clear();
//			_coord = p;
//		}
//		
//		public func dispose()
//		{
//			_coord = nil;
//			clear();
//			_pool.push(this);
//		}
//		
//		private func clear()
//		{
//			if (_edges)
//			{
//				_edges.length = 0;
//				_edges = nil;
//			}
//			if (_edgeOrientations)
//			{
//				_edgeOrientations.length = 0;
//				_edgeOrientations = nil;
//			}
//			if (_region)
//			{
//				_region.length = 0;
//				_region = nil;
//			}
//		}
//		
        func addEdge(edge:Edge)
		{
			edges.append(edge);
		}
//
//		internal func nearestEdge()->Edge
//		{
//			_edges.sort(Edge.compareSitesDistances);
//			return _edges[0];
//		}
//		
//		internal func neighborSites()->[Site>
//		{
//			if (_edges == nil || _edges.length == 0)
//			{
//				return new [Site>();
//			}
//			if (_edgeOrientations == nil)
//			{ 
//				reorderEdges();
//			}
//			var list:[Site> = new [Site>();
//			var edge:Edge;
//			for each (edge in _edges)
//			{
//				list.push(neighborSite(edge));
//			}
//			return list;
//		}
//			
//		private func neighborSite(edge:Edge):Site
//		{
//			if (this == edge.leftSite)
//			{
//				return edge.rightSite;
//			}
//			if (this == edge.rightSite)
//			{
//				return edge.leftSite;
//			}
//			return nil;
//		}
//		
//		internal func region(clippingBounds:Rectangle):[Point>
//		{
//			if (_edges == nil || _edges.length == 0)
//			{
//				return new [Point>();
//			}
//			if (_edgeOrientations == nil)
//			{ 
//				reorderEdges();
//				_region = clipToBounds(clippingBounds);
//				if ((new Polygon(_region)).winding() == Winding.CLOCKWISE)
//				{
//					_region = _region.reverse();
//				}
//			}
//			return _region;
//		}
//		
//		private func reorderEdges()
//		{
//			//trace("_edges:", _edges);
//			var reorderer:EdgeReorderer = new EdgeReorderer(_edges, Vertex);
//			_edges = reorderer.edges;
//			//trace("reordered:", _edges);
//			_edgeOrientations = reorderer.edgeOrientations;
//			reorderer.dispose();
//		}
//		
//		private func clipToBounds(bounds:Rectangle):[Point>
//		{
//			var points:[Point> = new [Point>;
//			var n:Int = _edges.length;
//			var i:Int = 0;
//			var edge:Edge;
//			while (i < n && ((_edges[i] as Edge).visible == false))
//			{
//				++i;
//			}
//			
//			if (i == n)
//			{
//				// no edges visible
//				return new [Point>();
//			}
//			edge = _edges[i];
//			var orientation:LR = _edgeOrientations[i];
//			points.push(edge.clippedEnds[orientation]);
//			points.push(edge.clippedEnds[LR.other(orientation)]);
//			
//			for (var j:Int = i + 1; j < n; ++j)
//			{
//				edge = _edges[j];
//				if (edge.visible == false)
//				{
//					continue;
//				}
//				connect(points, j, bounds);
//			}
//			// close up the polygon by adding another corner point of the bounds if needed:
//			connect(points, i, bounds, true);
//			
//			return points;
//		}
//		
//		private func connect(points:[Point>, j:Int, bounds:Rectangle, closingUp:Bool = false)
//		{
//			var rightPoint:CGPoint = points[points.length - 1];
//			var newEdge:Edge = _edges[j] as Edge;
//			var newOrientation:LR = _edgeOrientations[j];
//			// the point that  must be connected to rightPoint:
//			var newPoint:CGPoint = newEdge.clippedEnds[newOrientation];
//			if (!closeEnough(rightPoint, newPoint))
//			{
//				// The points do not coincide, so they must have been clipped at the bounds;
//				// see if they are on the same border of the bounds:
//				if (rightPoint.x != newPoint.x
//				&&  rightPoint.y != newPoint.y)
//				{
//					// They are on different borders of the bounds;
//					// insert one or two corners of bounds as needed to hook them up:
//					// (NOTE this will not be correct if the region should take up more than
//					// half of the bounds rect, for then we will have gone the wrong way
//					// around the bounds and included the smaller part rather than the larger)
//					var rightCheck:Int = BoundsCheck.check(rightPoint, bounds);
//					var newCheck:Int = BoundsCheck.check(newPoint, bounds);
//					var px:CGFloat, py:CGFloat;
//					if (rightCheck & BoundsCheck.RIGHT)
//					{
//						px = bounds.right;
//						if (newCheck & BoundsCheck.BOTTOM)
//						{
//							py = bounds.bottom;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.TOP)
//						{
//							py = bounds.top;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.LEFT)
//						{
//							if (rightPoint.y - bounds.y + newPoint.y - bounds.y < bounds.height)
//							{
//								py = bounds.top;
//							}
//							else
//							{
//								py = bounds.bottom;
//							}
//							points.push(new Point(px, py));
//							points.push(new Point(bounds.left, py));
//						}
//					}
//					else if (rightCheck & BoundsCheck.LEFT)
//					{
//						px = bounds.left;
//						if (newCheck & BoundsCheck.BOTTOM)
//						{
//							py = bounds.bottom;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.TOP)
//						{
//							py = bounds.top;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.RIGHT)
//						{
//							if (rightPoint.y - bounds.y + newPoint.y - bounds.y < bounds.height)
//							{
//								py = bounds.top;
//							}
//							else
//							{
//								py = bounds.bottom;
//							}
//							points.push(new Point(px, py));
//							points.push(new Point(bounds.right, py));
//						}
//					}
//					else if (rightCheck & BoundsCheck.TOP)
//					{
//						py = bounds.top;
//						if (newCheck & BoundsCheck.RIGHT)
//						{
//							px = bounds.right;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.LEFT)
//						{
//							px = bounds.left;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.BOTTOM)
//						{
//							if (rightPoint.x - bounds.x + newPoint.x - bounds.x < bounds.width)
//							{
//								px = bounds.left;
//							}
//							else
//							{
//								px = bounds.right;
//							}
//							points.push(new Point(px, py));
//							points.push(new Point(px, bounds.bottom));
//						}
//					}
//					else if (rightCheck & BoundsCheck.BOTTOM)
//					{
//						py = bounds.bottom;
//						if (newCheck & BoundsCheck.RIGHT)
//						{
//							px = bounds.right;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.LEFT)
//						{
//							px = bounds.left;
//							points.push(new Point(px, py));
//						}
//						else if (newCheck & BoundsCheck.TOP)
//						{
//							if (rightPoint.x - bounds.x + newPoint.x - bounds.x < bounds.width)
//							{
//								px = bounds.left;
//							}
//							else
//							{
//								px = bounds.right;
//							}
//							points.push(new Point(px, py));
//							points.push(new Point(px, bounds.top));
//						}
//					}
//				}
//				if (closingUp)
//				{
//					// newEdge's ends have already been added
//					return;
//				}
//				points.push(newPoint);
//			}
//			var newRightPoint:CGPoint = newEdge.clippedEnds[LR.other(newOrientation)];
//			if (!closeEnough(points[0], newRightPoint))
//			{
//				points.push(newRightPoint);
//			}
//		}
//								
        var x:CGFloat
		{
			return coord.x;
		}
        var y:CGFloat{
			return coord.y;
		}

        func dist(p:ICoord)->CGFloat{
			return CGPoint.distance(p.coord, coord);
		}
//
//	}
//}
//
//	class PrivateConstructorEnforcer {}
//
//	import flash.geom.Point;
//	import flash.geom.Rectangle;
//	
//	final class BoundsCheck
//	{
//		public static const TOP:Int = 1;
//		public static const BOTTOM:Int = 2;
//		public static const LEFT:Int = 4;
//		public static const RIGHT:Int = 8;
//		
//		/**
//		 * 
//		 * @param point
//		 * @param bounds
//		 * @return an int with the appropriate bits set if the Point lies on the corresponding bounds lines
//		 * 
//		 */
//		public static func check(point:CGPoint, bounds:Rectangle):Int
//		{
//			var value:Int = 0;
//			if (point.x == bounds.left)
//			{
//				value |= LEFT;
//			}
//			if (point.x == bounds.right)
//			{
//				value |= RIGHT;
//			}
//			if (point.y == bounds.top)
//			{
//				value |= TOP;
//			}
//			if (point.y == bounds.bottom)
//			{
//				value |= BOTTOM;
//			}
//			return value;
//		}
//		
//		public func BoundsCheck()
//		{
//			throw new Error("BoundsCheck constructor unused");
//		}

	}