pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/interfaces/IERC1820Registry.sol";

contract ERC777Reentrancy is ERC777 {
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
        0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
    IERC1820Registry public registry
        = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    mapping (address => bool) locked;
    constructor() public payable ERC777("ERC777Reentrancy", "ERE", new address[](0)) {
	   _mint(msg.sender,msg.value,"","",false);
    }
    
    function vuln(uint256 amount) external {
        require(amount <= 2,"invalid amount");
        require(!locked[msg.sender],"locked!");
	    _mint(msg.sender,amount,"","");
        locked[msg.sender]=true;
    }
}
