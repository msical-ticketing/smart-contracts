import { ethers, upgrades } from "hardhat";

const main = async () => {
  console.log("Upgrading...");
  const factory = await ethers.getContractFactory("Msical");

  const contract = await upgrades.upgradeProxy(
    "0xe950cd23555C1c4021C94168dAc43ed79de5143d",
    factory,
    {
      kind: "uups",
    }
  );
  console.log("Upgraded");
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
