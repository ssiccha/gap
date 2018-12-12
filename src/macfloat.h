/****************************************************************************
**
**  This file is part of GAP, a system for computational discrete algebra.
**
**  Copyright of GAP belongs to its developers, whose names are too numerous
**  to list here. Please refer to the COPYRIGHT file for details.
**
**  SPDX-License-Identifier: GPL-2.0-or-later
**
**  This file declares the functions for the macfloat package
*/

#ifndef GAP_MACFLOAT_H
#define GAP_MACFLOAT_H

#include "objects.h"

#ifdef VERY_LONG_DOUBLES
typedef long double /* __float128 */ Double;
#define PRINTFDIGITS 20
#define PRINTFFORMAT "Lg"
#define STRTOD strtold
#define MATH(name) name##l
#else
typedef double Double;
#define PRINTFDIGITS 16
#define PRINTFFORMAT "g"
#define STRTOD strtod
#define MATH(name) name
#endif

static inline Double VAL_MACFLOAT(Obj obj)
{
    Double val;
    memcpy(&val, CONST_ADDR_OBJ(obj), sizeof(Double));
    return val;
}

static inline void SET_VAL_MACFLOAT(Obj obj, Double val)
{
    memcpy(ADDR_OBJ(obj), &val, sizeof(Double));
}

static inline  Int IS_MACFLOAT(Obj obj)
{
    return TNUM_OBJ(obj) == T_MACFLOAT;
}

extern Obj NEW_MACFLOAT(Double val);


/****************************************************************************
**
*F * * * * * * * * * * * * * initialize module * * * * * * * * * * * * * * *
*/

/****************************************************************************
**
*F  InitInfoMacfloat() . . . . . . . . . . . . . . .  table of init functions
*/
StructInitInfo * InitInfoMacfloat(void);


#endif    // GAP_MACFLOAT_H
