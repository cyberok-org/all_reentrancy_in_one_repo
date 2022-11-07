attacker = artifacts.require('Attacker')
victim   = artifacts.require('ERC777Reentrancy')
//erc1820f = artifacts.require('ERC1820Registry')

module.exports = async function(deployer, network, accounts) {
	await deployer.deploy(victim, {from:accounts[0]});
	const vd = await victim.deployed();
	await deployer.deploy(attacker,vd.address, {from:accounts[1]});
	const ad = await attacker.deployed();
	await ad.exploit({from:accounts[1],gas:6721975});
//    const erc1820 = await erc1820f.at("0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24");

}
