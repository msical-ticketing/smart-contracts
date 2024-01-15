import Contract from "../interfaces/Contract";
import deploy from "../helpers/deploy";
import { ethers } from "hardhat";

export const deployProxy = async () => {
  const [signer] = await ethers.getSigners();

  const contract: Contract = {
    name: "EventManagement",
    args: [signer.address],
  };

  return deploy(contract);
};
