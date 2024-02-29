// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BalancerFlashLoan.sol";
import '@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';

contract main is BalancerFlashLoan {

    INonfungiblePositionManager public constant nonfungiblePositionManager = INonfungiblePositionManager(0x1238536071E1c677A632429e3655c799b22cDA52);


    function removeLiquidity(uint256 tokenId) external {

        /*
            nonce   uint96 :  0
            operator   address :  0x0000000000000000000000000000000000000000
            token0   address :  0x1E50766fDb8Fb7D406878eAf73ACE1553cEa6713
            token1   address :  0x2284981ec882b88F062E7a9b6E43E47Bb1f98327
            fee   uint24 :  3000
            tickLower   int24 :  -120
            tickUpper   int24 :  120
            liquidity   uint128 :  0
            feeGrowthInside0LastX128   uint256 :  61064396503397452110945275557207
            feeGrowthInside1LastX128   uint256 :  0
            tokensOwed0   uint128 :  0
            tokensOwed1   uint128 :  0
        */

        ( , , , , , , , uint128 liquidity, , , , ) = nonfungiblePositionManager.positions(tokenId);
        
        // amount0Min and amount1Min are price slippage checks
        // if the amount received after burning is not greater than these minimums, transaction will fail
        INonfungiblePositionManager.DecreaseLiquidityParams memory params =
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

        nonfungiblePositionManager.decreaseLiquidity(params);
    }

    function collectLiquidity(uint256 tokenId) external {

        /*
            uint256 tokenId;
            address recipient;
            uint128 amount0Max;
            uint128 amount1Max;
        */

        INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        });

        nonfungiblePositionManager.collect(params);
    }

}
