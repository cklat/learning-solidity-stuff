(async () => {
    try {
        const [address1] = await ethers.getSigners();
        console.log(address1);
        const Spacebear = await hre.ethers.getContractFactory("Spacebear");
        
        const spacebearInstance = await Spacebear.deploy(address1);

        await spacebearInstance.waitForDeployment();

        console.log(`Deployed contract at ${await spacebearInstance.getAddress()}`);
    } catch(e) {
        console.error(e);
        process.exitCode = 1;
    }
})();