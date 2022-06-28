//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './PriceConverter.sol';

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address private owner;
    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;
    
    // multiplied by 1e18 to match converting to wei in eth
    uint128 public constant MINIMUN_USD = 50 * 10 ** 18;

    modifier onlyOwner() {
        // require(msg.sender == i_owner);
        if (msg.sender != owner) revert FundMe__NotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUN_USD, "ETH amount unsufficient, You need to spend more!");

        addressToAmountFunded[msg.sender] += msg.value; 
        funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        for(uint256 i; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
