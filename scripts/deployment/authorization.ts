import Contract from "../interfaces/Contract";
import deploy from "../helpers/deploy";
import { ethers } from "hardhat";

export const deployProxy = async () => {
  const [signer] = await ethers.getSigners();

  const contract: Contract = {
    name: "Authorization",
    args: [signer.address],
  };

  return deploy(contract);
};

deployProxy()
  .then(() => {
    console.log("Deploy successfully");
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
