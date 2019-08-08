#############################################################################
##
##  The rest of this file implements the operations for IsDirectProductDomain
##  domains.
##
InstallGlobalFunction(DirectProductFamily,
function(args)
    if not IsDenseList(args) or not ForAll(args, IsCollectionFamily) then
        ErrorNoReturn("<args> must be a dense list of collection families");
    fi;
    return CollectionsFamily(
        DirectProductElementsFamily(List(args, ElementsFamily))
    );
end);


#############################################################################
##
InstallMethod(DirectProductDomain,
"for a dense list (of domains)",
[IsDenseList],
function(args)
    local directProductFamily, type;
    if not ForAll(args, IsDomain) then
        ErrorNoReturn("args must be a dense list of domains");
    fi;
    directProductFamily := DirectProductFamily(List(args, FamilyObj));
    type := NewType(directProductFamily,
                     IsDirectProductDomain and IsAttributeStoringRep);
    return ObjectifyWithAttributes(rec(), type,
                                    ComponentsOfDirectProductDomain, args);
end);

InstallOtherMethod(DirectProductDomain,
"for a domain and a nonnegative integer",
[IsDomain, IsInt],
function(dom, k)
    local directProductFamily, type;
    if k < 0 then
        ErrorNoReturn("<k> must be a nonnegative integer");
    fi;
    directProductFamily := DirectProductFamily(
        ListWithIdenticalEntries(k, FamilyObj(dom))
    );
    type := NewType(directProductFamily,
                     IsDirectProductDomain and IsAttributeStoringRep);
    return ObjectifyWithAttributes(rec(),
                                    type,
                                    ComponentsOfDirectProductDomain,
                                    ListWithIdenticalEntries(k, dom));
end);

InstallMethod(PrintObj,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
function(dom)
    local components, i;
    Print("DirectProductDomain([ ");
    components := ComponentsOfDirectProductDomain(dom);
    for i in [1 .. Length(components)] do
        PrintObj(components[i]);
        if i < Length(components) then
            Print(", ");
        fi;
    od;
    Print(" ])");
end);

InstallMethod(Size,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
function(dom)
    local size, comp;
    size := 1;
    for comp in ComponentsOfDirectProductDomain(dom) do
        size := Size(comp) * size;
    od;
    return size;
end);

InstallMethod(DimensionOfDirectProductDomain,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
dom -> Length(ComponentsOfDirectProductDomain(dom)));

InstallMethod(\in,
"for an IsDirectProductDomain",
[IsDirectProductElement, IsDirectProductDomain],
function(elm, dom)
    local components, i;
    if Length(elm) <> DimensionOfDirectProductDomain(dom) then
        return false;
    fi;
    components := ComponentsOfDirectProductDomain(dom);
    for i in [1 .. Length(components)] do
        if not elm[i] in components[i] then
            return false;
        fi;
    od;
    return true;
end);

InstallMethod(AsList,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
function(dom)
    local bijection;
    bijection := BijectiveMappingFromRangeToDirectProductDomain(dom);
    return List([1 .. Size(dom)], x -> ImageElm(bijection, x));
end);

InstallMethod(Enumerator,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
AsList);

#############################################################################
##
InstallGlobalFunction(BijectiveMappingFromDirectProductDomainToRange,
function(dom)
    local comps, nrComps, sizes, productsOfSizes, compsAsSets,
        rangeFirstValues, fun, invFun, range, i;
    if not IsAttributeStoringRep(dom)
            or not IsDirectProductDomain(dom) then
        ErrorNoReturn("<dom> must be an attribute storing ",
                      "IsDirectProductDomain");
    fi;
    if IsEmpty(dom) then
        range := Domain(CollectionsFamily(CyclotomicsFamily), []);
        return MappingByFunction(dom, range, x -> 0, x -> 0);
    elif 0 = DimensionOfDirectProductDomain(dom) then
        range := Domain([1]);
        return MappingByFunction(dom, range,
                                 x -> 1, x -> DirectProductElement([]));
    fi;
    range := Domain([1 .. Size(dom)]);
    comps := ComponentsOfDirectProductDomain(dom);
    nrComps := Length(comps);
    sizes := List(comps, Size);
    compsAsSets := List(comps, AsSet);
    # We compute the bijection into the range
    # [1 .. Size(dom)] as follows:
    # Let d := nrComps, for i <= d let n_i := Size(comps[i]), and let
    # p_i := n_d * ... * n_{i + 1}. Note p_d = 1.
    # For an element e of dom denote by
    # a_i the value Position(compsAsSets[i], e) - 1.
    # Then we map e to
    #   1 + \sum a_i * p_i.
    # We use a specialised function if all components are ranges:
    if ForAll(compsAsSets, IsRangeRep) then
        rangeFirstValues := List(compsAsSets, x -> x[1]);
        fun := function(x)
            local sum, i;
            sum := 0
                + x[1] - rangeFirstValues[1];
            for i in [2 .. nrComps] do
                sum := sum * sizes[i]
                    + (x[i] - rangeFirstValues[i]);
            od;
            return 1 + sum;
        end;
    else
        fun := function(x)
            local sum, i;
            sum := 0
                + PositionSorted(compsAsSets[1], x[1]) - 1;
            for i in [2 .. nrComps] do
                sum := sum * sizes[i]
                    + PositionSorted(compsAsSets[i], x[i]) - 1;
            od;
            return 1 + sum;
        end;
    fi;
    invFun := function(x)
        local tuple, currentComp, rem, i;
        tuple := [];
        # Correction since lists don't start at 0.
        x := x - 1;
        currentComp := compsAsSets[nrComps];
        rem := RemInt(x, sizes[nrComps]);
        tuple[nrComps] := currentComp[rem + 1];
        for i in [nrComps - 1 , nrComps - 2 .. 1] do
            x := (x - rem) / sizes[i + 1];
            currentComp := compsAsSets[i];
            rem := RemInt(x, sizes[i]);
            tuple[i] := currentComp[rem + 1];
        od;
        return DirectProductElement(tuple);
    end;
    return MappingByFunction(dom, range, fun, invFun);
end);

InstallGlobalFunction(BijectiveMappingFromRangeToDirectProductDomain,
dom -> InverseGeneralMapping(
    BijectiveMappingFromDirectProductDomainToRange(dom)
));
