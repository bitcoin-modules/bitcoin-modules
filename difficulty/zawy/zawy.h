#include <arith_uint256.h>
#include <primitives/block.h>
#include <chain.h>

#ifndef HASHTOBEWILD_ADDONS_DIFFICULTY_ZAWY
#define HASHTOBEWILD_ADDONS_DIFFICULTY_ZAWY

// =45 for T=600.  =60 for T=150.  =90 for T=60. 
const int64_t ZAWY_LWMA_AVERAGING_WINDOW = 90;

/** Zawy's LWMA - next generation algorithm */
unsigned int LwmaGetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params&);
unsigned int LwmaCalculateNextWorkRequired(const CBlockIndex* pindexLast, const Consensus::Params& params);

#endif // HASHTOBEWILD_ADDONS_DIFFICULTY_ZAWY
