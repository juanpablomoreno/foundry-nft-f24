//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MoodNFT is ERC721, Ownable {
    error Uri_TokenDoesNotExist();
    error No_Owner_FlipMood();

    enum NftState {
        SAD,
        HAPPY
    }

    uint256 private sTokenCounter;
    string private sSadSvgUri;
    string private sHappySvgUri;

    mapping(uint256 => NftState) private sTokenIdToStateUri;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory sadSvgUri,string memory happySvgUri) ERC721("MoodNft", "MOOD") Ownable(msg.sender) {
        sTokenCounter = 0;
        sSadSvgUri = sadSvgUri;
        sHappySvgUri = happySvgUri;
    }

    function mintNft() public {
        uint256 tokenCounter = sTokenCounter;
        _safeMint(msg.sender, sTokenCounter);
        sTokenCounter += 1;
        emit CreatedNFT(tokenCounter);
    }

    function flipMood(uint256 tokenId) public onlyOwner {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert No_Owner_FlipMood();
        }
        if (sTokenIdToStateUri[tokenId] == NftState.SAD) {
            sTokenIdToStateUri[tokenId] = NftState.HAPPY;
        } else {
            sTokenIdToStateUri[tokenId] = NftState.SAD;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert Uri_TokenDoesNotExist();
        }

        string memory imageUri = sHappySvgUri;
        if (sTokenIdToStateUri[tokenId] == NftState.SAD) {
            imageUri = sSadSvgUri;
        }
        return string(abi.encodePacked(_baseURI(), 
                        Base64.encode(bytes(string(abi.encodePacked('{"name":"Mood NFT", "description":"An NFT that changes mood based on the owner\'s actions.", "attributes":[{"trait_type":"mood","value":"',
                                            sTokenIdToStateUri[tokenId] == NftState.SAD ? "sad" : "happy",'"}], "image":"', imageUri,'"}'))))));
    }
}
