// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hiroshi1155NFT is ERC1155, Ownable {
    constructor() ERC1155("") Ownable(msg.sender) {
        _mint(msg.sender, 0, 1, "");
        _mint(msg.sender, 1, 2*3, "");
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public {
        _mintBatch(to, ids, amounts, data);
    }
}