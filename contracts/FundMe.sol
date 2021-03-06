//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import './PriceConverter.sol';

error FundMe__NotOwner();
error FundMe__InsufficientETH();

/** @title A contract for crowd funding
 *  @author Amine Ben Mansour
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConverter for uint256;

    address private immutable owner;
    address[] private funders;
    mapping (address => uint256) private addressToAmountFunded;
    
    AggregatorV3Interface private priceFeed;
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
     */

    function fund() public payable {
        // require(msg.value.getConversionRate(priceFeed) >= MINIMUN_USD, "ETH amount unsufficient, You need to spend more!");
        if (msg.value.getConversionRate(priceFeed) < MINIMUN_USD) revert FundMe__InsufficientETH();

        addressToAmountFunded[msg.sender] += msg.value; 
        funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        address[] memory _funders = funders;

        for(uint256 i; i < _funders.length; i++) {
            address funder = _funders[i];
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


    function getOwner() public view returns (address) {
        return owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return funders[index];
    }

    function getAddressToAmountFunded(address funder) public view returns (uint256) {
        return addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return priceFeed;
    }
}
