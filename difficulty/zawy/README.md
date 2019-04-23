Overview
========
LWMA for BTC clones
Copyright (c) 2017-2018 The Bitcoin Gold developers
Copyright (c) 2018 Zawy (M.I.T license continued)
Algorithm by zawy, a modification of WT-144 by Tom Harding
Code by h4x3rotab of BTC Gold, modified/updated by zawy
https://github.com/zawy12/difficulty-algorithms/issues/3#issuecomment-388386175

Original Instructions
=====================
FTL must be changed to 300 or N*T/20 whichever is higher.
FTL in BTC clones is MAX_FUTURE_BLOCK_TIME in chain.h.
FTL in Ignition, Numus, and others can be found in main.h as DRIFT.
FTL in Zcash & Dash clones need to change the 2*60*60 here:
if (block.GetBlockTime() > nAdjustedTime + 2 * 60 * 60)
which is around line 3450 in main.cpp in ZEC and validation.cpp in Dash

Adding To Code (Script) - Preferred Method
==========================================
Simply run the [addtocode.sh](implementation/addtocode.sh) script **once**:
```
cd implementation
./addtocode.sh
```

Adding To Code (Patch)
======================
There are patch files for vanilla Bitcoin Core in [implementations](implementations) 

Adding To Code (Manual)
=======================
configure.ac
------------
To add a parameter to `./configure` that let's you control whether to enable.disable this addon at build time, add the following code:
```
# Enable or Disable Using Difficulty/Zawy
AC_ARG_WITH([wdifficultyzawy],
    [AS_HELP_STRING([--with-difficulty-zawy],
                    [Use Custom Difficilty Adjustment (Zawy) (default is yes)])],
    [use_difficulty_zawy=$enableval],
    [use_difficulty_zawy=yes])

# Check the parameter and set the directive
AC_MSG_CHECKING([whether to use difficulty zawy])
AM_CONDITIONAL([USE_DIFFICULTY_ZAWY], [test x$use_difficulty_zawy = xyes])
AC_DEFINE_UNQUOTED([USE_DIFFICULTY_ZAWY],[1],[Define to 1 to enable the difficulty/zawy addon])
AC_MSG_RESULT($use_difficulty_zawy)
```
*before* the line:
```
# Bitcoin_Modules_Included_End
```

Then, *before* the line:
```
# Bitcoin_Modules_Report_List_End
```
add the following:
```
echo "  with Zawy     = $use_difficulty_zawy"
```
to display the outcome in the report at the end of the `.configure` run. 

src/Makefile.am
---------------
Add the confitional header file:
```
if USE_DIFFICULTY_ZAWY
  BITCOIN_CORE_H += addons/difficulty/zawy/zawy.h
endif
```
*before* line:
```
# Bitcoin_Modules_Core_Headers
```
also add the conditional source file:
```
if USE_DIFFICULTY_ZAWY
  libbitcoin_server_a_SOURCES += addons/difficulty/zawy/zawy.cpp
endif
```
*before* line:
```
# Bitcoin_Modules_Server_Sources
```
src/pow.cpp
-----------
Add the (conditional) include:
```
#ifdef USE_DIFFICULTY_ZAWY
#include <addons/difficulty/zawy/zawy.h>
#endif
```
*after* line:
```
#include <pow.h>
```
Then, wrap the `GetNextWorkRequired` function in a conditional
```
#ifdef USE_DIFFICULTY_ZAWY
unsigned int GetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params& params)
{
    assert(pindexLast != nullptr);
    return LwmaGetNextWorkRequired(pindexLast, pblock, params);
}
#else
unsigned int GetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params& params)
{
    // the original function
}
#endif

```