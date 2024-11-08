const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployStableCoinFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const stableCoin = await ethers.getContractFactory("StableCoin");
    const stableCoinContract = await stableCoin.deploy();

    return { stableCoinContract, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should check the Stable coin name and symbol", async function () {
      const { stableCoinContract } = await loadFixture(deployStableCoinFixture);

      expect(await stableCoinContract.name()).to.equal("StableCoin");
      expect(await stableCoinContract.symbol()).to.equal("SC");
    });
  });

  describe("Minting", function () {
    it("Should revert with StableCoin_NotEnoughAmount when trying to mint zero or less then zero tokens", async function () {
      const { stableCoinContract, owner } = await deployStableCoinFixture();
      await expect(
        stableCoinContract.mint(owner, 0)
      ).to.revertedWithCustomError(
        stableCoinContract,
        "StableCoin_NotEnoughAmount"
      );
    });

    it("Should revert with StableCoin_InvalidUser when trying to mint by zero address", async function () {
      const { stableCoinContract, owner } = await deployStableCoinFixture();
      await expect(
        stableCoinContract.mint(owner, 0)
      ).to.revertedWithCustomError(
        stableCoinContract,
        "StableCoin_NotEnoughAmount"
      );
    });

    it("Should emit a event when tokens are minted succuessfully", async function () {
      const { stableCoinContract, owner } = await deployStableCoinFixture();
      await expect(stableCoinContract.mint(owner, 100))
        .to.emit(stableCoinContract, "minted")
        .withArgs(owner, 100);
    });
  });

  describe("Burning", function () {
    it("Should revert with OwnableUnauthorizedAccount when  non-owner tries to burn ", async function () {
      const { stableCoinContract, otherAccount } =
        await deployStableCoinFixture();
      await expect(
        stableCoinContract.connect(otherAccount).burn(100)
      ).to.be.revertedWithCustomError(
        stableCoinContract,
        "OwnableUnauthorizedAccount"
      );
    });

    it("Should successfully burn when called by owner ", async function () {
      const { stableCoinContract, owner } = await deployStableCoinFixture();
      await stableCoinContract.mint(owner.address, 100);
      await stableCoinContract.burn(10);
    });

    it("Should revert with StableCoin_NotEnoughAmount when trying to burn zero tokens", async function () {
      const { stableCoinContract, owner } = await deployStableCoinFixture();
      await stableCoinContract.mint(owner.address, 100);
      await expect(stableCoinContract.burn(0)).to.be.revertedWithCustomError(
        stableCoinContract,
        "StableCoin_NotEnoughAmount"
      );
    });

    it("Should revert with StableCoin_NotEnoughBalance when trying to burn more than balance", async function () {
      const { stableCoinContract } = await deployStableCoinFixture();

      await expect(stableCoinContract.burn(10)).to.be.revertedWithCustomError(
        stableCoinContract,
        "StableCoin_NotEnoughBalance"
      );
    });
  });
});
