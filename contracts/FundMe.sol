//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import './PriceConverter.sol';

error FundMe__NotOwner();

/** @title A contract for crowd funding
 *  @author Amine Ben Mansour
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConverter for uint256;

    address private immutable owner;
    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;
    
    AggregatorV3Interface public priceFeed;
    // multiplied by 1e18 to match converting to wei in eth
    uint128 public constant MINIMUN_USD = 50 * 10 ** 18;

    modifier onlyOwner() {
        // require(msg.sender == i_owner);
        if (msg.sender != owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address _priceFeed) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     * @notice This function funds this contract
     * @param null
     * @return void
     */

    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUN_USD, "ETH amount unsufficient, You need to spend more!");

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

}
