#@local D8, fam, dpf, d, emptyDPDDim2, emptyDPDDim3, dpdDim0, dpd
#@local range1, range2, range3, g1, g2, dpdOfGroups, bijToRange, inv, tups
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
gap> range1 := Domain([1..4]);
Domain([ 1 .. 4 ])
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
Domain([ 1 .. 4 ])
gap> range2 := Domain([5 .. 7]);
Domain([ 5 .. 7 ])
gap> range3 := Domain([8 .. 9]);
Domain([ 8 .. 9 ])
gap> dpd := DirectProductDomain([range1, range2, range3]);
DirectProductDomain([ Domain([ 1 .. 4 ]), Domain([ 5 .. 7 ]), Domain(
[ 8 .. 9 ]) ])
gap> Size(dpd);
24
gap> DimensionOfDirectProductDomain(dpd);
3
gap> DirectProductElement([]) in dpd;
false
gap> DirectProductElement([4, 3, 4]) in dpd;
false
gap> DirectProductElement([4, 6, 9]) in dpd;
true
gap> AsList(dpd);
[ DirectProductElement( [ 1, 5, 8 ] ), DirectProductElement( [ 1, 5, 9 ] ), 
  DirectProductElement( [ 1, 6, 8 ] ), DirectProductElement( [ 1, 6, 9 ] ), 
  DirectProductElement( [ 1, 7, 8 ] ), DirectProductElement( [ 1, 7, 9 ] ), 
  DirectProductElement( [ 2, 5, 8 ] ), DirectProductElement( [ 2, 5, 9 ] ), 
  DirectProductElement( [ 2, 6, 8 ] ), DirectProductElement( [ 2, 6, 9 ] ), 
  DirectProductElement( [ 2, 7, 8 ] ), DirectProductElement( [ 2, 7, 9 ] ), 
  DirectProductElement( [ 3, 5, 8 ] ), DirectProductElement( [ 3, 5, 9 ] ), 
  DirectProductElement( [ 3, 6, 8 ] ), DirectProductElement( [ 3, 6, 9 ] ), 
  DirectProductElement( [ 3, 7, 8 ] ), DirectProductElement( [ 3, 7, 9 ] ), 
  DirectProductElement( [ 4, 5, 8 ] ), DirectProductElement( [ 4, 5, 9 ] ), 
  DirectProductElement( [ 4, 6, 8 ] ), DirectProductElement( [ 4, 6, 9 ] ), 
  DirectProductElement( [ 4, 7, 8 ] ), DirectProductElement( [ 4, 7, 9 ] ) ]
gap> Size(dpd) = Size(AsList(dpd));
true
gap> IsSSortedList(AsList(dpd));
true
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
gap> g2 := DihedralGroup(IsPermGroup, 2);
Group([ (1,2) ])
gap> dpdOfGroups := DirectProductDomain([g1, g1, g2]);
DirectProductDomain([ Group( [ f1, f2 ] ), Group( [ f1, f2 ] ), Group( 
[ (1,2) ] ) ])
gap> Size(dpdOfGroups);
32
gap> DimensionOfDirectProductDomain(dpdOfGroups);
3
gap> DirectProductElement([]) in dpdOfGroups;
false
gap> DirectProductElement([1, 3]) in dpdOfGroups;
false
gap> DirectProductElement([g1.1, g1.2, g2.1]) in dpdOfGroups;
true
gap> AsList(dpdOfGroups);
[ DirectProductElement( [ <identity> of ..., <identity> of ..., () ] ), 
  DirectProductElement( [ <identity> of ..., <identity> of ..., (1,2) ] ), 
  DirectProductElement( [ <identity> of ..., f1, () ] ), 
  DirectProductElement( [ <identity> of ..., f1, (1,2) ] ), 
  DirectProductElement( [ <identity> of ..., f2, () ] ), 
  DirectProductElement( [ <identity> of ..., f2, (1,2) ] ), 
  DirectProductElement( [ <identity> of ..., f1*f2, () ] ), 
  DirectProductElement( [ <identity> of ..., f1*f2, (1,2) ] ), 
  DirectProductElement( [ f1, <identity> of ..., () ] ), 
  DirectProductElement( [ f1, <identity> of ..., (1,2) ] ), 
  DirectProductElement( [ f1, f1, () ] ), 
  DirectProductElement( [ f1, f1, (1,2) ] ), 
  DirectProductElement( [ f1, f2, () ] ), 
  DirectProductElement( [ f1, f2, (1,2) ] ), 
  DirectProductElement( [ f1, f1*f2, () ] ), 
  DirectProductElement( [ f1, f1*f2, (1,2) ] ), 
  DirectProductElement( [ f2, <identity> of ..., () ] ), 
  DirectProductElement( [ f2, <identity> of ..., (1,2) ] ), 
  DirectProductElement( [ f2, f1, () ] ), 
  DirectProductElement( [ f2, f1, (1,2) ] ), 
  DirectProductElement( [ f2, f2, () ] ), 
  DirectProductElement( [ f2, f2, (1,2) ] ), 
  DirectProductElement( [ f2, f1*f2, () ] ), 
  DirectProductElement( [ f2, f1*f2, (1,2) ] ), 
  DirectProductElement( [ f1*f2, <identity> of ..., () ] ), 
  DirectProductElement( [ f1*f2, <identity> of ..., (1,2) ] ), 
  DirectProductElement( [ f1*f2, f1, () ] ), 
  DirectProductElement( [ f1*f2, f1, (1,2) ] ), 
  DirectProductElement( [ f1*f2, f2, () ] ), 
  DirectProductElement( [ f1*f2, f2, (1,2) ] ), 
  DirectProductElement( [ f1*f2, f1*f2, () ] ), 
  DirectProductElement( [ f1*f2, f1*f2, (1,2) ] ) ]
gap> Size(dpdOfGroups) = Size(AsList(dpdOfGroups));
true
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
MappingByFunction( DirectProductDomain([ Domain([ 1 .. 4 ]), Domain(
[ 5 .. 7 ]), Domain([ 8 .. 9 ]) ]), Domain(
[ 1 .. 24 ]), function( x ) ... end, function( x ) ... end )
gap> tups := List(range3,
>                 x3 -> List(range2,
>                            x2 -> List(range1,
>                                       x1 -> [x1, x2, x3])));;
gap> tups := Concatenation(Concatenation(tups));
[ [ 1, 5, 8 ], [ 2, 5, 8 ], [ 3, 5, 8 ], [ 4, 5, 8 ], [ 1, 6, 8 ], 
  [ 2, 6, 8 ], [ 3, 6, 8 ], [ 4, 6, 8 ], [ 1, 7, 8 ], [ 2, 7, 8 ], 
  [ 3, 7, 8 ], [ 4, 7, 8 ], [ 1, 5, 9 ], [ 2, 5, 9 ], [ 3, 5, 9 ], 
  [ 4, 5, 9 ], [ 1, 6, 9 ], [ 2, 6, 9 ], [ 3, 6, 9 ], [ 4, 6, 9 ], 
  [ 1, 7, 9 ], [ 2, 7, 9 ], [ 3, 7, 9 ], [ 4, 7, 9 ] ]
gap> tups := List(tups, DirectProductElement);;
gap> ForAll([1 .. Size(dpd)],
>           i -> i = Image(bijToRange, PreImage(bijToRange, i)));
true
gap> ForAll(tups, tup -> tup = PreImage(bijToRange, Image(bijToRange, tup)));
true

# of groups
gap> bijToRange := BijectiveMappingFromDirectProductDomainToRange(dpdOfGroups);
MappingByFunction( DirectProductDomain([ Group( [ f1, f2 ] ), Group( 
[ f1, f2 ] ), Group( [ (1,2) ] ) ]), Domain(
[ 1 .. 32 ]), function( x ) ... end, function( x ) ... end )
gap> tups := List(g2, x3 -> List(g1, x2 -> List(g1, x1 -> [x1, x2, x3])));;
gap> tups := Concatenation(Concatenation(tups));;
gap> tups := List(tups, DirectProductElement);;
gap> ForAll([1 .. Size(dpdOfGroups)],
>           i -> i = Image(bijToRange, PreImage(bijToRange, i)));
true
gap> ForAll(tups, tup -> tup = PreImage(bijToRange, Image(bijToRange, tup)));
true

# error handling
gap> dpdNotAttributeStoring := Objectify(
>    NewType(DirectProductFamily([]), IsDirectProductDomain),
>    rec()
> );;
gap> BijectiveMappingFromDirectProductDomainToRange(dpdNotAttributeStoring);
Error, <dom> must be an attribute storing IsDirectProductDomain

#
gap> STOP_TEST("productdomain.tst");
