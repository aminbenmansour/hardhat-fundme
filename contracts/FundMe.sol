//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract Greeter {
    address[] public funders;
    uint128 public constant MINIMUN_USD = 50 * 10 ** 18; // multiplied by 1e18 to match converting to wei in eth

    constructor() {
    }

    function fund() public payable {
        
    }

    function withdraw() public payable {
        
    }


}
