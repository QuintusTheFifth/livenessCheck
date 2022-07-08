const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

describe("Inheritance", function () {
  let inheritance;
  let owner, addr1, addr2, addr3;
  let provider;

  beforeEach(async () => {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    provider = waffle.provider;
    const Inheritance = await ethers.getContractFactory("Inheritance");
    inheritance = await Inheritance.deploy(addr1.address);
    await inheritance.deployed();
    await owner.sendTransaction({
      from: owner.address,
      to: inheritance.address,
      value: ethers.utils.parseEther("9"),
    });
  });

  it("reset timer without withdrawing", async function () {
    await inheritance.withdraw(0);
    expect(await provider.getBalance(inheritance.address)).to.equal(
      ethers.utils.parseEther("9")
    );
  });
  it("a month passes, heir takes control of contract, sets new heir and withdraws", async function () {
    //advance 4 weeks
    advanceTime(2419200);
    await inheritance.connect(addr1).updateHeirToOwner(addr2.address);
    //withdraw funds
    myBalanceBefore = await provider.getBalance(addr1.address);
    await inheritance.connect(addr1).withdraw(ethers.utils.parseEther("9"));
    myBalanceAfter = await provider.getBalance(addr1.address);
    expect(myBalanceAfter).to.be.above(myBalanceBefore);
    expect(await provider.getBalance(inheritance.address)).to.equal(0);
  });

  it("heir tries to become owner before month has passed", async function () {
    await expect(
      inheritance.connect(addr2).updateHeirToOwner(addr3.address)
    ).to.be.revertedWith("Not enough time has passed");
  });
});

advanceTime = async (time) => {
  await network.provider.send("evm_increaseTime", [time]);
  await network.provider.send("evm_mine");
};
