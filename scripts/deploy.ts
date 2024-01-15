import Contract from "./interfaces/Contract";
import deploy from "./helpers/deploy";
import { ethers } from "hardhat";

async function main() {
  const [signer, account1, account2] = await ethers.getSigners();

  const contract: Contract = {
    name: "Msical",
    args: [signer.address],
  };

  const contractInst = await deploy(contract);

  // const collection: Contract = {
  //   name: "Msical1155",
  //   args: [signer.address, await contractInst.getAddress(), signer.address],
  // };
  const collectionFactory = await ethers.getContractFactory("Msical1155");
  const collectionInst = await collectionFactory.deploy(
    signer.address,
    signer.address,
    await contractInst.getAddress()
  );

  console.log(`collectionInst`, await collectionInst.getAddress());

  // let allOrganizers, isOrganizer, allEvents;

  // allOrganizers = await contractInst.getAllOrganizers();
  // console.log("allOrganizers", allOrganizers);

  // await contractInst.register("Ken");

  // allOrganizers = await contractInst.getAllOrganizers();
  // console.log("allOrganizers", allOrganizers);

  // isOrganizer = await contractInst.isOrganizer(signer.address);
  // console.log("isOrganizer", isOrganizer);

  // await contractInst.approveOrganizer(signer.address);
  // allOrganizers = await contractInst.getAllOrganizers();
  // console.log("allOrganizers", allOrganizers);

  // isOrganizer = await contractInst.isOrganizer(signer.address);
  // console.log("isOrganizer", isOrganizer);

  // // Create event
  // console.log("== create event ==");
  // const event1 = [
  //   "0x0000000000000000000000000000000000000000000000000000000000000000",
  //   signer.address,
  //   10000,
  //   1703738453,
  //   "Test Event",
  //   "Test event",
  //   "Hanoi",
  // ];

  // await contractInst.createEvent(event1, []);
  // allEvents = await contractInst.getAllEvents();
  // console.log("allEvents", allEvents);

  // const event2 = [10000, 1703738453, "Test Event", "Test event", "Hanoi"];
  // await contractInst.createEvent(event1);
  // allEvents = await contractInst.getAllEvents();
  // console.log("allEvents", allEvents);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
