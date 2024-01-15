import { ethers, upgrades } from "hardhat";

interface Contract {
  name: string;
  args?: any[];
}
const upgrade = async (contract: Contract) => {
  console.log(`Upgrading ${contract.name}...`);
  const factory = await ethers.getContractFactory(contract.name);
  const contractInst = await upgrades.deployProxy(factory, contract.args, {
    initializer: "initialize",
  });

  await contractInst.waitForDeployment();
  console.log(
    `Deployed contract ${contract.name} at ${await contractInst.getAddress()}`
  );

  return contractInst;
};

export default deploy;
