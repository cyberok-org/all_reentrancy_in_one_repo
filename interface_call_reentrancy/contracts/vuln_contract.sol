pragma solidity ^0.8.7;

interface IRecieverETH {
	function recvETH() external payable;
}

contract InterfaceReentrancy {
	mapping (address => uint256) public balances;
	uint256 public totalsupply;
	constructor() public payable {
		totalsupply = msg.value;
		balances[msg.sender] = msg.value;
	}
	function vuln(uint256 amount) external {
		require(balances[msg.sender] >= amount,"invalid amount"); // если текущий баланс msg.sender больше или равен столько сколько хотим вывести
		IRecieverETH(msg.sender).recvETH{value:amount}(); // сама уязвимость реетранси, так как изменение сотосяние контракта происходит после вызова, код ниже, две последние строчки кода не досегаемы пока можно рекурсивно заходить в контракт через fallback функцию.
		unchecked {
			balances[msg.sender]-=amount;
			totalsupply-=amount;
		}
	}
	function deposit() external payable {
		balances[msg.sender]+=msg.value;
		totalsupply+=msg.value;
	}
}
