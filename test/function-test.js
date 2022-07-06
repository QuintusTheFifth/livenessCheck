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

  it("withdraw()", async function () {
    expect(await provider.getBalance(inheritance.address)).to.equal(
      ethers.utils.parseEther("9")
    );
    await expect(
      inheritance.connect(addr1).withdraw(ethers.utils.parseEther("9"))
    ).to.be.revertedWith("Only the owner can withdraw");
    await inheritance.withdraw(ethers.utils.parseEther("9"));
    expect(await provider.getBalance(inheritance.address)).to.equal(
      ethers.utils.parseEther("0")
    );
  });

  it("setNewOwner()", async function () {
    await expect(inheritance.setNewOwner(addr1.address)).to.be.revertedWith(
      "Not enough time has passed"
    );
    //advance 4 weeks
    advanceTime(2419200);
    await expect(inheritance.setNewOwner(addr1.address)).to.be.revertedWith(
      "Only heir can become the owner"
    );
    await inheritance.connect(addr1).setNewOwner(addr2.address);
  });
});

advanceTime = async (time) => {
  await network.provider.send("evm_increaseTime", [time]);
  await network.provider.send("evm_mine");
};
