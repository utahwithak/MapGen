import Foundation

final class HalfedgePriorityQueue // also known as heap
{
//    private var _hash:[HalfEdge];
//    private var _count:Int;
//    private var _minBucket:Int;
//    private var _hashsize:Int;
//    
//    private var _ymin:CGFloat;
//    private var _deltay:CGFloat;
//    
//    public func HalfedgePriorityQueue(ymin:CGFloat, deltay:CGFloat, sqrt_nsites:Int)
//    {
//        _ymin = ymin;
//        _deltay = deltay;
//        _hashsize = 4 * sqrt_nsites;
//        initialize();
//    }
//    
//    public func dispose()
//    {
//        // get rid of dummies
//        for (var i:Int = 0; i < _hashsize; ++i)
//        {
//            _hash[i].dispose();
//            _hash[i] = nil;
//        }
//        _hash = nil;
//    }
//
//    private func initialize()
//    {
//        var i:Int;
//    
//        _count = 0;
//        _minBucket = 0;
//        _hash = new [HalfEdge](_hashsize);
//        // dummy Halfedge at the top of each hash
//        for (i = 0; i < _hashsize; ++i)
//        {
//            _hash[i] = Halfedge.createDummy();
//            _hash[i].nextInPriorityQueue = nil;
//        }
//    }
//
//    public func insert(halfEdge:Halfedge)
//    {
//        var previous:Halfedge, next:Halfedge;
//        var insertionBucket:Int = bucket(halfEdge);
//        if (insertionBucket < _minBucket)
//        {
//            _minBucket = insertionBucket;
//        }
//        previous = _hash[insertionBucket];
//        while ((next = previous.nextInPriorityQueue) != nil
//        &&     (halfEdge.ystar  > next.ystar || (halfEdge.ystar == next.ystar && halfEdge.vertex.x > next.vertex.x)))
//        {
//            previous = next;
//        }
//        halfEdge.nextInPriorityQueue = previous.nextInPriorityQueue; 
//        previous.nextInPriorityQueue = halfEdge;
//        ++_count;
//    }
//
//    public func remove(halfEdge:Halfedge)
//    {
//        var previous:Halfedge;
//        var removalBucket:Int = bucket(halfEdge);
//        
//        if (halfEdge.vertex != nil)
//        {
//            previous = _hash[removalBucket];
//            while (previous.nextInPriorityQueue != halfEdge)
//            {
//                previous = previous.nextInPriorityQueue;
//            }
//            previous.nextInPriorityQueue = halfEdge.nextInPriorityQueue;
//            _count--;
//            halfEdge.vertex = nil;
//            halfEdge.nextInPriorityQueue = nil;
//            halfEdge.dispose();
//        }
//    }
//
//    private func bucket(halfEdge:Halfedge):Int
//    {
//        var theBucket:Int = (halfEdge.ystar - _ymin)/_deltay * _hashsize;
//        if (theBucket < 0) theBucket = 0;
//        if (theBucket >= _hashsize) theBucket = _hashsize - 1;
//        return theBucket;
//    }
//    
//    private func isEmpty(bucket:Int)->Bool
//    {
//        return (_hash[bucket].nextInPriorityQueue == nil);
//    }
//    
//    /**
//     * move _minBucket until it contains an actual Halfedge (not just the dummy at the top); 
//     * 
//     */
//    private func adjustMinBucket()
//    {
//        while (_minBucket < _hashsize - 1 && isEmpty(_minBucket))
//        {
//            ++_minBucket;
//        }
//    }
//
//    public func empty()->Bool
//    {
//        return _count == 0;
//    }
//
//    /**
//     * @return coordinates of the Halfedge's vertex in V*, the transformed Voronoi diagram
//     * 
//     */
//    public func min()->Point
//    {
//        adjustMinBucket();
//        var answer:Halfedge = _hash[_minBucket].nextInPriorityQueue;
//        return new Point(answer.vertex.x, answer.ystar);
//    }
//
//    /**
//     * remove and return the min Halfedge
//     * @return 
//     * 
//     */
//    public func extractMin()->Halfedge
//    {
//        var answer:Halfedge;
//    
//        // get the first real Halfedge in _minBucket
//        answer = _hash[_minBucket].nextInPriorityQueue;
//        
//        _hash[_minBucket].nextInPriorityQueue = answer.nextInPriorityQueue;
//        _count--;
//        answer.nextInPriorityQueue = nil;
//        
//        return answer;
//    }

}
