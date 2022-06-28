//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './PriceConverter.sol';

contract FundMe {
    using PriceConverter for uint256;

    address private owner;
    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;
    
    // multiplied by 1e18 to match converting to wei in eth
    uint128 public constant MINIMUN_USD = 50 * 10 ** 18;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUN_USD, "ETH amount sufficient, You need to spend more!");

        addressToAmountFunded[msg.sender] += msg.value; 
        funders.push(msg.sender);
    }

    function withdraw() public payable {
        for(uint256 i; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        payable(msg.sender).transfer(address(this).balance);
    }


}
