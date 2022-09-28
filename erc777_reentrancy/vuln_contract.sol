pragma solidity 0.8.7;

import "@openzeppelin-contracts/contracts/token/ERC777/ERC777.sol";
import "http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin-contracts/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin-contracts/contracts/introspection/ERC1820Implementer.sol";
import "@openzeppelin-contracts/contracts/introspection/IERC1820Registry.sol";

contract ERC777Reentrancy is ERC777 {
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
        0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH
        = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
    IERC1820Registry public registry
        = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    constructor(
    ) public payable ERC777("ERC777Reentrancy", "ERE", new address[](0)) {
        _mint(msg.sender, msg.sender, msg.value, "", "");
    }

    function vuln(uint256 amount) external {
        require(amount >= balanceOf(msg.sender),"invalid amount");
	msg.sender.transfer(amount);
	burn(amount,"");
    }
    function add_listener(address listener) external {
	registry.setInterfaceImplementer(
    		address(this),
    		TOKENS_SENDER_INTERFACE_HASH,
    		listener
	);
	registry.setInterfaceImplementer(
		address(this),
		TOKENS_RECIPIENT_INTERFACE_HASH,
		listener
	);
    }
    function deposit() external payable {
	_mint(msg.sender,msg.sender,msg.value,"","");
    }
}
