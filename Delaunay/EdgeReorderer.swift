import Foundation

final class EdgeReorderer{
//		private var edges:[Edge];
//		private var _edgeOrientations:[LR];
//		public func getEdges()->[Edge]
//		{
//			return edges;
//		}
//		public func get edgeOrientations()->[LR>
//		{
//			return _edgeOrientations;
//		}
//		
//		public func EdgeReorderer(origEdges:[Edge], criterion:Class)
//		{
//			if (criterion != Vertex && criterion != Site)
//			{
//				throw new ArgumentError("Edges: criterion must be Vertex or Site");
//			}
//			_edges = new [Edge]();
//			_edgeOrientations = new [LR>();
//			if (origEdges.length > 0)
//			{
//				_edges = reorderEdges(origEdges, criterion);
//			}
//		}
//		
//		public func dispose()
//		{
//			_edges = nil;
//			_edgeOrientations = nil;
//		}
//
//		private func reorderEdges(origEdges:[Edge], criterion:Class):[Edge]
//		{
//			var i:Int;
//			var j:Int;
//			var n:Int = origEdges.length;
//			var edge:Edge;
//			// we're going to reorder the edges in order of traversal
//			var done:[Bool> = new [Bool>(n, true);
//			var nDone:Int = 0;
//			for each (var b:Bool in done)
//			{
//				b = false;
//			}
//			var newEdges:[Edge] = new [Edge]();
//			
//			i = 0;
//			edge = origEdges[i];
//			newEdges.push(edge);
//			_edgeOrientations.push(LR.LEFT);
//			var firstPoint:ICoord = (criterion == Vertex) ? edge.leftVertex : edge.leftSite;
//			var lastPoint:ICoord = (criterion == Vertex) ? edge.rightVertex : edge.rightSite;
//			
//			if (firstPoint == Vertex.VERTEX_AT_INFINITY || lastPoint == Vertex.VERTEX_AT_INFINITY)
//			{
//				return new [Edge]();
//			}
//			
//			done[i] = true;
//			++nDone;
//			
//			while (nDone < n)
//			{
//				for (i = 1; i < n; ++i)
//				{
//					if (done[i])
//					{
//						continue;
//					}
//					edge = origEdges[i];
//					var leftPoint:ICoord = (criterion == Vertex) ? edge.leftVertex : edge.leftSite;
//					var rightPoint:ICoord = (criterion == Vertex) ? edge.rightVertex : edge.rightSite;
//					if (leftPoint == Vertex.VERTEX_AT_INFINITY || rightPoint == Vertex.VERTEX_AT_INFINITY)
//					{
//						return new [Edge]();
//					}
//					if (leftPoint == lastPoint)
//					{
//						lastPoint = rightPoint;
//						_edgeOrientations.push(LR.LEFT);
//						newEdges.push(edge);
//						done[i] = true;
//					}
//					else if (rightPoint == firstPoint)
//					{
//						firstPoint = leftPoint;
//						_edgeOrientations.unshift(LR.LEFT);
//						newEdges.unshift(edge);
//						done[i] = true;
//					}
//					else if (leftPoint == firstPoint)
//					{
//						firstPoint = rightPoint;
//						_edgeOrientations.unshift(LR.RIGHT);
//						newEdges.unshift(edge);
//						done[i] = true;
//					}
//					else if (rightPoint == lastPoint)
//					{
//						lastPoint = leftPoint;
//						_edgeOrientations.push(LR.RIGHT);
//						newEdges.push(edge);
//						done[i] = true;
//					}
//					if (done[i])
//					{
//						++nDone;
//					}
//				}
//			}
//			
//			return newEdges;
//		}
//
//	}
}