require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  network: {
    rinkeby: {
      url: process.env.INFURA_RINKEBY_ENDPOINT,
      account: [process.env.PRIVATE_KEY]
    }
  }
};
