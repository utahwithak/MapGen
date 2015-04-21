
internal func selectNonIntersectingEdges(keepOutMask:NSData?, edgesToTest:[Edge])->[Edge]
{
    if (keepOutMask == nil)
    {
        return edgesToTest;
    }
//
    var zeroPoint:CGPoint = CGPoint.zeroPoint
    return edgesToTest
//
//    function myTest(edge:Edge, index:Int, vector:Vector.<Edge>)->Bool
//    {
//        var delaunayLineBmp:BitmapData = edge.makeDelaunayLineBmp();
//        var notIntersecting:Bool = !(keepOutMask.hitTest(zeroPoint, 1, delaunayLineBmp, zeroPoint, 1));
//        delaunayLineBmp.dispose();
//        return notIntersecting;
//    }
}
