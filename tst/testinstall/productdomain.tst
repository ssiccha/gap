#@local D8, fam, dpf, d, emptyDPDDim2, emptyDPDDim3, dpdDim0, dpd
#@local range1, range2, g1, g2, dpdOfGroups, bijToRange, inv, tups
#@local dpdNotAttributeStoring
gap> START_TEST("productdomain.tst");

# DirectProductFamily
gap> D8 := DihedralGroup(IsPermGroup, 8);;
gap> fam := FamilyObj(D8);
<Family: "CollectionsFamily(...)">
gap> ElementsFamily(fam);
<Family: "PermutationsFamily">
gap> dpf := DirectProductFamily([fam, fam]);
<Family: "CollectionsFamily(...)">
gap> IsDirectProductElementFamily(ElementsFamily(dpf));
true
gap> DirectProductFamily([CyclotomicsFamily, ]);
Error, <args> must be a dense list of collection families

# DirectProductDomain
# of empty domains, dim 2
gap> d := Domain(FamilyObj([1]), []);
Domain([  ])
gap> emptyDPDDim2 := DirectProductDomain([d, d]);
DirectProductDomain([ Domain([  ]), Domain([  ]) ])
gap> Size(emptyDPDDim2);
0
gap> IsEmpty(emptyDPDDim2);
true
gap> DimensionOfDirectProductDomain(emptyDPDDim2);
2
gap> DirectProductElement([]) in emptyDPDDim2;
false
gap> AsList(emptyDPDDim2);
[  ]
gap> Enumerator(emptyDPDDim2);
[  ]

# of empty domains, dim 3
gap> emptyDPDDim3 := DirectProductDomain(d, 3);
DirectProductDomain([ Domain([  ]), Domain([  ]), Domain([  ]) ])
gap> Size(emptyDPDDim3);
0
gap> IsEmpty(emptyDPDDim3);
true
gap> DimensionOfDirectProductDomain(emptyDPDDim3);
3
gap> DirectProductElement([]) in emptyDPDDim3;
false
gap> AsList(emptyDPDDim3);
[  ]
gap> Enumerator(emptyDPDDim3);
[  ]
gap> emptyDPDDim2 = emptyDPDDim3;
false

# of dimension 0
gap> range1 := Domain([1..5]);
Domain([ 1 .. 5 ])
gap> dpdDim0 := DirectProductDomain(range1, 0);
DirectProductDomain([  ])
gap> dpdDim0 = DirectProductDomain([]);
true
gap> Size(dpdDim0);
1
gap> IsEmpty(dpdDim0);
false
gap> DimensionOfDirectProductDomain(dpdDim0);
0
gap> DirectProductElement([]) in dpdDim0;
true
gap> AsList(dpdDim0);
[ DirectProductElement( [  ] ) ]
gap> Enumerator(dpdDim0);
[ DirectProductElement( [  ] ) ]
gap> dpdDim0 = emptyDPDDim2;
false

# of domains of ranges
gap> range1;
Domain([ 1 .. 5 ])
gap> range2 := Domain([3..7]);
Domain([ 3 .. 7 ])
gap> dpd := DirectProductDomain([range1, range2]);
DirectProductDomain([ Domain([ 1 .. 5 ]), Domain([ 3 .. 7 ]) ])
gap> Size(dpd);
25
gap> DimensionOfDirectProductDomain(dpd);
2
gap> DirectProductElement([]) in dpd;
false
gap> DirectProductElement([6, 3]) in dpd;
false
gap> DirectProductElement([1, 3]) in dpd;
true
gap> AsList(dpd);
[ DirectProductElement( [ 1, 3 ] ), DirectProductElement( [ 2, 3 ] ), 
  DirectProductElement( [ 3, 3 ] ), DirectProductElement( [ 4, 3 ] ), 
  DirectProductElement( [ 5, 3 ] ), DirectProductElement( [ 1, 4 ] ), 
  DirectProductElement( [ 2, 4 ] ), DirectProductElement( [ 3, 4 ] ), 
  DirectProductElement( [ 4, 4 ] ), DirectProductElement( [ 5, 4 ] ), 
  DirectProductElement( [ 1, 5 ] ), DirectProductElement( [ 2, 5 ] ), 
  DirectProductElement( [ 3, 5 ] ), DirectProductElement( [ 4, 5 ] ), 
  DirectProductElement( [ 5, 5 ] ), DirectProductElement( [ 1, 6 ] ), 
  DirectProductElement( [ 2, 6 ] ), DirectProductElement( [ 3, 6 ] ), 
  DirectProductElement( [ 4, 6 ] ), DirectProductElement( [ 5, 6 ] ), 
  DirectProductElement( [ 1, 7 ] ), DirectProductElement( [ 2, 7 ] ), 
  DirectProductElement( [ 3, 7 ] ), DirectProductElement( [ 4, 7 ] ), 
  DirectProductElement( [ 5, 7 ] ) ]
gap> Enumerator(dpd) = AsList(dpd);
true
gap> Domain(AsList(dpd)) = dpd;
true
gap> dpd = emptyDPDDim2;
false

# DirectProductDomain
# of groups
gap> g1 := DihedralGroup(4);
<pc group of size 4 with 2 generators>
gap> g2 := DihedralGroup(IsPermGroup, 4);
Group([ (1,2), (3,4) ])
gap> dpdOfGroups := DirectProductDomain([g1, g2]);
DirectProductDomain([ Group( [ f1, f2 ] ), Group( [ (1,2), (3,4) ] ) ])
gap> Size(dpdOfGroups);
16
gap> DimensionOfDirectProductDomain(dpdOfGroups);
2
gap> DirectProductElement([]) in dpdOfGroups;
false
gap> DirectProductElement([1, 3]) in dpdOfGroups;
false
gap> DirectProductElement([g1.1, g2.1]) in dpdOfGroups;
true
gap> AsList(dpdOfGroups);
[ DirectProductElement( [ <identity> of ..., () ] ), 
  DirectProductElement( [ f1, () ] ), DirectProductElement( [ f2, () ] ), 
  DirectProductElement( [ f1*f2, () ] ), 
  DirectProductElement( [ <identity> of ..., (3,4) ] ), 
  DirectProductElement( [ f1, (3,4) ] ), DirectProductElement( [ f2, (3,4) ] )
    , DirectProductElement( [ f1*f2, (3,4) ] ), 
  DirectProductElement( [ <identity> of ..., (1,2) ] ), 
  DirectProductElement( [ f1, (1,2) ] ), DirectProductElement( [ f2, (1,2) ] )
    , DirectProductElement( [ f1*f2, (1,2) ] ), 
  DirectProductElement( [ <identity> of ..., (1,2)(3,4) ] ), 
  DirectProductElement( [ f1, (1,2)(3,4) ] ), 
  DirectProductElement( [ f2, (1,2)(3,4) ] ), 
  DirectProductElement( [ f1*f2, (1,2)(3,4) ] ) ]
gap> Enumerator(dpdOfGroups) = AsList(dpdOfGroups);
true
gap> Domain(AsList(dpdOfGroups)) = dpdOfGroups;
true
gap> dpdOfGroups = emptyDPDDim2;
false

# DirectProductDomain
# error handling
gap> DirectProductDomain([CyclotomicsFamily]);
Error, args must be a dense list of domains
gap> DirectProductDomain(dpd, -1);
Error, <k> must be a nonnegative integer

# BijectiveMappingFromDirectProductDomainToRange
# empty dim 2
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(emptyDPDDim2);
MappingByFunction( DirectProductDomain([ Domain([  ]), Domain(
[  ]) ]), Domain([  ]), function( x ) ... end, function( x ) ... end )
gap> inv := InverseGeneralMapping(bijToRange);
MappingByFunction( Domain([  ]), DirectProductDomain([ Domain([  ]), Domain(
[  ]) ]), function( x ) ... end, function( x ) ... end )
gap> (IsMapping and IsSurjective and IsInjective)(inv);
true
gap> Source(bijToRange);
DirectProductDomain([ Domain([  ]), Domain([  ]) ])
gap> Image(bijToRange);
Domain([  ])
gap> PreImage(bijToRange, Domain(CollectionsFamily(CyclotomicsFamily), []));
[  ]
gap> tups := [];;
gap> [] = List([], i -> Image(bijToRange, PreImage(bijToRange, i)));
true
gap> tups = List(tups, tup -> PreImage(bijToRange, Image(bijToRange, tup)));
true

# dim 0
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(dpdDim0);
MappingByFunction( DirectProductDomain([  ]), Domain(
[ 1 ]), function( x ) ... end, function( x ) ... end )
gap> Source(bijToRange);
DirectProductDomain([  ])
gap> Image(bijToRange);
Domain([ 1 ])
gap> PreImage(bijToRange);
DirectProductDomain([  ])
gap> Image(bijToRange, DirectProductElement([]));
1
gap> PreImage(bijToRange, 1);
DirectProductElement( [  ] )

# of ranges
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(dpd);
MappingByFunction( DirectProductDomain([ Domain([ 1 .. 5 ]), Domain(
[ 3 .. 7 ]) ]), Domain(
[ 1 .. 25 ]), function( x ) ... end, function( x ) ... end )
gap> tups := List(range2, x2 -> List(range1, x1 -> [x1, x2]));;
gap> tups := Concatenation(tups);
[ [ 1, 3 ], [ 2, 3 ], [ 3, 3 ], [ 4, 3 ], [ 5, 3 ], [ 1, 4 ], [ 2, 4 ], 
  [ 3, 4 ], [ 4, 4 ], [ 5, 4 ], [ 1, 5 ], [ 2, 5 ], [ 3, 5 ], [ 4, 5 ], 
  [ 5, 5 ], [ 1, 6 ], [ 2, 6 ], [ 3, 6 ], [ 4, 6 ], [ 5, 6 ], [ 1, 7 ], 
  [ 2, 7 ], [ 3, 7 ], [ 4, 7 ], [ 5, 7 ] ]
gap> tups := List(tups, DirectProductElement);;
gap> ForAll([1 .. 25], i -> i = Image(bijToRange, PreImage(bijToRange, i)));
true
gap> ForAll(tups, tup -> tup = PreImage(bijToRange, Image(bijToRange, tup)));
true

# of groups
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(dpdOfGroups);
MappingByFunction( DirectProductDomain([ Group( [ f1, f2 ] ), Group( 
[ (1,2), (3,4) ] ) ]), Domain(
[ 1 .. 16 ]), function( x ) ... end, function( x ) ... end )
gap> tups := Concatenation(List(g2, x2 -> List(g1, x1 -> [x1, x2])));;
gap> tups := List(tups, DirectProductElement);;
gap> ForAll([1 .. 16], i -> i = Image(bijToRange, PreImage(bijToRange, i)));
true
gap> ForAll(tups, tup -> tup = PreImage(bijToRange, Image(bijToRange, tup)));
true

# error handling
gap> dpdNotAttributeStoring := Objectify(
>    NewType(DirectProductFamily([]), IsDirectProductDomain),
>    rec()
> );;
gap> BijectiveMappingFromDirectProductDomainToRange(dpdNotAttributeStoring);
Error, <directProductDomain> must be an attribute storing IsDirectProductDomai\
n

#
gap> STOP_TEST("productdomain.tst");
