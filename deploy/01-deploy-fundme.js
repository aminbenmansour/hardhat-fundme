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
        let ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: [
            ethUsdPriceFeedAddress
        ],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    log("--------------------------------------------")
}

module.exports.tags = ["all", "fundme"]
