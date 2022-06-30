const { assert } = require("chai");
const { deployments, ethers, getNamedAccounts } = require("hardhat");

describe("FundMe", async () => {
    let fundMe
    let deployer
    let mockV3Aggregator

    beforeEach(async () => {
        // getting contract owner
        deployer = (await getNamedAccounts()).deployer     
        
        // deploy fundme and associate it to the deployer with hardhat-deploy
        await deployments.fixture(["all"])
        fundMe = await ethers.getContract("FundMe", deployer)

        // MockV3Aggregator
        mockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )

    })

    describe("constructor", function() {
        it("sets the aggregator address correctly", async () => {
            const response = await fundMe.priceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })
})