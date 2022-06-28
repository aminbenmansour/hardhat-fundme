//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './PriceConverter.sol';

contract FundMe {
    using PriceConverter for uint256;

    address[] public funders;
    
    // multiplied by 1e18 to match converting to wei in eth
    uint128 public constant MINIMUN_USD = 50 * 10 ** 18;

    constructor() {
    }

    function fund() public payable {
        
    }

    function withdraw() public payable {
        
    }


}
