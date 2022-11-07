pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// INSECURE IMPLEMENTATION
// =======================
contract MaxMint721 is ERC721Enumerable {
  uint public MAX_PER_USER = 10;

  constructor() ERC721("ERC721","ERC721") {}

  function mint(uint amount) external {
    require(balanceOf(msg.sender) + amount <= MAX_PER_USER, "exceed max per user");
    for (uint256 i = 0; i < amount; i++) {
      uint mintIndex = totalSupply();
      _safeMint(msg.sender, mintIndex); // уязвимость происходит тут, так как в _safeMint есть каллбек onERC721Received. Атакующий данный каллбек может переопределить и таким образом накрутить себе максимальное количество токенов.
    }
  }
}
