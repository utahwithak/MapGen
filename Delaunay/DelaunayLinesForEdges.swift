func delaunayLinesForEdges(edges:[Edge])->[LineSegment]
{
    var segments:[LineSegment] = [LineSegment]();
    for edge in edges{
        segments.append(edge.delaunayLine());
    }
    return segments;
}
