const hre = require("hardhat");

async function main() {
 
  const MyToken = await ethers.deployContract("Stake", ['0xD83e38a5F260A1816Ec51122d7BaF7AdCB02892E', 1]);
  await MyToken.waitForDeployment();


  console.log("MyToken deployed to:", MyToken.target);

 
}

main()
    .catch((error) => {
    console.error(error);
    process.exit(1);
  });
