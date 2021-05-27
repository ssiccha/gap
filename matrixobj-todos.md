###### tags: `GAP`
# MatrixObj and VectorObj in GAP

Some thoughts for a potential Coding sprint / GAP Days focused on advancing MatrixObj/VectorObj

## What is MatrixObj/VectorObj about?

Here are some links with background info
- https://www.gapdays.de/gapdays2017-spring/10_topic/
- <https://www.gapdays.de/gapdays2017-fall/slides/slides-Horn-MatrixObj.html>
- [Some slides by Thomas Breuer from 2017](https://www.gapdays.de/gapdays2017-fall/slides/slides-Breuer-matrixobj.pdf)

TODO: upload the ref manual for GAP master branch somewhere and add a link to the MatrixObj chapter in there (and/or if GAP 4.12 is released in time, link to that)

## Lists with TODOs.

- Main issue https://github.com/gap-system/gap/issues/945
- Row and column operations https://github.com/gap-system/gap/issues/3962
- Project https://github.com/gap-system/gap/projects/1




# TODO list

This list is a collection of all previous TODO lists. However, it may not be up to date.
### Good first issues (hopefully) 

- help finish PR #2973 -- this updates `IsPlistMatrixRep` to the latest version
  of MatrixObj
- create a "real" MatrixObj instances (e.g. of type `IsPlistMatrixRep` [see
  this PR](https://github.com/gap-system/gap/pull/2973)) and try
  to pass them to all kinds of GAP library functions (and packages!) and see
  what breaks; then try to fix that (possibly after discussing with others
  *how* to fix it)
- implement missing functionality that is needed for the "fixes" in the
  previous step (e.g. clearly we need row/column operations for MatrixObj, see
  issue #3962)
- read the existing documentation and point out what is missing / help
  improving it
- write tutorials/howtos on ...
  - how to use MatrixObj (and why?)
  - how to use implement new MatrixObj types (and perhaps do that, to test it)
  - how to use convert existing code in the library and packages to work with
    MatrixObj (ideally while still working with old-style list-of-list
    matrices)

### Design Decisions

- [ ] Write (or complete) a high level description of the MatrixObj interface;
  in particular, clearly state what a minimal implementation of IsVectorObj
  resp. IsMatrixObj needs to do (what methods to provide...); also explain
  things like "vectors are neither row nor column; product is always scalar
  product"; etc.
  - [ ] write tests which check whether a given concrete MatrixObj type
    implements the API correctly, see section tests.
  - [ ] consider writing the MatrixObj API so that it also works sanely for
    non-commutative base domains. E.g. `MultRowVector` should specify from
    which side it multiplies with scalars, and perhaps even come in both
    variants?
  - Mohamed's wish list:
    - The matrix should always know its ring:
       - allow the zero ring
       - do not require the ring to know all its properties, e.g., that knows
         later that it is the zero ring
       - allow noncommutative (semi)rings.
    - NrRows, NrColumns:
      - allow empty matrices
      - should be attributes not required during creation of the matrix
         (allows implementation of lazy matrices)

- [ ] consider adding an API for MatrixObj which indicates if a given matrix
  obj is stored in row-major or column-major form: Reason: some algorithm are
  only optimal for one or the other. By detecting this, one could rewrite the
  matrix first... or invoke different implementations of the algorithm suitable
  for each rep.... Of course we can add this API later on, it doesn't have to
  be there initially. But note that some reps may be neither and/or both (think
  of sparse reps; or block matrices with submatrices of different types --
  though perhaps the latter should simply not be done ;-)

- Decide the relation between `IsMatrix` and `IsMatrixObj`.
  (September 08th)
  We are going to use the following setup:
  - Introduce `IsMatrixOrMatrixObj`
    [#4503](https://github.com/gap-system/gap/issues/4503)
  - `IsMatrixObj` does not imply `IsOrdinaryMatrix`.
    - All current implementations of `IsMatrixObj` representations
      are in fact intended for matrices with the ``usual`` matrix product
      and hence get the filter `IsOrdinaryMatrix` (explicitly)
    - Whenever a method requires that some of its arguments are matrices
      that have to be multiplied via the ``usual`` matrix product,
      the filter `IsOrdinaryMatrix` must be required for these arguments.

  (Thomas is going to make the necessary changes.)

- Decide and document what `ShallowCopy` should do for IsVectorObj 
  and IsMatrixObj objects. 
  Idea: For IsVectorObj define and document similar behaviour as for
  plain lists. For IsMatrixObj document it explicitly as undefined
  (but some implementations may provide a method); suggest to use
  `MutableCopyMat` for IsMatrixObj objects.

- When multiplying PlistMatrixObjs we check whether the BaseDomains are
  identical. Should we adopt this everywhere?
  matobj2.gd states that +,-,*,<,=, AddRowVector, AddMultVector are possible
  for vectors over the same BaseDomain and equal lengths.
  Should this mean `only if`?

  (For example objects in `Is8BitVectorRep` admit arithmetical operations
  when the lengths are different.  I would say that the general documentation
  should define the behaviour only for same lengths and equal BaseDomain,
  and say that special vector representations may support more general
  cases.)

  If the identity of the `BaseDomain`s of two matrices is a necessary
  condition for the applicability of (generic) methods,
  for example for `KroneckerProduct`,
  then the `BaseDomain` for plists of plists must be as large as possible,
  in order to make these methods.
  For plists of plists of cyclotomics, `Cyclotomics` would be suitable.
  For plists of plists of FFE elements, we do not have analogous objects
  (one for each positive characteristic), but we could create them,
  and for matrices of polynomials etc., things are getting complicated.
  Alternatively, we could take the *family of the matrix entries* as the
  `BaseDomain`:
  `One`, `Zero`, `Characteristic` work in principle,
  `IsFinite`, `Size`, `\in` could be provided.
  (With this choice, computing the `BaseDomain` would be cheap, as required.)

  We state explicitly that we do not specify the behaviour if the
  base domains or dimensions or representation types do not fit.
  This is because of efficiency reasons.
  On the other hand, we could suggest to signal an error (with a useful
  error message if possible) except in the following cases:
  - Properties such as `IsOne` can return `false` if a problem occurs
    (such as a non-square matrix).
  - `Inverse` for a not invertible matrix should return `fail`,
    according to the general documentation of `Inverse`.
  (Note that `fail` results make sense only if one can rely on them
  --for *all* matrix object representations, and this is something which
  we do not want to guarentee.)

- We have to define what shall happen if the result of an operation
  is a vector or matrix object but cannot get the same base domain
  the input(s).
  I think this happens only for
  - the division of a vector/matrix by a scalar,
    where some entry of the result is not in the base domain, and
  - the inversion of a matrix that is not invertible over the base domain.
  (Are there other dangerous operations?)
  In such situations, we can either signal an error
  or create a vector/matrix object over a different base domain,
  for example by delegating to `Vector( <list> )` or `Matrix( <list> )`,
  respectively.
  Once we decide what we want, this must be documented,
  and the available methods have to be adjusted.
  
- Attributes for `IsMatrixObj` objects:

  *Storing* rank, determinant, etc. makes sense only for immutable objects;
  it would be dangerous/wrong to store such information in mutable matrices.
  We can still declare `RankMat`, `DeterminantMat`, etc. as attributes,
  since the feature to *store* attributes is deactivated unless one sets
  the filter `IsAttributeStoringRep` or installs special setter methods.
  Thus we could document that we recommend to implement new kinds of matrix
  objects in one of the following ways:

  1. As always *immutable* objects,
     with the possibility to set the filter `IsAttributeStoringRep` or to
     install special attribute setter methods,

  2. as copyable objects (that is, with the possibility to create mutable
     matrices);
     here the filter `IsAttributeStoringRep` should not be set,
     and special attribute setter methods should better not be installed.

  Note that `IsMatrixObj` does currently imply `IsCopyable`.
  We could drop `IsCopyable` from the general `IsMatrixObj` definition,
  and set it whenever mutable versions shall be supported.
  (For example, if the objects returned by `BlockMatrix` would not be lists
  then one could think about removing `IsCopyable` from their type.
  Currently `IsCopyable` is set, and `ShallowCopy` is defined to return
  a deep copy represented via plists.)

  Do we really want to force `IsCopyable` for all vector and matrix
  objects?
  One could think of an implementation where the objects are pointers
  to data files which are just readable.
  In such a situation, it is confusing that the object claims to be
  copyable but `ShallowCopy` or `MutableCopyMatrix` will not work.

- Should more list like operations be added for vector objects?
  For example `Position` and `PositionProperty` would be candidates;
  a comment in an earlier version of the interface states that they
  are left out to simplify the interface.



### New MatrixObj functions, methods, operations, documentation, and tests

- add some proper and complete MatrixObj implementations
  - finish `IsPlistMatrixRep`, see "Easy ways to help"
  - add a "strict" variant of `IsPlistMatrixRep` which shares 98% of the code
    but *removes* some features which are just there to easy compatibility with
    existing code but which cost in terms of performance
    - e.g. support for `mat[i]` returning a row of the matrix (which requires
      use of "proxy objects")
    - such a type is very useful for finding parts of functions that make
      exactly such assumptions about a given matrix
    - [a relevant issue](https://github.com/gap-system/gap/issues/2148)
  - add types of sparse matrices


- Replace `EmptyMatrix` and `NullMapMatrix` by or make them into `IsMatrixObj`
  objects.
  In the library, change GF2 and 8bit matrix code to support empty matrices

- [ ] consider allowing for `0 x n` and `m x 0` matrix objects. These can then
  properly remove existing hacks like `EmptyMatrix`, `EmptyRowVector`,
  `NullMapMatrix`, ...
- [ ] also think about vectors...
  - [ ] we want both row and column vectors
  - [ ] for non-commutative base domains, row vectors should be left module
    elements, while column vectors should be right module elements
  - [ ] we probably should have a `IsVectorObj` and then `IsRowVectorObj` and
    `IsColumnVectorObj` specialize it (indeed, virtually all code for them
    could be identical, it' just a bit that decides whether we interpret
    something as a `1 x n` or `n x 1` 
  - [ ] on the other hand, some people may prefer to lazily allow vectors to be
    both column and row vectors at the same time. This costs us some type
    safety, but maybe be more convenient??? at the very least, it should be
    easy and cheap (=fast) to convert between the two

- generic methods mentioned in matobj{1,2}.gd

- Provide further kinds of vectors/matrices.

#### Done

- introduce `OneOfBaseDomain`, `ZeroOfBaseDomain` (done)

### Adapting the library

- [ ] go through all (well, at least as many as possible) functions in GAP that
  support matrices as input, and teach them to support `MatrixObj`
  - [ ] as this is a herculean effort, also think about ways to allow backwards
    compatibility

- enhance GAP's compressed matrices to a full implementation of MatrixObj
  - e.g. add full support for 0xN and Nx0 matrices
  - run these matrices through the generic test suites being generated
    below, to find and fix any violation
  - [empty compressed vectors](https://github.com/gap-system/gap/issues/2121)
  
- [ ] make it possible to create groups generated by matrix objs, and make
  sure as many things as possible "work" with it; this probably involves
  getting the `NiceMonomorphism` code to deal with MatrixObjs (defined over
  finite fields)
- [ ] look for any places in the library using `IsMatrix` (as a filter), and
  see if we can / should adapt them for IsMatrixObj
- [ ] for certain operations, we probably can use (almost?) the same code for
  `IsMatrix` and `IsMatrixObj`; possibly provide a way to make it easy to
  install a method for both at once -> but first see if there really are
  examples where this would be useful, collect them, then think about how to
  best tackle this
[ ] Deal with `ConvertToVectorRep` / `ConvertToMatrixRep`
- [ ] ideally, we want to get rid of them completely
- [ ] of course lots of package use them, so we also need to work with
  package authors, and provide could migration strategies (possibly
  documented somewhere as well)
- Change method installations that match several declarations
  since `IsMatrix` implies `IsMatrixObj`.
  (For example, `Length` is declared for `IsList`, `IsVectorObj`,
  and `IsMatrixObj`.
  So `Length` methods for `IsMatrix` match two declarations.)

  (Thomas is going to do this.)

- In the (about 240) library methods that *require* `IsMatrix`,
  adjust the code according to the `IsMatrixObj` interface.

- Get rid of `Zero(m[1][1])`, `m[i][j]`, and working with rows.
  Change `m[i][j]` to `m[i,j]`.
  (Only where really matrices are affected?)

- In the (about 90) library methods that *call* `IsMatrix`,
  decide if one can use `IsMatrixObj` instead.

- Check the library methods that *create* matrices:
  What can be done in order to choose a suitable kind of matrix?

- [ ] Make it possible to create groups of MatrixObj matrices with
  `Group([mat1,mat2,...])`.
- [ ] Teach the `NiceMonomorphism` code for groups to support `MatrixObj`

- various operations on gf2 and 8bit matrix objects can silently convert
  them to plists-of-plists; e.g. it is allows to unbind an element in the
  middle, or assign something in cross characteristic, etc. etc. and all of
  these work and silently convert the matrix/vector. I can`t think of
  situations where I`d want that -- I`d really prefer to require the user to
  perform a manual conversion, and instead let accesses like the above
  generate an error, to help track down bugs.

- I'd like to rename `vecmat.{gi,gd}` to e.g. `vecmat_gf2.{gi,gd}`, to
  indicate the purpose of those files; and then move any generic methods for
  (compressed) matrices and vectors in it into another file

- Just remove some downrankings of methods?
  (There are comments in the code that this should be possible
  from GAP 4.10 on.)

- renaming issues:
  - There are functions `RankMat`, `IsDiagonalMat`, etc.
    We should consistently introduce the corresponding names
    `RankMatrix`, `IsDiagonalMatrix`, etc. as main names,
    and keep the `Mat` names as synonyms,
    and also keep these old names as documented if applicable.

  - There are functions `BaseIntMat`, `TriangulizeIntegerMat`, etc.
    Introduce the corresponding names `BaseIntegerMatrix`,
    `TriangulizeIntegerMatrix`, etc. as main names, keep the
    `IntMat` or `IntegerMat` names as synonyms,
    and also keep the old names as documented if applicable.

  - Rename *RowVector to *Vector like AddRowVector to AddVector
  
  - [ ] rename functions like `RankMat` consistently to `RankMatrix`; make sure
    to provide synonyms for the old name, to retain backwards compatibility


- There is a problem with the operation `Matrix`.
  An *attribute* with this name is declared for certain semigroups,
  in `lib/reesmat.gd`.
  In `lib/matobj2.gd`, `Matrix` is declared as a *mutable attribute*
  for lists; if it would not be declared as such then GAP's standard
  machinery would cause that `Matrix( <list> )` returns an *immutable*
  value, which is not acceptable.
  The declaration as a mutable attribute in `lib/matobj2.gd` works
  because this file is read before `lib/reesmat.gd`,
  but the consequence is that the attribute values in the semigroup
  context are also mutable (try the manual example for `Matrix`);
  this is a bug.
  (One could turn any attribute into a mutable one, by adding a
  corresponding declaration early enough.)


#### Done

- [x] add support for `mat[i,j]` to access matrix entries (the syntax is
  already supported, this is mostly about installing suitable methods)
  - [x] perhaps also allow this for plain "lists of lists", to make it easier
    to write code which accepts both lists of lists and MatrixObj?

- Replace `PositionNot( obj, zero )` by `PositionNonZero( obj )`.
  (And change the default methods for `PositionNonZero`.)
  (done)
  
### Adapting the packages
- enhance [`cvec`](https://github.com/gap-packages/cvec) to properly implement MatrixObj/VectorObj
  - the `cvec` package has an alternative implementation of compressed
    vectors and matrices
  - it is based on an older version of the MatrixObj spec
  - it may also be useful to turn off support for `mat[i]` for type cmat,
    at least temporarily, to find places where it still accesses that
- [ ] [`meataxe64` ](https://github.com/gap-packages/meataxe64)
- [ ] Teach `recog` to use `MatrixObj`

### Improvements of exisiting MatrixObj code

- [ ] Go through all the operations/attributes in `matobj2.gd`; then, if we
- decided to keep the...
  - [ ] write a proper documentation comment;
  - [ ] verify that a default implementation has been provided (if applicable),
    else provide one;
  - [ ] write some tests
  - [ ] possibly provide optimized versions for plistrep, 8bit rep, GF2 rep,

- For the various constructors, perhaps imitate what we do
  for e.g. group constructors:
  Allow to omit the filter,
  and try to choose a "good" default representation?

- Replace `ChangedBaseDomain` (which is defined for both vector and
  matrix objects) by `VectorWithChangedBaseDomain`,
  `MatrixWithChangedBasedDomain`.

- Is the ordering of arguments sensible and consistent?
  (For example,
  better define `CopySubMatrix( dst, drows, dcols,  src, srows, scols )`,
  and unify the argument order in `NewMatrix( filt, R, ncols, list )`
  and `Matrix( filt, R, list, ncols )`?
  And what about `NullMat`/`ZeroMatrix` and
  `IdentityMat`/`IdentityMatrix`?)

- Are the argument names sensible and consistent? For example we sometimes
  write "rep" and sometimes "filt" for the same thing.
  And we sometimes write "rows, colss", other times "ncols", or "m,n", or...

- Are the operations for vector and matrix objects consistent?

#### Done

- [x] `RowLength` seems like a really bad idea. I propose that instead we add
  `NumberRows` and `NumberColumns` to the MatrixObj API and ditch `RowLength`.
  Ideally I'd also disallow `Length` for MatrixObj, but perhaps it's useful to
  have it (as alias for NumberRows???) to make transitioning code to using
  MatrixObj easier. _But_ I think it would be better to start without it, and
  see whether we really can benefit from it. I.e. show me code that becomes
  trivially able to use MatrixObj because of Length, and we can keep it... but
  if you have to modify the code anyway, I think changing it to use
  `NumberRows` is better
  
* [x] some love for `foo[i,j]` syntax
  * [x] benchmark it via `foo[i][j]` resp. `MatElm(foo,i,j)`
  * [x] look into replacing the existing non-optimized dispatch code for
    `foo[i,j]` by something that is faster in special cases: Right now,
    `foo[i,j]` translates to `foo[  [i,j] ]` (so a temporary plist is created),
    and then we dispatch generically to methods for `\[\]` resp. `\[\]:=`; we
    could avoid creating the temporary plist, and instead dispatch through
    `MatElm` resp. `SetMatElm`
  * [x] ensure `foo[i,j]` also works for plists-of-plists resp. for `IsMatrix`;
    and in addition, see about extending the hot path from above for this, i.e.
    don't even dispatch through `(Set)MatElm`, but directly modify the list; 
  * [x] perhaps also have hot paths for compressed matrices???

### Tests

- Create generic "parametrized" tests, see [this issue](https://github.com/gap-system/gap/issues/4512)

- Go through GAP library functions for matrices and test each of them with a
  "strict" MatrixObj implementation, and fix them as needed
    - e.g. try to create a group of MatrixObj
    - or try to use the meataxe with such matrices and fix it
    - or try to use the recog package with them
    - once/if a function "works" with proper MatrixObj, add a test which
      verifies this
    - relevant issues: [don't force MatrixObj to be collections?](https://github.com/gap-system/gap/issues/3568)

### Documentation

- [ ] Complete the documentation, see
  http://www.gap-system.org/Manuals/doc/ref/chap26.html

- add entry in programming language section of ref manual for
      x:=A[B];  and A[B]:=x;
  for arbitrary objects B

- Document the interface.

- add entries for [] and []:= to MatrixObj chapter.
  link to these from the list chapter entries for [] and []:= (and vice versa)

- Add a chapter `How to use IsMatrixObj` to the documentation.
  There, add the following sections to the documentation:
  - which Methods should be implemented for new IsMatrixObj types so that
    the generic methods work for all new objects
  - list the generic methods in `matobj.gi`. Say that these can/should be
    overwritten by more efficient specialized code.
  - Changes from IsMatrix to IsMatrixObj
  - how to convert existing IsMatrix code to adapt IsMatrixObj
  - deprecated usages of operations/functions

- The entry for "unbind a list entry" in the Reference Manual is
  syntactically wrong, it is shown as `Unbind( list[, n] )`,
  which means that `n` is an optional argument.
  The problem is that GAPDoc interprets `Arg="list[n]"` this way,
  and inserts the comma.

- Document `PostMakeImmutable`,
  then mention that matrix objects may have to install methods for it.

- How is `WeightOfVector` in the MatrixObj Chapter related to `WeightVecFFE`,
  `DistanceVecFFE`?  Should just `WeightOfVector` be documented?

### Nice to have

- Would it be sensible to have a recursive version of `ShallowCopy`,
  with an optional argument that limits the depth?
  (Note that `StructuralCopy` is not an operation.)
  `MutableCopyMatrix` (which is defined and used in `lib/matrix.g*`
  but is not documented) could then be replaced by a depth 2 call
  of that operation.
  On the other hand, the name `MutableCopyMatrix` is quite suggestive,
  perhaps `MutableCopyVector` would be a better name for `ShallowCopy`.
