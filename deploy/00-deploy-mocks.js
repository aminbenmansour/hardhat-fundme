// deplolying a minimal version of a smart contract that does not exist on the chain to interact with it (usually for local blockchains)

const { network } = require("hardhat")
const { developmentChains, DECIMALS, INITIAL_ANSWER } = require("../helper-hardhat-config")

module.exports =async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (developmentChains.includes(chainId)) {
        log("Local network detected! Deploying mocks ...")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [
                DECIMALS, INITIAL_ANSWER
            ]
        })
        log("Mocks deployed!")
        log("--------------------------------------------")
    }
}
