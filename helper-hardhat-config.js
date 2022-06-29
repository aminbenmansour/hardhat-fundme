// inspired from AAVE protocol, from this repo: https://github.com/aave/aave-v3-core/blob/master/helper-hardhat-config.ts

const networkConfig = {
    4: {
        name: "rinkeby",
        ethUsdPriceFeed: "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e"
    },
    137: {
        name: "polygon",
        ethUsdPriceFeed: "0xF9680D99D6C9589e2a93a78A04A279e509205945"
    }
}

const developmentChains = ["hardhat", "localhost"]


const DECIMALS = 8
const INITIAL_ANSWER = 2000 * 1e8

module.export = {
    networkConfig,
    developmentChains,

    DECIMALS,
    INITIAL_ANSWER
}