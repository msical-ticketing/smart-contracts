import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-storage-layout";
import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.21",
  networks: {
    polygonMumbai: {
      url: "https://polygon-mumbai.infura.io/v3/334f4e9bc42f4065a10b19a5738bfa2d",
      accounts: [process.env.PRIVATE_KEY!],
    },
  },
  etherscan: {
    apiKey: "NIST5BX7JTTNJ82YQF14WK1KA7BK6RY3FU",
  },
};

export default config;
