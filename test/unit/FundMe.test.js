const { deployments, ethers, getNamedAccounts } = require("hardhat");

describe("FundMe !", async () => {
    let fundMe;
    BeforeEach(async () => {

        //getting contract owner
        const { deployer } = await getNamedAccounts()     
        
        // deploy fundme and associate it to the deployer with hardhat-deploy
        await deployments.fixture(["all"])
        fundMe = await ethers.getContract("FundMe", deployer)


    })
})