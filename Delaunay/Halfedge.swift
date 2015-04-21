import Foundation

public final class Halfedge{
		private static var pool:[Halfedge] = [Halfedge]();
    
		public static func create(edge:Edge?, lr:LR)->Halfedge
		{
			if (pool.count > 0)
			{
                let last = pool.removeLast()
				return last.reset(edge, lr: lr);
			}
			else
			{
				return Halfedge(edge: edge, lr: lr);
			}
		}

        public static func createDummy()->Halfedge
		{
			return create(nil, lr:.Unknown);
		}

		public var edgeListLeftNeighbor:Halfedge? = nil
        public var edgeListRightNeighbor:Halfedge? = nil
		public var nextInPriorityQueue:Halfedge? = nil;
		
		public var edge:Edge? = nil;
		public var leftRight:LR = .Unknown;
		public var vertex:Vertex? = nil;

		// the vertex's y-coordinate in the transformed Voronoi space V*
		public var ystar:CGFloat = 0;

		public init(edge:Edge? = nil, lr:LR = .Unknown)
		{
			reset(edge, lr: lr);
		}

        public func reset(edge:Edge?, lr:LR)->Halfedge{
            self.edge = edge;
            leftRight = lr;
            nextInPriorityQueue = nil;
            vertex = nil;
            return self
        }
//
//		public func toString()->String
//		{
//			return "Halfedge (leftRight: " + leftRight + "; vertex: " + vertex + ")";
//		}
//		
		public func dispose()
		{
			if (edgeListLeftNeighbor != nil || edgeListRightNeighbor != nil)
			{
				// still in EdgeList
				return;
			}
			if (nextInPriorityQueue != nil)
			{
				// still in PriorityQueue
				return;
			}
			edge = nil;
			leftRight = .Unknown;
			vertex = nil;
			Halfedge.pool.append(self);
		}
		
		public func reallyDispose()
		{
			edgeListLeftNeighbor = nil;
			edgeListRightNeighbor = nil;
			nextInPriorityQueue = nil;
			edge = nil;
			leftRight = .Unknown;
			vertex = nil;
            Halfedge.pool.append(self);
		}

		internal func isLeftOf(p:CGPoint)->Bool
        {
			var topSite:Site;
			var rightOfSite:Bool, above:Bool, fast:Bool;
			var dxp:CGFloat, dyp:CGFloat, dxs:CGFloat, t1:CGFloat, t2:CGFloat, t3:CGFloat, yl:CGFloat;
			
			topSite = edge!.rightSite!;
			rightOfSite = p.x > topSite.x;
			if (rightOfSite && leftRight == LR.LEFT)
			{
				return true;
			}
			if (!rightOfSite && leftRight == LR.RIGHT)
			{
				return false;
			}
			
			if (edge!.a == 1.0)
			{
				dyp = p.y - topSite.y;
				dxp = p.x - topSite.x;
				fast = false;
				if ((!rightOfSite && edge!.b < 0.0) || (rightOfSite && edge!.b >= 0.0) )
				{
					above = dyp >= edge!.b * dxp;
					fast = above;
				}
				else 
				{
					above = p.x + p.y * edge!.b > edge!.c;
					if (edge!.b < 0.0)
					{
						above = !above;
					}
					if (!above)
					{
						fast = true;
					}
				}
				if (!fast)
				{
					dxs = topSite.x - edge!.leftSite!.x;
					above = edge!.b * (dxp * dxp - dyp * dyp) <
					        dxs * dyp * (1.0 + 2.0 * dxp/dxs + edge!.b * edge!.b);
					if (edge!.b < 0.0)
					{
						above = !above;
					}
				}
			}
			else  /* edge.b == 1.0 */
			{
				yl = edge!.c - edge!.a * p.x;
				t1 = p.y - yl;
				t2 = p.x - topSite.x;
				t3 = yl - topSite.y;
				above = t1 * t1 > t2 * t2 + t3 * t3;
			}
			return leftRight == LR.LEFT ? above : !above;
		}

}