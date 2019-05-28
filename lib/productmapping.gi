#############################################################################
##
#   DirectProductMapping
# TODO Make this an action homomorphism if each arg is an IsActionHomomorphism
# TODO Install specialised IsSurjective function
InstallGlobalFunction(DirectProductMapping,
function(args)
    local source, range, fun, dim, prefun;
    if not IsDenseList(args) or not ForAll(args, IsGeneralMapping) then
        ErrorNoReturn("<args> must be a dense list of general mappings");
    fi;
    source := Source(args[1]);
    if not ForAll(args, x -> IsIdenticalObj(source, Source(x)))
            and not ForAll(args, x -> source = Source(x)) then
        ErrorNoReturn("the sources of the elements of <args> must be equal");
    fi;
    range := DirectProductDomain(List(args, Range));
    fun := x -> DirectProductElement(
        List(args, f -> Image(f, x))
    );
    dim := Length(args);
    # TODO This actually computes all preimages. Should we install this as a
    # specialised function somehow? This may be helpful if the arguments are
    # IsMappingByPreimages's. Note: introduce IsMappingByPreimages type and
    # install specialised PreImagesElm method. Maybe also a specialised
    # PreImagesRepresentative method and do not use the `!.prefun` component
    # anymore?
    # Note that Intersection returns a set. We need to choose an element now.
    prefun := tup -> Intersection(
        List([1 .. dim], i -> PreImages(args[i], tup[i]))
    )[1];
    # We can check cheaply whether the direct product map is a bijection:
    # - check whether components are surjective
    # - compare size of domain and range
    # Does this also yield a criterion for when the product map is injective?
    return MappingByFunction(source, range, fun, false, prefun);
end);

# source := AsList(Source(map)).
# The result pi permutes [1..Size(source)] so that
#   Image(source[i], map) = source[i ^ pi]
InstallMethod(PermutationFromAutomorphismMapping,
"for a bijective endo mapping",
[IsEndoMapping and IsBijective],
function(map)
    local sourceAsList, sizeSource, idSourceWithRange, permList;
    sourceAsList := AsList(Source(map));
    sizeSource := Length(sourceAsList);
    idSourceWithRange := PermListList([1..sizeSource], sourceAsList);
    permList := List([1 .. sizeSource],
         i -> Image(map, i ^ idSourceWithRange) ^ (idSourceWithRange ^ -1));
    return PermList(permList);
end);
