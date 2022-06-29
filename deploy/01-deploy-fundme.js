const { getNamedAccounts, deployments, network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")

module.exports =async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    // what happens when we want to change chains ?
    // when going for localhost or hardhat network we want to use a mock

    let ethUsdPriceFeedAddress

    if (developmentChains.includes(network.name)) {
        ethUsdPriceFeedAddress = await deployments.get("MockV3Aggregateor")
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [
            // price feed address
            ethUsdPriceFeedAddress
        ],
        log: true
    })

    log("--------------------------------------------")
}

module.exports.tags = ["all", "fundme"]
