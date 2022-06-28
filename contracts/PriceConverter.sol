//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConverter {
    
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        
        // Rinkeby ETH / USD Address
        // https://docs.chain.link/docs/ethereum-addresses/

        (, int256 answer, , , ) = priceFeed.latestRoundData();
        
        // ETH/USD rate in 18 digit
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ETH_amount, AggregatorV3Interface _priceFeed) internal view returns(uint256) {
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return (getPrice(_priceFeed) * ETH_amount) / 1e18;
    }
}