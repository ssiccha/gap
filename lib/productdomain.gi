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
    local bijections, domAsList;
    bijections := BijectionsBetweenDirectProductDomainAndRange(dom);
    domAsList := List([1 .. Size(dom)], bijections.elementPosition);
    if bijections.canSort then
        SetIsSSortedList(domAsList, true);
    fi;
    return domAsList;
end);

InstallMethod(Enumerator,
"for an IsDirectProductDomain",
[IsDirectProductDomain],
function(dom)
    local bijections, elementPosition, positionElement, elementNumber,
        numberElement, enumDom;
    bijections := BijectionsBetweenDirectProductDomainAndRange(dom);
    elementPosition := bijections.elementPosition;
    positionElement := bijections.positionElement;
    elementNumber := {dom, pos} -> elementPosition(pos);
    numberElement := {dom, elm} -> positionElement(elm);
    enumDom := EnumeratorByFunctions(dom,
                                     rec(ElementNumber := elementNumber,
                                         NumberElement := numberElement));
    if bijections.canSort then
        SetIsSSortedList(enumDom, true);
    fi;
    return enumDom;
end);

#############################################################################
##
#
# If every component of dom is sortable (see CanEasilySortElements), then the
# bijective mapping we construct will be order preserving.
InstallGlobalFunction(BijectionsBetweenDirectProductDomainAndRange,
function(dom)
    local componentElementFamilies, canSort, comps, nrComps, sizes,
        compsAsLists, elementsFamily, rangeFirstValues, positionElement,
        elementPosition;
    if not IsDirectProductDomain(dom) then
        ErrorNoReturn("<dom> must be an IsDirectProductDomain object");
    fi;
    # Figure out whether every component of dom is sortable.
    # If so we transform them into sets with AsSet and use PositionSorted.
    # Otherwise we have to use AsList and Position.
    componentElementFamilies := ElementsFamily(FamilyObj(dom));
    componentElementFamilies :=
        componentElementFamilies!.ComponentsOfDirectProductElementsFamily;
    canSort := ForAll(componentElementFamilies, CanEasilySortElementsFamily);
    # Handle edge cases
    if IsEmpty(dom) then
        return rec(positionElement := x -> 0,
                   elementPosition := x -> 0,
                   canSort := canSort);
    elif 0 = DimensionOfDirectProductDomain(dom) then
        return rec(positionElement := x -> 1,
                   elementPosition := x -> DirectProductElement([]),
                   canSort := canSort);
    fi;
    # Set up the "constant" variables the bijections will use in every call.
    comps := ComponentsOfDirectProductDomain(dom);
    nrComps := Length(comps);
    sizes := List(comps, Size);
    if canSort then
        compsAsLists := List(comps, AsSet);
    else
        compsAsLists := List(comps, AsList);
    fi;
    elementsFamily := ElementsFamily(FamilyObj(dom));
    # We compute the bijection into the range [1 .. Size(dom)] as follows:
    #     Let d := nrComps, for i <= d let n_i := Size(comps[i]), and let
    #     p_i := n_d * ... * n_{i + 1}. Note p_d = 1.
    #     For an element e of dom denote by
    #     a_i the value Position(compsAsLists[i], e) - 1.
    #     Then we map e to
    #       1 + \sum a_i * p_i.
    # We use a specialised function if all components are ranges. In this case
    # canSort must be true.
    if ForAll(compsAsLists, IsRangeRep) then
        rangeFirstValues := List(compsAsLists, x -> x[1]);
        positionElement := function(x)
            local sum, i;
            sum := 0
                + x[1] - rangeFirstValues[1];
            for i in [2 .. nrComps] do
                sum := sum * sizes[i]
                    + (x[i] - rangeFirstValues[i]);
            od;
            return 1 + sum;
        end;
    elif canSort then
        positionElement := function(x)
            local sum, i;
            sum := 0
                + PositionSorted(compsAsLists[1], x[1]) - 1;
            for i in [2 .. nrComps] do
                sum := sum * sizes[i]
                    + PositionSorted(compsAsLists[i], x[i]) - 1;
            od;
            return 1 + sum;
        end;
    else
        positionElement := function(x)
            local sum, i;
            sum := 0
                + Position(compsAsLists[1], x[1]) - 1;
            for i in [2 .. nrComps] do
                sum := sum * sizes[i]
                    + Position(compsAsLists[i], x[i]) - 1;
            od;
            return 1 + sum;
        end;
    fi;
    elementPosition := function(x)
        local tuple, currentComp, rem, i;
        tuple := [];
        # Correction since lists don't start at 0.
        x := x - 1;
        currentComp := compsAsLists[nrComps];
        rem := RemInt(x, sizes[nrComps]);
        tuple[nrComps] := Immutable(currentComp[rem + 1]);
        for i in [nrComps - 1 , nrComps - 2 .. 1] do
            x := (x - rem) / sizes[i + 1];
            currentComp := compsAsLists[i];
            rem := RemInt(x, sizes[i]);
            tuple[i] := Immutable(currentComp[rem + 1]);
        od;
        # This avoids DirectProductElementNC which copies its second argument.
        # Since we just created `tuple` ourselves we don't need to do that.
        return Objectify(elementsFamily!.defaultTupleType, tuple);
    end;
    return rec(positionElement := positionElement,
               elementPosition := elementPosition,
               canSort := canSort);
end);

InstallGlobalFunction(BijectiveMappingFromDirectProductDomainToRange,
function(dom)
    local range, bijections;
    bijections := BijectionsBetweenDirectProductDomainAndRange(dom);
    if IsEmpty(dom) then
        range := Domain(CollectionsFamily(CyclotomicsFamily), []);
    elif 0 = DimensionOfDirectProductDomain(dom) then
        range := Domain([1]);
    else
        range := Domain([1 .. Size(dom)]);
    fi;
    return MappingByFunction(dom, range,
                             bijections.positionElement,
                             bijections.elementPosition);
end);

InstallGlobalFunction(BijectiveMappingFromRangeToDirectProductDomain,
dom -> InverseGeneralMapping(
    BijectiveMappingFromDirectProductDomainToRange(dom)
));
