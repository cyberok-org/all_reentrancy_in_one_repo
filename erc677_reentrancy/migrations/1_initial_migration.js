const ERC677 = artifacts.require("ERC677Reentrancy");
const Attacker = artifacts.require("Attacker");

module.exports = async function(deployer,network,accounts) {
  await deployer.deploy(ERC677, {from:accounts[0],value:"500000000"});
  const c = await ERC677.deployed();
  await deployer.deploy(Attacker,c.address, {from:accounts[1],value:"1"});
  const a = await Attacker.deployed();
  await a.exploit({from:accounts[1]});
};
