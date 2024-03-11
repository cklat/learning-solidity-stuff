const {expect} = require("chai");
const hre = require("hardhat");
const IERC721Errors = hre.ethers.getContractFactory("IERC721Errors");
const {loadFixture} = require("@nomicfoundation/hardhat-network-helpers")

describe("Spacebear", function() {
    async function deploySpacebearAndMintTokenFixture() {
        const Spacebear = await hre.ethers.getContractFactory("Spacebear");
        const [owner, otherAccount] = await ethers.getSigners();
        const spacebearInstance = await Spacebear.deploy(owner);
        await spacebearInstance.safeMint(otherAccount.address, "spacebear_1.json");

        return {spacebearInstance};
    }
    it("is possible to mint a token", async() => {
        const {spacebearInstance} = await loadFixture(deploySpacebearAndMintTokenFixture);

        const [owner, otherAccount] = await ethers.getSigners();
        expect(await spacebearInstance.ownerOf(0)).to.equal(otherAccount.address);
    })

    it("fails to transfer tokens from the wrong address", async() => {
        const {spacebearInstance} = await loadFixture(deploySpacebearAndMintTokenFixture);
        const [owner, otherAccount, notTheNFTOwner] = await ethers.getSigners();


        expect(await spacebearInstance.ownerOf(0)).to.equal(otherAccount.address);
        await expect(spacebearInstance.connect(notTheNFTOwner).transferFrom(otherAccount.address, notTheNFTOwner.address,0)).to.be.revertedWithCustomError(spacebearInstance, "ERC721InsufficientApproval")
    })
})