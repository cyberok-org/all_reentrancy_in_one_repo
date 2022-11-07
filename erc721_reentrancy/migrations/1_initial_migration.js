const MaxMint721 = artifacts.require("MaxMint721");
const Exploit = artifacts.require("Exploit");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(MaxMint721);
  const c = await MaxMint721.deployed();
  await deployer.deploy(Exploit,c.address,10);
  const e = await Exploit.deployed();
  await e.exploit();
};
