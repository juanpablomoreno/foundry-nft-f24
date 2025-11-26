//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant PUG = 
    "https://ipfs.io/ipfs/bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address basicNftAddress = 0x63E2fCA219A486679bc02a5f1c967B5E8Fe73c9d;
        mintNftOnContract(basicNftAddress);
    }

    function mintNftOnContract(address contractAddress) internal {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}