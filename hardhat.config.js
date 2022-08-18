require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-chai-matchers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: "5ECUEE7JAZRSAAIXXXUKSV1WNGYKXU1IHQ",
    //apikey: process.env.POLYGONSCAN_API_KEY
  },
};
