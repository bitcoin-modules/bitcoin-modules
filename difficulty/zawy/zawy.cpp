// Copyright (c) 2019 Louwtjie (Loki) Taljaard a.k.a. HashToBeWild
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <addons/difficulty/zawy/zawy.h>

unsigned int LwmaGetNextWorkRequired(const CBlockIndex* pindexLast, const CBlockHeader *pblock, const Consensus::Params& params)
{
    // Special difficulty rule for testnet:
    // If the new block's timestamp is more than 2 * 10 minutes
    // then allow mining of a min-difficulty block.
    if (params.fPowAllowMinDifficultyBlocks && pblock->GetBlockTime() > pindexLast->GetBlockTime() + params.nPowTargetSpacing * 2) 
    {
        return UintToArith256(params.powLimit).GetCompact();
    }
    // Special difficulty rule for if we don't have enough blocks:
    if (pindexLast->nHeight <= ZAWY_LWMA_AVERAGING_WINDOW )
    {
        return UintToArith256(params.powLimit).GetCompact();
    }
    return LwmaCalculateNextWorkRequired(pindexLast, params);
}

unsigned int LwmaCalculateNextWorkRequired(const CBlockIndex* pindexLast, const Consensus::Params& params)
{   
    const int64_t T = params.nPowTargetSpacing;
    const int64_t N = ZAWY_LWMA_AVERAGING_WINDOW; 
    const int64_t k = N*(N+1)*T/2; // BTG's code has a missing N here. They inserted it in the loop
    const int height = pindexLast->nHeight;
    assert(height > N);

    arith_uint256 sum_target;
    int64_t t = 0, j = 0, solvetime;

    // Loop through N most recent blocks. 
    for (int i = height - N+1; i <= height; i++) {
        const CBlockIndex* block = pindexLast->GetAncestor(i);
        const CBlockIndex* block_Prev = block->GetAncestor(i - 1);
        solvetime = block->GetBlockTime() - block_Prev->GetBlockTime();
        solvetime = std::max(-6*T, std::min(solvetime, 6*T));
        j++;
        t += solvetime * j;  // Weighted solvetime sum.
        arith_uint256 target;
        target.SetCompact(block->nBits);
        sum_target += target / (k * N); // BTG added the missing N back here.
    }
    // Keep t reasonable to >= 1/10 of expected t.
    if (t < k/10 ) 
    {
        t = k/10;  
    }
    arith_uint256 next_target = t * sum_target;

    return next_target.GetCompact();
}