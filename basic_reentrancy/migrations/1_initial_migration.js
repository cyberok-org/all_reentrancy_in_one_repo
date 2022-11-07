const Attacker = artifacts.require("Attacker");
const BasicReentrancy = artifacts.require("BasicReentrancy");

module.exports = async function(deployer,network,accounts) {
  await deployer.deploy(BasicReentrancy,{from:accounts[0],value: "500000000000000"});
  const v = await BasicReentrancy.deployed();
  await deployer.deploy(Attacker,v.address,{from:accounts[1], value: "1"});
  const a = await Attacker.deployed();
  await a.exploit({from:accounts[1],gas:"6721975"});
};
