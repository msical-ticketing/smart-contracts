import { ethers } from "hardhat";
import * as authorization from "../scripts/deployment/authorization";
import { expect } from "chai";

describe("Authorization", function () {
  before(async function () {
    this.authorization = await authorization.deployProxy();
    [
      this.upgrader,
      this.client1,
      this.client2,
      this.organizer1,
      this.organizer2,
      this.organizer3,
      this.organizer4,
    ] = await ethers.getSigners();
  });

  it("Authorization was deployed properly", async function () {
    console.log(this.authorization.target);
  });

  it("New user registering to be an organizer must work properly", async function () {
    const signer = this.organizer1;
    await this.authorization.connect(signer).register();
    // Not yet an organizer
    expect(await this.authorization.isOrganizer(signer.address)).to.be.false;

    // Now in the pending list
    expect((await this.authorization.getAllPending()).length).to.be.equal(1);
  });

  it("More users register to be an organizer", async function () {
    await this.authorization.connect(this.organizer2).register();
    await this.authorization.connect(this.organizer3).register();
    await this.authorization.connect(this.organizer4).register();
    expect((await this.authorization.getAllPending()).length).to.be.equal(4);
    console.log(await this.authorization.getAllPending());
  });

  it("Only admin can approve a request", async function () {
    const signer = this.upgrader;

    await this.authorization
      .connect(signer)
      .approveNewOrganizer(this.organizer1.address);

    expect((await this.authorization.getAllPending()).length).to.be.equal(3);
    expect((await this.authorization.getAllOrganizers()).length).to.be.equal(1);
    console.log(await this.authorization.getAllPending());
    console.log(await this.authorization.getAllOrganizers());
  });
});
