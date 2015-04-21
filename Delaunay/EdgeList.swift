
	
public final class EdgeList{
		private var deltax:CGFloat = 0;
		private var xmin:CGFloat = 0;
		
		private var hashsize:Int = 0;
		private var hash:[Halfedge?];
		private var leftEnd:Halfedge;
		
        public var rightEnd:Halfedge;
		
		public init(xmin:CGFloat, deltax:CGFloat, sqrt_nsites:Int)
		{
			self.xmin = xmin;
			self.deltax = deltax;
			hashsize = 2 * sqrt_nsites;


			// two dummy Halfedges:
			leftEnd = Halfedge.createDummy();
			rightEnd = Halfedge.createDummy();
            var i:Int;
            hash = [Halfedge?](count: hashsize, repeatedValue: nil)
			leftEnd.edgeListLeftNeighbor = nil;
			leftEnd.edgeListRightNeighbor = rightEnd;
			rightEnd.edgeListLeftNeighbor = leftEnd;
			rightEnd.edgeListRightNeighbor = nil;
			hash[0] = leftEnd;
			hash[hashsize - 1] = rightEnd;
		}

		/**
		 * Insert newHalfedge to the right of lb 
		 * @param lb
		 * @param newHalfedge
		 * 
		 */
		public func insert(lb:Halfedge, newHalfedge:Halfedge)
		{
			newHalfedge.edgeListLeftNeighbor = lb;
			newHalfedge.edgeListRightNeighbor = lb.edgeListRightNeighbor;
			lb.edgeListRightNeighbor!.edgeListLeftNeighbor = newHalfedge;
			lb.edgeListRightNeighbor = newHalfedge;
		}

		/**
		 * This func only removes the Halfedge from the left-right list.
		 * We cannot dispose it yet because we are still using it. 
		 * @param halfEdge
		 * 
		 */
		public func remove(halfEdge:Halfedge)
		{
			halfEdge.edgeListLeftNeighbor!.edgeListRightNeighbor = halfEdge.edgeListRightNeighbor;
			halfEdge.edgeListRightNeighbor!.edgeListLeftNeighbor = halfEdge.edgeListLeftNeighbor;
			halfEdge.edge = Edge.DELETED;
			halfEdge.edgeListLeftNeighbor = nil
            halfEdge.edgeListRightNeighbor = nil;
		}

		/**
		 * Find the rightmost Halfedge that is still left of p 
		 * @param p
		 * @return 
		 * 
		 */
		public func edgeListLeftNeighbor(p:CGPoint) -> Halfedge
		{
			var i:Int, bucket:Int;
			var halfEdge:Halfedge?;
		
			/* Use hash table to get close to desired halfedge */
			bucket = Int((p.x - xmin)/deltax) * hashsize;
			if (bucket < 0)
			{
				bucket = 0;
			}
			if (bucket >= hashsize)
			{
				bucket = hashsize - 1;
			}
			halfEdge = getHash(bucket);
			if (halfEdge == nil)
			{
				for (i = 1; true ; ++i)
			    {
                    (halfEdge = getHash(bucket - i))
                    if (halfEdge != nil){
                        break;
                    }
                    halfEdge = getHash(bucket + i)
                    if (halfEdge != nil){
                        break;
                    }
			    }
			}
			/* Now search linear list of halfedges for the correct one */
			if (halfEdge === leftEnd  || (halfEdge !== rightEnd && halfEdge!.isLeftOf(p)))
			{
				do
				{
					halfEdge = halfEdge!.edgeListRightNeighbor;
				}
				while (halfEdge !== rightEnd && halfEdge!.isLeftOf(p));
				halfEdge = halfEdge!.edgeListLeftNeighbor;
			}
			else
			{
				do
				{
					halfEdge = halfEdge!.edgeListLeftNeighbor;
				}
				while (halfEdge !== leftEnd && !halfEdge!.isLeftOf(p));
			}
		
			/* Update hash table and reference counts */
			if (bucket > 0 && bucket < hashsize - 1)
			{
                hash[bucket] = halfEdge;
			}
			return halfEdge!;
		}

		/* Get entry from hash table, pruning any deleted nodes */
		private func getHash(b:Int)->Halfedge?
		{
			var halfEdge:Halfedge?;
		
			if (b < 0 || b >= hashsize)
			{
				return nil;
			}
			halfEdge = hash[b];
			if (halfEdge != nil && halfEdge!.edge === Edge.DELETED)
			{
				/* Hash table points to deleted halfedge.  Patch as necessary. */
				hash[b] = nil;
				// still can't dispose halfEdge yet!
				return nil;
			}
			else
			{
				return halfEdge;
			}
		}
//
//	}
}