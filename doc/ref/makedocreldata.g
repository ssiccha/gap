#############################################################################
##
##  values for the `MakeGAPDocDoc' call that builds the Reference Manual
##

GAPInfo.ManualDataRef:= rec(
  pathtodoc:= ".",
  main:= "main.xml",
  bookname:= "ref",
  pathtoroot:= "../..",

  files:= [
    "../../src/sysfiles.c",
    "../../grp/basic.gd",
    "../../grp/classic.gd",
    "../../grp/perf.gd",
    "../../grp/ree.gd",
    "../../grp/suzuki.gd",
    "../../lib/addmagma.gd",
    "../../lib/algebra.gd",
    "../../lib/algfld.gd",
    "../../lib/algfp.gd",
    "../../lib/alghom.gd",
    "../../lib/alghom.gi",
    "../../lib/alglie.gd",
    "../../lib/algrep.gd",
    "../../lib/arith.gd",
    "../../lib/attr.gd",
    "../../lib/basis.gd",
    "../../lib/basismut.gd",
    "../../lib/bitfields.gd",
    "../../lib/boolean.g",
    "../../lib/clas.gd",
    "../../lib/cache.gd",
    "../../lib/cmdledit.g",
    "../../lib/coll.gd",
    "../../lib/colorprompt.g",
    "../../lib/combinat.gd",
    "../../lib/contfrac.gd",
    "../../lib/csetgrp.gd",
    "../../lib/ctbl.gd",
    "../../lib/ctbl.gi",
    "../../lib/ctblauto.gd",
    "../../lib/ctblfuns.gd",
    "../../lib/ctblgrp.gd",
    "../../lib/ctbllatt.gd",
    "../../lib/ctblmaps.gd",
    "../../lib/ctblmoli.gd",
    "../../lib/ctblmono.gd",
    "../../lib/ctblpope.gd",
    "../../lib/ctblsolv.gd",
    "../../lib/ctblsymm.gd",
    "../../lib/cyclotom.g",
    "../../lib/cyclotom.gd",
    "../../lib/cyclotom.gi",
    "../../lib/dict.gd",
    "../../lib/domain.gd",
    "../../lib/extlset.gd",
    "../../lib/factgrp.gd",
    "../../lib/ffe.gd",
    "../../lib/field.gd",
    "../../lib/files.gd",
    "../../lib/filter.g",
    "../../lib/filter.gi",
    "../../lib/fitfree.gd",
    "../../lib/fldabnum.gd",
    "../../lib/float.gd",
    "../../lib/fpmon.gd",
    "../../lib/fpsemi.gd",
    "../../lib/function.g",
    "../../lib/galois.gd",
    "../../lib/gasman.gd",
    "../../lib/ghom.gd",
    "../../lib/ghomfp.gd",
    "../../lib/ghompcgs.gd",
    "../../lib/ghomperm.gd",
    "../../lib/global.gd",
    "../../lib/gpprmsya.gd",
    "../../lib/gprd.gd",
    "../../lib/groebner.gd",
    "../../lib/grp.gd",
    "../../lib/grpffmat.gd",
    "../../lib/grpfp.gd",
    "../../lib/grpfree.gd",
    "../../lib/grplatt.gd",
    "../../lib/grpmat.gd",
    "../../lib/grpnames.gd",
    "../../lib/grpnice.gd",
    "../../lib/grppc.gd",
    "../../lib/grppccom.gd",
    "../../lib/grppcext.gd",
    "../../lib/grppcfp.gd",
    "../../lib/grppclat.gd",
    "../../lib/grpperm.gd",
    "../../lib/grpramat.gd",
    "../../lib/grpreps.gd",
    "../../lib/grptbl.gd",
    "../../lib/helpview.gd",
    "../../lib/ideal.gd",
    "../../lib/integer.gd",
    "../../lib/kbsemi.gd",
    "../../lib/kernel.g",
    "../../lib/liefam.gd",
    "../../lib/lierep.gd",
    "../../lib/list.g",
    "../../lib/list.gd",
    "../../lib/listcoef.gd",
    "../../lib/magma.gd",
    "../../lib/mapphomo.gd",
    "../../lib/mapping.gd",
    "../../lib/matblock.gd",
    "../../lib/matint.gd",
    "../../lib/matobj.gi",
    "../../lib/matobj1.gd",
    "../../lib/matobj2.gd",
    "../../lib/matobjplist.gd",
    "../../lib/matrix.gd",
    "../../lib/memusage.gd",
    "../../lib/methsel2.g",
    "../../lib/methwhy.g",
    "../../lib/mgmadj.gd",
    "../../lib/mgmhom.gd",
    "../../lib/mgmring.gd",
    "../../lib/mgmring.gi",
    "../../lib/module.gd",
    "../../lib/monoid.gd",
    "../../lib/morpheus.gd",
    "../../lib/numtheor.gd",
    "../../lib/newprofile.g",
    "../../lib/object.gd",
    "../../lib/object.gi",
    "../../lib/obsolete.gd",
    "../../lib/onecohom.gd",
    "../../lib/oper.g",
    "../../lib/oper1.g",
    "../../lib/oprt.gd",
    "../../lib/options.gd",
    "../../lib/orders.gd",
    "../../lib/package.gd",
    "../../lib/padics.gd",
    "../../lib/pager.gd",
    "../../lib/pcgs.gd",
    "../../lib/pcgsind.gd",
    "../../lib/pcgsmodu.gd",
    "../../lib/pcgspcg.gd",
    "../../lib/pcgsspec.gd",
    "../../lib/permutat.g",
    "../../lib/polyconw.gd",
    "../../lib/polyrat.gd",
    "../../lib/pquot.gd",
    "../../lib/primality.gd",
    "../../lib/process.gd",
    "../../lib/productdomain.gd",
    "../../lib/productdomain.gi",
    "../../lib/profile.g",
    "../../lib/proto.gd",
    "../../lib/randiso.gd",
    "../../lib/random.gd",
    "../../lib/ratfun.gd",
    "../../lib/record.gd",
    "../../lib/reesmat.gd",
    "../../lib/relation.gd",
    "../../lib/reread.g",
    "../../lib/ring.gd",
    "../../lib/ringhom.gd",
    "../../lib/ringpoly.gd",
    "../../lib/ringsc.gd",
    "../../lib/rws.gd",
    "../../lib/rwsgrp.gd",
    "../../lib/rwspcclt.gd",
    "../../lib/rwspcgrp.gd",
    "../../lib/rwssmg.gd",
    "../../lib/schur.gd",
    "../../lib/schursym.gd",
    "../../lib/semicong.gd",
    "../../lib/semigrp.gd",
    "../../lib/semiquo.gd",
    "../../lib/semirel.gd",
    "../../lib/semiring.gd",
    "../../lib/semitran.gd",
    "../../lib/set.gd",
    "../../lib/sgpres.gd",
    "../../lib/smgideal.gd",
    "../../lib/stbc.gd",
    "../../lib/stbcbckt.gd",
    "../../lib/straight.gd",
    "../../lib/streams.gd",
    "../../lib/string.g",
    "../../lib/string.gd",
    "../../lib/system.g",
    "../../lib/syntaxtree.gd",
    "../../lib/teaching.g",
    "../../lib/tcsemi.gd",
    "../../lib/test.gi",
    "../../lib/tietze.gd",
    "../../lib/tom.gd",
    "../../lib/trans.gd",
    "../../lib/tuples.gd",
    "../../lib/twocohom.gd",
    "../../lib/type.g",
    "../../lib/type.gd",
    "../../lib/type.gi",
    "../../lib/type1.g",
    "../../lib/unknown.gd",
    "../../lib/upoly.gd",
    "../../lib/userpref.g",
    "../../lib/variable.g",
    "../../lib/vecmat.gd",
    "../../lib/vspc.gd",
    "../../lib/vspchom.gd",
    "../../lib/word.gd",
    "../../lib/wordass.gd",
    "../../lib/zlattice.gd",
    "../../lib/zmodnz.gd",
    "../../grp/simple.gd",
    "../../tst/teststandard.g",
    "../../tst/testinstall.g",
  ],
 );;
