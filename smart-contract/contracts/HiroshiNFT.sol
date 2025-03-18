// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract HiroshiNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    event TokenURIChanged(address indexed to , uint256 indexed tokenId, string uri);

    constructor() ERC721("HiroshiNFT", "HFT") Ownable(msg.sender) {
    }

    function nftMint(address to, string calldata uri) external onlyOwner {
        _tokenIdCounter += 1;
        _mint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, uri);
        emit TokenURIChanged(to, _tokenIdCounter, uri);
    }

    function awardItem(address player, string memory newTokenURI)
        public
        returns (uint256)
    {
        _tokenIdCounter += 1;
        _mint(player, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, newTokenURI);

        return _tokenIdCounter;
    }


    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721,ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}