pragma solidity 0.8.7;

import "./ERC677/ERC677Token.sol";

contract ERC677Reentrancy is ERC677Token {
	mapping(address => uint256) public lock_times;
	constructor() public payable ERC677Token("ERC667Reentrancy","E667R") {
		_mint(msg.sender,msg.value);
	}
	function deposit() public payable {
		_mint(msg.sender,msg.value);
	}
	function vuln(uint256 amount) public {
		require(amount >= balanceOf(msg.sender));
		if (lock_times[msg.sender] == 0 || lock_times[msg.sender] < block.timestamp) {
			transferAndCall(msg.sender,amount,"");
			lock_times[msg.sender] = block.timestamp + 7 days;
		}
	}
}
