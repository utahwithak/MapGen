/*
 * The author of this software is Steven Fortune.  Copyright (c) 1994 by AT&T
 * Bell Laboratories.
 * Permission to use, copy, modify, and distribute this software for any
 * purpose without fee is hereby granted, provided that this entire notice
 * is included in all copies of any software which is or includes a copy
 * or modification of this software and in all copies of the supporting
 * documentation for such software.
 * THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR AT&T MAKE ANY
 * REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
 * OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
 */
	
public class Voronoi
{
	private var sites = SiteList();
    private var sitesIndexedByLocation = [CGPoint:Site]();
    private var triangles = [Triangle]()
    private var edges = [Edge]()

	// TODO generalize this so it doesn't have to be a rectangle;
	// then we can make the fractal voronois-within-voronois
    public var plotBounds:CGRect = CGRect.zeroRect;

		public func dispose()
		{
			var i:Int, n:Int;
            sites.dispose();
            for tri in triangles{
                tri.dispose()
            }
            triangles.removeAll(keepCapacity: true)
            
            for edge in edges{
                edge.dispose()
            }
            
            edges.removeAll(keepCapacity: false)
            plotBounds = CGRect.zeroRect;
			sitesIndexedByLocation.removeAll(keepCapacity: true)
		}
		
		public init(points:[CGPoint], colors:[UInt]?, plotBounds:CGRect)
		{
			addSites(points, colors: colors);
			self.plotBounds = plotBounds;
			fortunesAlgorithm();
		}

		private func addSites(points:[CGPoint], colors:[UInt]?)
		{
			var length = points.count;
			for (var i = 0; i < length; ++i)
			{
				addSite(points[i], color: colors != nil ? colors![i] : 0, index: i);
			}
		}
		
		private func addSite(p:CGPoint, color:UInt, index:Int)
		{
			var weight:CGFloat = CGFloat(random() * 100);
			var site:Site = Site.create(p, index: index, weight: weight, color: color);
			sites.push(site);
			sitesIndexedByLocation[p] = site;
		}

          
		public func region(p:CGPoint)->[CGPoint]
		{
            if let site = sitesIndexedByLocation[p]	{
                return site.region(plotBounds);
			}
            return  [CGPoint]();

		}


    // TODO: bug: if you call this before you call region(), something goes wrong :(
		public func neighborSitesForSite(coord:CGPoint)->[CGPoint]
		{
			var points = [CGPoint]();
			var site = sitesIndexedByLocation[coord];
			if (site == nil)
			{
				return points;
			}
			var sites = site!.neighborSites();
			for neighbor in sites
			{
				points.append(neighbor.coord);
			}
			return points;
		}

		public func circles()->[Circle]
		{
			return sites.circles();
		}

		public func voronoiBoundaryForSite(coord:CGPoint)->[LineSegment]
		{
			return visibleLineSegments(selectEdgesForSitePoint(coord, edges));
		}

		public func delaunayLinesForSite(coord:CGPoint)->[LineSegment]
		{
			return delaunayLinesForEdges(selectEdgesForSitePoint(coord, edges));
		}

		public func voronoiDiagram()->[LineSegment]
		{
			return visibleLineSegments(edges);
		}

		public func delaunayTriangulation(/*keepOutMask:BitmapData = nil*/) -> [LineSegment]
		{
			return delaunayLinesForEdges(selectNonIntersectingEdges(/*keepOutMask,*/ edges));
		}
		
		public func hull()->[LineSegment]
		{
			return delaunayLinesForEdges(hullEdges());
		}
		
		private func hullEdges()->[Edge]
		{
            return edges.filter{
                return $0.isPartOfConvexHull();
			}
		}

		public func hullPointsInOrder()->[CGPoint]
		{
			var hullEdges = self.hullEdges();
			
			var points =  [CGPoint]();
			if (hullEdges.count == 0)
			{
				return points;
			}
			
			var reorderer = EdgeReorderer(origEdges: hullEdges, criterion: .Site);
			hullEdges = reorderer.edges;
			let orientations = reorderer.edgeOrientations;
			reorderer.dispose();
			
			var orientation:LR;

			var n:Int = hullEdges.count;
			for i in 0..<n{
				let edge = hullEdges[i];
				orientation = orientations[i];
				points.append(edge.site(orientation).coord);
			}
			return points;
		}

		public func spanningTree(type:SpanningType = .Minimum/*, keepOutMask:BitmapData = nil*/) -> [LineSegment]
		{
			let edges = selectNonIntersectingEdges(/*keepOutMask,*/self.edges);
			var segments:[LineSegment] = delaunayLinesForEdges(edges);
			return Kruskal(segments, type: type);
		}

		public func regions()->[[CGPoint]]
		{
			return sites.regions(plotBounds);
		}
		
		public func siteColors(/*referenceImage:BitmapData = nil*/)->[UInt]
		{
			return sites.siteColors(/*referenceImage*/);
		}
		
		/**
		 * 
		 * @param proximityMap a BitmapData whose regions are filled with the site index values; see PlanePointsCanvas::fillRegions()
		 * @param x
		 * @param y
		 * @return coordinates of nearest Site to (x, y)
		 * 
		 */
		public func nearestSitePoint(/*proximityMap:BitmapData,*/ x:CGFloat, y:CGFloat)->CGPoint
		{
			return sites.nearestSitePoint(/*proximityMap,*/ x, y);
		}

		public func siteCoords()->[CGPoint]
		{
			return sites.siteCoords();
		}

		private func fortunesAlgorithm()
		{
//			var newSite:Site, bottomSite:Site, topSite:Site, tempSite:Site;
//			var v:Vertex, vertex:Vertex;
//			var newintstar:CGPoint;
//			var leftRight:LR;
//			var lbnd:Halfedge, rbnd:Halfedge, llbnd:Halfedge, rrbnd:Halfedge, bisector:Halfedge;
//			var edge:Edge;
//			
//			var dataBounds:Rectangle = _sites.getSitesBounds();
//			
//			var sqrt_nsites:Int = int(Math.sqrt(_sites.length + 4));
//			var heap:HalfedgePriorityQueue = new HalfedgePriorityQueue(dataBounds.y, dataBounds.height, sqrt_nsites);
//			var edgeList:EdgeList = new EdgeList(dataBounds.x, dataBounds.width, sqrt_nsites);
//			var halfEdges:[HalfEdge] = new [HalfEdge]();
//			var vertices:[Vertex] = new [Vertex]();
//			
//			var bottomMostSite:Site = _sites.next();
//			newSite = _sites.next();
//			
//			for (;;)
//			{
//				if (heap.empty() == false)
//				{
//					newintstar = heap.min();
//				}
//			
//				if (newSite != nil 
//				&&  (heap.empty() || compareByYThenX(newSite, newintstar) < 0))
//				{
//					/* new site is smallest */
//					//trace("smallest: new site " + newSite);
//					
//					// Step 8:
//					lbnd = edgeList.edgeListLeftNeighbor(newSite.coord);	// the Halfedge just to the left of newSite
//					//trace("lbnd: " + lbnd);
//					rbnd = lbnd.edgeListRightNeighbor;		// the Halfedge just to the right
//					//trace("rbnd: " + rbnd);
//					bottomSite = rightRegion(lbnd);		// this is the same as leftRegion(rbnd)
//					// this Site determines the region containing the new site
//					//trace("new Site is in region of existing site: " + bottomSite);
//					
//					// Step 9:
//					edge = Edge.createBisectingEdge(bottomSite, newSite);
//					//trace("new edge: " + edge);
//					_edges.push(edge);
//					
//					bisector = Halfedge.create(edge, LR.LEFT);
//					halfEdges.push(bisector);
//					// inserting two Halfedges into edgeList constitutes Step 10:
//					// insert bisector to the right of lbnd:
//					edgeList.insert(lbnd, bisector);
//					
//					// first half of Step 11:
//					if ((vertex = Vertex.intersect(lbnd, bisector)) != nil) 
//					{
//						vertices.push(vertex);
//						heap.remove(lbnd);
//						lbnd.vertex = vertex;
//						lbnd.ystar = vertex.y + newSite.dist(vertex);
//						heap.insert(lbnd);
//					}
//					
//					lbnd = bisector;
//					bisector = Halfedge.create(edge, LR.RIGHT);
//					halfEdges.push(bisector);
//					// second Halfedge for Step 10:
//					// insert bisector to the right of lbnd:
//					edgeList.insert(lbnd, bisector);
//					
//					// second half of Step 11:
//					if ((vertex = Vertex.intersect(bisector, rbnd)) != nil)
//					{
//						vertices.push(vertex);
//						bisector.vertex = vertex;
//						bisector.ystar = vertex.y + newSite.dist(vertex);
//						heap.insert(bisector);	
//					}
//					
//					newSite = _sites.next();	
//				}
//				else if (heap.empty() == false) 
//				{
//					/* intersection is smallest */
//					lbnd = heap.extractMin();
//					llbnd = lbnd.edgeListLeftNeighbor;
//					rbnd = lbnd.edgeListRightNeighbor;
//					rrbnd = rbnd.edgeListRightNeighbor;
//					bottomSite = leftRegion(lbnd);
//					topSite = rightRegion(rbnd);
//					// these three sites define a Delaunay triangle
//					// (not actually using these for anything...)
//					//_triangles.push(new Triangle(bottomSite, topSite, rightRegion(lbnd)));
//					
//					v = lbnd.vertex;
//					v.setIndex();
//					lbnd.edge.setVertex(lbnd.leftRight, v);
//					rbnd.edge.setVertex(rbnd.leftRight, v);
//					edgeList.remove(lbnd); 
//					heap.remove(rbnd);
//					edgeList.remove(rbnd); 
//					leftRight = LR.LEFT;
//					if (bottomSite.y > topSite.y)
//					{
//						tempSite = bottomSite; bottomSite = topSite; topSite = tempSite; leftRight = LR.RIGHT;
//					}
//					edge = Edge.createBisectingEdge(bottomSite, topSite);
//					_edges.push(edge);
//					bisector = Halfedge.create(edge, leftRight);
//					halfEdges.push(bisector);
//					edgeList.insert(llbnd, bisector);
//					edge.setVertex(LR.other(leftRight), v);
//					if ((vertex = Vertex.intersect(llbnd, bisector)) != nil)
//					{
//						vertices.push(vertex);
//						heap.remove(llbnd);
//						llbnd.vertex = vertex;
//						llbnd.ystar = vertex.y + bottomSite.dist(vertex);
//						heap.insert(llbnd);
//					}
//					if ((vertex = Vertex.intersect(bisector, rrbnd)) != nil)
//					{
//						vertices.push(vertex);
//						bisector.vertex = vertex;
//						bisector.ystar = vertex.y + bottomSite.dist(vertex);
//						heap.insert(bisector);
//					}
//				}
//				else
//				{
//					break;
//				}
//			}
//			
//			// heap should be empty now
//			heap.dispose();
//			edgeList.dispose();
//			
//			for each (var halfEdge:Halfedge in halfEdges)
//			{
//				halfEdge.reallyDispose();
//			}
//			halfEdges.length = 0;
//			
//			// we need the vertices to clip the edges
//			for each (edge in _edges)
//			{
//				edge.clipVertices(_plotBounds);
//			}
//			// but we don't actually ever use them again!
//			for each (vertex in vertices)
//			{
//				vertex.dispose();
//			}
//			vertices.length = 0;
//			
//			func leftRegion(he:Halfedge):Site
//			{
//				var edge:Edge = he.edge;
//				if (edge == nil)
//				{
//					return bottomMostSite;
//				}
//				return edge.site(he.leftRight);
//			}
//			
//			func rightRegion(he:Halfedge):Site
//			{
//				var edge:Edge = he.edge;
//				if (edge == nil)
//				{
//					return bottomMostSite;
//				}
//				return edge.site(LR.other(he.leftRight));
//			}
		}

		static func compareByYThenX(s1:Site, s2:Site)->Int
		{
            if (s1.y < s2.y){ return -1;}
            if (s1.y > s2.y){ return 1;}
            if (s1.x < s2.x){ return -1;}
            if (s1.x > s2.x){ return 1;}
			return 0;
		}

}