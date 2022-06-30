const { assert, expect } = require("chai");
const { deployments, ethers, getNamedAccounts } = require("hardhat");

describe("FundMe", async () => {
    let fundMe
    let deployer
    let mockV3Aggregator
    const sendValue = ethers.utils.parseEther("1")

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

    describe("fund", async () => {
        it("Fails if you don't send enough ETH", async () => {
            await expect(fundMe.fund()).to.be.reverted
        })

        it("Update the amount of ETH, TX should be accepted", async () => {
            await fundMe.fund({value: sendValue})
            const response = await fundMe.addressToAmountFunded(deployer)

            assert.equal(response.toString(), sendValue.toString())
        })
    })
})