const Spacebear = artifacts.require("Spacebear");

module.exports = function(deployer, network, accounts) {
    const initialOwner = accounts[0];
    deployer.deploy(Spacebear, initialOwner);
}