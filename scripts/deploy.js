const hre = require("hardhat");

async function main() {
 
  const MyToken = await ethers.deployContract("Ajidokwu", ['0x4246a99Db07C10fCE03ab238f68E5003AC5264a1']);
  await MyToken.waitForDeployment();


  console.log("MyToken deployed to:", MyToken.target);

 
}

main()
    .catch((error) => {
    console.error(error);
    process.exit(1);
  });
