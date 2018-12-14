#############################################################################
##
##  This file is part of GAP, a system for computational discrete algebra.
##  This files's authors include Bettina Eick.
##
##  Copyright of GAP belongs to its developers, whose names are too numerous
##  to list here. Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##

#############################################################################
##
#V  InfoSpecPcgs
##
DeclareInfoClass( "InfoSpecPcgs" );


#############################################################################
##
#P  IsSpecialPcgs( <obj> )
##
##  <#GAPDoc Label="IsSpecialPcgs">
##  <ManSection>
##  <Prop Name="IsSpecialPcgs" Arg='obj'/>
##
##  <Description>
##  tests whether <A>obj</A> is a special pcgs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsSpecialPcgs", IsPcgs );
InstallTrueMethod( IsPcgs, IsSpecialPcgs );

#InstallTrueMethod(IsPcgsCentralSeries,IsSpecialPcgs);
InstallTrueMethod(IsPcgsElementaryAbelianSeries,IsSpecialPcgs);

#############################################################################
##
#A  SpecialPcgs( <pcgs> )
#A  SpecialPcgs( <G> )
##
##  <#GAPDoc Label="SpecialPcgs">
##  <ManSection>
##  <Heading>SpecialPcgs</Heading>
##  <Attr Name="SpecialPcgs" Arg='pcgs' Label="for a pcgs"/>
##  <Attr Name="SpecialPcgs" Arg='G' Label="for a group"/>
##
##  <Description>
##  computes a special pcgs for the group defined by <A>pcgs</A> or for
##  <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  A method for `SpecialPcgs(<G>)' must call `SpecialPcgs(Pcgs(<G>))' (this
##  is to avoid accidentally forgetting information.)
DeclareAttribute( "SpecialPcgs", IsPcgs );

#############################################################################
##
#A  LGHeads( <pcgs> )
##
##  <ManSection>
##  <Attr Name="LGHeads" Arg='pcgs'/>
##
##  <Description>
##  returns the LGHeads of the special pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##
DeclareAttribute( "LGHeads", IsPcgs );

#############################################################################
##
#A  LGTails( <pcgs> )
##
##  <ManSection>
##  <Attr Name="LGTails" Arg='pcgs'/>
##
##  <Description>
##  returns the LGTails of the special pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##
DeclareAttribute( "LGTails", IsPcgs );

#############################################################################
##
#A  LGWeights( <pcgs> )
##
##  <#GAPDoc Label="LGWeights">
##  <ManSection>
##  <Attr Name="LGWeights" Arg='pcgs'/>
##
##  <Description>
##  returns the LGWeights of the special pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "LGWeights", IsPcgs );


#############################################################################
##
#A  LGLayers( <pcgs> )
##
##  <#GAPDoc Label="LGLayers">
##  <ManSection>
##  <Attr Name="LGLayers" Arg='pcgs'/>
##
##  <Description>
##  returns the layers of the special pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "LGLayers", IsPcgs );


#############################################################################
##
#A  LGFirst( <pcgs> )
##
##  <#GAPDoc Label="LGFirst">
##  <ManSection>
##  <Attr Name="LGFirst" Arg='pcgs'/>
##
##  <Description>
##  returns the first indices for each layer of the special pcgs <A>pcgs</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "LGFirst", IsPcgs );

#############################################################################
##
#A  LGLength( <G> )
##
##  <#GAPDoc Label="LGLength">
##  <ManSection>
##  <Attr Name="LGLength" Arg='G'/>
##
##  <Description>
##  returns the length of the LG-series of the group <A>G</A>,
##  if <A>G</A> is  solvable, and <K>fail</K> otherwise.
##
##  <Example><![CDATA[
##  gap> G := SmallGroup( 96, 220 );
##  <pc group of size 96 with 6 generators>
##  gap> spec := SpecialPcgs( G );
##  Pcgs([ f1, f2, f3, f4, f5, f6 ])
##  gap> LGWeights(spec);
##  [ [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 1, 3 ], 
##    [ 1, 2, 2 ] ]
##  gap> LGLayers(spec);
##  [ 1, 1, 1, 1, 2, 3 ]
##  gap> LGFirst(spec);
##  [ 1, 5, 6, 7 ]
##  gap> LGLength( G );
##  3
##  gap> p := SpecialPcgs( Pcgs( SmallGroup( 96, 120 ) ) );
##  Pcgs([ f1, f2, f3, f4, f5, f6 ])
##  gap> LGWeights(p);
##  [ [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 1, 2 ], [ 1, 2, 2 ], [ 1, 3, 2 ], 
##    [ 2, 1, 3 ] ]
##  ]]></Example>
##  <P/>
##  Thus the first group, <C>SmallGroup(96, 220)</C>, has a lower nilpotent
##  series of length <M>1</M>; that is, the group is nilpotent.
##  It is a direct product of its Sylow subgroups.
##  Moreover the Sylow <M>2</M>-subgroup is generated by the elements
##  <C>f1, f2, f3, f4, f6</C>,
##  and the Sylow <M>3</M>-subgroup is generated by <C>f5</C>.
##  The lower <M>2</M>-central series of the Sylow <M>2</M>-subgroup
##  has length <M>2</M> and the second subgroup in this series is generated
##  by <C>f6</C>.
##  <P/>
##  The second group, <C>SmallGroup(96, 120)</C>, has a lower nilpotent
##  series of length <M>2</M> and hence is not nilpotent.
##  The second subgroup in this series is just the Sylow <M>3</M>-subgroup
##  and it is generated by <C>f6</C>.
##  The subgroup generated by <C>f1</C>, <M>\ldots</M>, <C>f5</C> is a
##  Sylow <M>2</M>-subgroup of the group and also a head complement to the
##  second head of the group.
##  Its lower <M>2</M>-central series has length <M>2</M>.
##  <P/>
##  In this example the <Ref Attr="FamilyPcgs"/> value of the groups used
##  was a special pcgs, but this is not necessarily the case.
##  For performance reasons it can be worth to enforce this,
##  see&nbsp;<Ref Attr="IsomorphismSpecialPcGroup"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "LGLength", IsGroup );

#############################################################################
##
#A  InducedPcgsWrtSpecialPcgs( <G> )
##
##  <#GAPDoc Label="InducedPcgsWrtSpecialPcgs">
##  <ManSection>
##  <Attr Name="InducedPcgsWrtSpecialPcgs" Arg='G'/>
##
##  <Description>
##  computes an induced pcgs with respect to the special pcgs of the
##  parent of <A>G</A>.
##  <P/>
##  <Ref Attr="InducedPcgsWrtSpecialPcgs"/> will return a pcgs induced by
##  <E>a</E> special pcgs (which might differ from the one you had in mind).
##  If you need an induced pcgs compatible with a <E>given</E> special pcgs
##  use <Ref Oper="InducedPcgs"/> for this special pcgs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "InducedPcgsWrtSpecialPcgs", IsGroup );


#############################################################################
##
#A  CanonicalPcgsWrtSpecialPcgs( <G> )
##
##  <ManSection>
##  <Attr Name="CanonicalPcgsWrtSpecialPcgs" Arg='G'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareAttribute( "CanonicalPcgsWrtSpecialPcgs", IsGroup );


#############################################################################
##
#P  IsInducedPcgsWrtSpecialPcgs( <pcgs> )
##
##  <#GAPDoc Label="IsInducedPcgsWrtSpecialPcgs">
##  <ManSection>
##  <Prop Name="IsInducedPcgsWrtSpecialPcgs" Arg='pcgs'/>
##
##  <Description>
##  tests whether <A>pcgs</A> is induced with respect to a special pcgs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsInducedPcgsWrtSpecialPcgs", IsPcgs );
InstallTrueMethod( IsPcgs, IsInducedPcgsWrtSpecialPcgs );


#############################################################################
##
#P  IsCanonicalPcgsWrtSpecialPcgs( <pcgs> )
##
##  <ManSection>
##  <Prop Name="IsCanonicalPcgsWrtSpecialPcgs" Arg='pcgs'/>
##
##  <Description>
##  </Description>
##  </ManSection>
##
DeclareProperty( "IsCanonicalPcgsWrtSpecialPcgs", IsPcgs );
InstallTrueMethod( IsPcgs, IsCanonicalPcgsWrtSpecialPcgs );
