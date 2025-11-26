//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private sTokenCounter;
    mapping(uint256 => string) private sTokenIdToUri;

    constructor() ERC721("Perro", "DOG") {
        sTokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        sTokenCounter += 1;
        _safeMint(msg.sender, sTokenCounter);

        sTokenIdToUri[sTokenCounter] = tokenUri;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return sTokenIdToUri[tokenId];
    }
}
