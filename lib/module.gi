#############################################################################
##
#W  module.gi                   GAP library                     Thomas Breuer
##
##
#Y  Copyright (C)  1997,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St Andrews, Scotland
#Y  Copyright (C) 2002 The GAP Group
##
##  This file contains generic methods for modules.
##


#############################################################################
##
#M  LeftModuleByGenerators( <R>, <gens> )
#M  LeftModuleByGenerators( <R>, <gens>, <zero> )
##
##  Create the <R>-left module generated by <gens>,
##  with zero element <zero>.
##
InstallMethod( LeftModuleByGenerators,
    "for ring and collection",
    [ IsRing, IsCollection ],
    function( R, gens )
    local V;
    V:= Objectify( NewType( FamilyObj( gens ),
                            IsLeftModule and IsAttributeStoringRep ),
                   rec() );
    SetLeftActingDomain( V, R );
    SetGeneratorsOfLeftModule( V, AsList( gens ) );

    CheckForHandlingByNiceBasis( R, gens, V, false );
    return V;
    end );

InstallMethod( LeftModuleByGenerators,
    "for ring, homogeneous list, and vector",
    [ IsRing, IsHomogeneousList, IsObject ],
    function( R, gens, zero )
    local V;

    V:= Objectify( NewType( CollectionsFamily( FamilyObj( zero ) ),
                            IsLeftModule and IsAttributeStoringRep ),
                   rec() );
    SetLeftActingDomain( V, R );
    SetGeneratorsOfLeftModule( V, AsList( gens ) );
    SetZero( V, zero );
    if IsEmpty( gens ) then
      SetDimension( V, 0 );
    fi;

    CheckForHandlingByNiceBasis( R, gens, V, zero );
    return V;
    end );


#############################################################################
##
#M  AsLeftModule( <R>, <D> )  . . . . . domain <D>, viewed as left <R>-module
##
InstallMethod( AsLeftModule,
    "generic method for a ring and a collection",
    [ IsRing, IsCollection ],
    function ( R, D )
    local   S,  L;

    D := AsSSortedList( D );
    L := ShallowCopy( D );
    S := TrivialSubmodule( LeftModuleByGenerators( R, D ) );
    SubtractSet( L, AsSSortedList( S ) );
    while not IsEmpty(L)  do
        S := ClosureLeftModule( S, L[1] );
        SubtractSet( L, AsSSortedList( S ) );
    od;
    if Length( AsSSortedList( S ) ) <> Length( D )  then
        return fail;
    fi;
    S := LeftModuleByGenerators( R, GeneratorsOfLeftModule( S ) );
    SetAsSSortedList( S, D );
    SetIsFinite( S, true );
    SetSize( S, Length( D ) );

    # return the left module
    return S;
    end );


#############################################################################
##
#M  AsLeftModule( <R>, <M> )  . . . . . . . . . . .  for ring and left module
##
##  View the left module <M> as a left module over the ring <R>.
##
InstallMethod( AsLeftModule,
    " for a ring and a left module",
    [ IsRing, IsLeftModule ],
    function( R, M )
    local W,        # the space, result
          base,     # basis vectors of field extension
          gen,      # loop over generators of `V'
          b,        # loop over `base'
          gens,     # generators of `V'
          newgens;  # extended list of generators

    if R = LeftActingDomain( M ) then

      # No change of the left acting domain is necessary.
      return M;

    elif IsSubset( R, LeftActingDomain( M ) ) then

      # Check whether `M' is really a module over the bigger field,
      # that is, whether the set of elements does not change.
      base:= BasisVectors( Basis( AsField( LeftActingDomain( M ), R ) ) );
#T generalize `AsField', at least to `AsAlgebra'!
      for gen in GeneratorsOfLeftModule( M ) do
        for b in base do
          if not b * gen in M then

            # The extension would change the set of elements.
            return fail;

          fi;
        od;
      od;

      # Construct the left module.
      W:= LeftModuleByGenerators( R, GeneratorsOfLeftModule(M), Zero(M) );

    elif IsSubset( LeftActingDomain( M ), R ) then

      # View `M' as a module over a smaller ring.
      # For that, the list of generators must be extended.
      gens:= GeneratorsOfLeftModule( M );
      if IsEmpty( gens ) then
        W:= LeftModuleByGenerators( R, [], Zero( M ) );
      else

        base:= BasisVectors( Basis( AsField( R, LeftActingDomain( M ) ) ) );
#T generalize `AsField', at least to `AsAlgebra'!
        newgens:= [];
        for b in base do
          for gen in gens do
            Add( newgens, b * gen );
          od;
        od;
        W:= LeftModuleByGenerators( R, newgens );

      fi;

    else

      # View `M' first as module over the intersection of rings,
      # and then over the desired ring.
      return AsLeftModule( R,
                 AsLeftModule( Intersection2( R, LeftActingDomain( M ) ),
                               M ) );

    fi;

    UseIsomorphismRelation( M, W );
    UseSubsetRelation( M, W );
    return W;
    end );


#############################################################################
##
#M  SetGeneratorsOfLeftModule( <M>, <gens> )
##
##  If <M> is a free left module and <gens> is a finite list then <M> is
##  finite dimensional.
##
InstallMethod( SetGeneratorsOfLeftModule,
    "method that checks for `IsFiniteDimensional'",
    IsIdenticalObj,
    [ IsFreeLeftModule and IsAttributeStoringRep, IsList ],
  function( M, gens )
    SetIsFiniteDimensional( M, IsFinite( gens ) );
    TryNextMethod();
  end );


#############################################################################
##
#M  Characteristic( <M> ) . . . . . . . . . . characteristic of a left module
##
##  Do we have and/or need a replacement method?


#############################################################################
##
#M  Representative( <D> ) .  representative of a left operator additive group
##
InstallMethod( Representative,
    "for left operator additive group with known generators",
    [ IsLeftOperatorAdditiveGroup
      and HasGeneratorsOfLeftOperatorAdditiveGroup ],
    RepresentativeFromGenerators( GeneratorsOfLeftOperatorAdditiveGroup ) );


#############################################################################
##
#M  Representative( <D> ) . representative of a right operator additive group
##
InstallMethod( Representative,
    "for right operator additive group with known generators",
    [ IsRightOperatorAdditiveGroup
      and HasGeneratorsOfRightOperatorAdditiveGroup ],
    RepresentativeFromGenerators( GeneratorsOfRightOperatorAdditiveGroup ) );


#############################################################################
##
#M  ClosureLeftModule( <V>, <a> ) . . . . . . . . .  closure of a left module
##
InstallMethod( ClosureLeftModule,
    "for left module and vector",
    IsCollsElms,
    [ IsLeftModule, IsVector ],
    function( V, w )

    # if possible test if the element lies in the module already
    if w in GeneratorsOfLeftModule( V ) or
       ( HasAsList( V ) and w in AsList( V ) ) then
      return V;
    fi;

    # Otherwise make a new module.
    return LeftModuleByGenerators( LeftActingDomain( V ),
                           Concatenation( GeneratorsOfLeftModule( V ),
                                          [ w ] ) );
    end );


#############################################################################
##
#M  ClosureLeftModule( <V>, <W> ) . . . . . . . . .  closure of a left module
##
InstallOtherMethod( ClosureLeftModule,
    "for two left modules",
    IsIdenticalObj,
    [ IsLeftModule, IsLeftModule ],
    function( V, W )
    local C, v;
    if LeftActingDomain( V ) = LeftActingDomain( W ) then
      C:= V;
      for v in GeneratorsOfLeftModule( W ) do
        C:= ClosureLeftModule( C, v );
      od;
      return C;
    else
      return ClosureLeftModule( V, AsLeftModule( LeftActingDomain(V), W ) );
    fi;
    end );


#############################################################################
##
#M  \+( <U1>, <U2> )  . . . . . . . . . . . . . . . . sum of two left modules
##
InstallOtherMethod( \+,
    "for two left modules",
    IsIdenticalObj,
    [ IsLeftModule, IsLeftModule ],
    function( V, W )

    local S;          # sum of <V> and <W>, result

    if LeftActingDomain( V ) <> LeftActingDomain( W ) then
      S:= Intersection2( LeftActingDomain( V ), LeftActingDomain( W ) );
      S:= \+( AsLeftModule( S, V ), AsLeftModule( S, W ) );
    elif IsEmpty( GeneratorsOfLeftModule( V ) ) then
      S:= W;
    else
      S:= LeftModuleByGenerators( LeftActingDomain( V ),
                           Concatenation( GeneratorsOfLeftModule( V ),
                                          GeneratorsOfLeftModule( W ) ) );
    fi;

    return S;
    end );


#############################################################################
##
#F  Submodule( <M>, <gens> )  . . . . .  submodule of <M> generated by <gens>
#F  SubmoduleNC( <M>, <gens> )
#F  Submodule( <M>, <gens>, "basis" )
#F  SubmoduleNC( <M>, <gens>, "basis" )
##
InstallGlobalFunction( Submodule, function( arg )
    local M, gens, S;

    # Check the arguments.
    if Length( arg ) < 2
       or not IsLeftModule( arg[1] )
       or not (IsEmpty(arg[2]) or IsCollection( arg[2] )) then
      Error( "first argument must be a left module, second a collection\n" );
    fi;

    # Get the arguments.
    M    := arg[1];
    gens := AsList( arg[2] );

    if IsEmpty( gens ) then
      return SubmoduleNC( M, gens );
    elif     IsIdenticalObj( FamilyObj( M ), FamilyObj( gens ) )
         and IsSubset( M, gens ) then
      S:= LeftModuleByGenerators( LeftActingDomain( M ), gens );
      SetParent( S, M );
      if Length( arg ) = 3 and arg[3] = "basis" then
        UseBasis( S, gens );
      fi;
      UseSubsetRelation( M, S );
      
      #
      # These cannot be handled by UseSubsetRelation, because they
      # depend on M and S having the same LeftActingDomain
      #
      if IsRowModule(M) then
          SetIsRowModule(S, true);
          SetDimensionOfVectors(S,DimensionOfVectors(M));
      elif IsMatrixModule( M ) then
        SetIsMatrixModule( S, true );
        SetDimensionOfVectors( S, DimensionOfVectors( M ) );
      fi;
      if IsGaussianSpace(M) then
          SetFilterObj(S, IsGaussianSpace);
      fi;
      return S;
    fi;

    Error( "usage: Submodule( <M>, <gens> [, \"basis\"] )" );
end );

InstallGlobalFunction( SubmoduleNC, function( arg )
    local S;
    if IsEmpty( arg[2] ) then
      S:= Objectify( NewType( FamilyObj( arg[1] ),
                                  IsFreeLeftModule
                              and IsTrivial
                              and IsAttributeStoringRep ),
                     rec() );
      SetDimension( S, 0 );
      SetLeftActingDomain( S, LeftActingDomain( arg[1] ) );
      SetGeneratorsOfLeftModule( S, AsList( arg[2] ) );
    else
      S:= LeftModuleByGenerators( LeftActingDomain( arg[1] ), arg[2] );
    fi;
    if Length( arg ) = 3 and arg[3] = "basis" then
      UseBasis( S, arg[2] );
    fi;
    SetParent( S, arg[1] );
    UseSubsetRelation( arg[1], S );
      
    #
    # These cannot be handled by UseSubsetRelation, because they
    # depend on M and S having the same LeftActingDomain
    #
    if IsRowModule(arg[1]) then
        SetIsRowModule(S, true);
        SetDimensionOfVectors(S, DimensionOfVectors(arg[1]));
    elif IsMatrixModule( arg[1] ) then
      SetIsMatrixModule( S, true );
      SetDimensionOfVectors( S, DimensionOfVectors( arg[1] ) );
    fi;
    if IsGaussianSpace(arg[1]) then
        SetFilterObj(S, IsGaussianSpace);
    fi;
    return S;
end );


#############################################################################
##
#M  TrivialSubadditiveMagmaWithZero( <M> )  . . . . . . . . for a left module
##
InstallMethod( TrivialSubadditiveMagmaWithZero,
    "generic method for left modules",
    [ IsLeftModule ],
    M -> SubmoduleNC( M, [] ) );


#############################################################################
##
#M  DimensionOfVectors( <M> ) . . . . . . . . . . . . . . . for a left module
##
InstallMethod( DimensionOfVectors,
    "generic method for left modules",
    [ IsFreeLeftModule ],
    function( M )

    M:= Representative( M );
    if IsMatrix( M ) then
      return DimensionsMat( M );
    elif IsRowVector( M ) then
      return Length( M );
    else
      TryNextMethod();
    fi;
    end );


# This setter method is installed to implement filter settings in response
# to an objects size as part of setting the size. This used to be handled
# instead by immediate methods, but in a situation as here it would trigger
# multiple immediate methods, several of which could apply and each changing
# the type of the object. Doing so can be costly and thus should be
# avoided.
InstallOtherMethod(SetDimension,true,[IsObject and IsAttributeStoringRep,IsObject],
  100, # override system setter
function(obj,dim)
local filt;
  if HasDimension(obj) and IsBound(obj!.Dimension) then
    Assert(2, Dimension(obj) = dim);
    return;
  fi;
  if dim=0 then
    filt := IsTrivial and IsFiniteDimensional;
  elif dim = infinity then
    filt := IsNonTrivial and HasIsFiniteDimensional and HasIsFinite;
  else
    filt := IsNonTrivial and IsFiniteDimensional;
  fi;
  filt := filt and HasDimension;
  obj!.Dimension := dim;
  SetFilterObj(obj, filt);
end);
