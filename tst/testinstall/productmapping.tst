#@local TODO
gap> START_TEST("productmapping.tst");

# actually product mapping
gap> range1 := Domain([1..5]);
Domain([ 1 .. 5 ])
gap> range2 := Domain([3..7]);
Domain([ 3 .. 7 ])
gap> dpd := DirectProductDomain([range1, range2]);
DirectProductDomain(Domain([ 1 .. 5 ]), Domain([ 3 .. 7 ]))
gap> proj1 := x -> RemInt(x - 1, 5) + 1;
function( x ) ... end
gap> Set(List([1..25], proj1));
[ 1, 2, 3, 4, 5 ]
gap> proj2 := x -> QuoInt(x - 1, 5) + 3;
function( x ) ... end
gap> Set(List([1..25], proj2));
[ 3, 4, 5, 6, 7 ]
gap> dom := Domain([1..25]);;
gap> projMap1 := MappingByFunction(dom, range1, proj1);
MappingByFunction( Domain([ 1 .. 25 ]), Domain([ 1 .. 5 ]), function( x ) ... end )
gap> projMap2 := MappingByFunction(dom, range2, proj2);
MappingByFunction( Domain([ 1 .. 25 ]), Domain([ 3 .. 7 ]), function( x ) ... end )
gap> IsSurjective(projMap1) and IsSurjective(projMap2);
true
gap> productMap := DirectProductMapping([projMap1, projMap2]);
MappingByFunction( Domain([ 1 .. 25 ]), DirectProductDomain(Domain(
[ 1 .. 5 ]), Domain([ 3 .. 7 ])), function( x ) ... end )
gap> IsSurjective(productMap);
Error, Method for an attribute must return a value in
gap> IsInjective(productMap);
true

#
gap> STOP_TEST("productmapping.tst");
