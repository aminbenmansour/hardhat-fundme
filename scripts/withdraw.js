const { getNamedAccounts, ethers } = require("hardhat");

async function main () {
    let { deployer } = await getNamedAccounts()
    let fundMe = await ethers.getContract("FundMe", deployer)

    console.log("Withdrawing from contract ...")

    const transactionResponse = await fundMe.withdraw()
    await transactionResponse.wait(1)

    console.log("Amount withdrawn!")

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })