const { assert, expect } = require("chai");
const { deployments, ethers, getNamedAccounts } = require("hardhat");

const { developmentChains } = require("../../helper-hardhat-config")

!developmentChains.includes(network.name)
? describe.skip
: describe("FundMe", async () => {
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
            const response = await fundMe.getPriceFeed()
            assert.equal(response, mockV3Aggregator.address)
        })
    })

    describe("fund", async () => {
        it("Fails if you don't send enough ETH", async () => {
            await expect(fundMe.fund()).to.be.reverted
        })

        it("Update the amount of ETH, TX should be accepted", async () => {
            await fundMe.fund({value: sendValue})
            const response = await fundMe.getAddressToAmountFunded(deployer)

            assert.equal(response.toString(), sendValue.toString())
        })
    })

    describe("withdraw", async () => {
        beforeEach(async () => {
            await fundMe.fund({value: ethers.utils.parseEther("1")})
        })

        it("withdraws ETH from a single funder", async () => {
            const startingFundMeBalance = await fundMe.provider.getBalance(fundMe.address)
            const startingDeployerBalance = await fundMe.provider.getBalance(deployer)

            const transactionResponse = await fundMe.withdraw()
            const transactionReceipt = await transactionResponse.wait(1)
            const { gasUsed, effectiveGasPrice } = transactionReceipt
            const gasCost = gasUsed.mul(effectiveGasPrice)

            const endingFundMeBalance = await fundMe.provider.getBalance(fundMe.address)
            const endingDeployerBalance = await fundMe.provider.getBalance(deployer)
            
            assert.equal(endingFundMeBalance, 0)
            assert.equal(endingDeployerBalance.add(gasCost).toString(), startingDeployerBalance.add(startingFundMeBalance).toString())
        })
    })
})