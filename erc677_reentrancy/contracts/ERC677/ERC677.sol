pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC677 is ERC20 {
  constructor(string memory _name,string memory _symbol) public ERC20(_name,_symbol) {}
  function transferAndCall(address to, uint value, bytes memory data) public virtual returns (bool success) {}
  event Transfer(address indexed from, address indexed to, uint value, bytes data);
}
