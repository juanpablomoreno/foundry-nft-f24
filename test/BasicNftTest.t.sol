//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNFT public basicNft;
    DeployBasicNft public deployer;
    string public constant PUG = 
    "https://ipfs.io/ipfs/bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    //crea a trabves de foundry un usuario ficticio
    address public USER = makeAddr("user");

    function setUp() external {
        // esta funcion de configuracion que se ejecuta antes de cada test, 
        // teniendo una instancia nueva del contrato
        DeployBasicNft deployer = new DeployBasicNft();

        // garantiza que se despliegue el contrato en un entorno de produccion
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Perro";
        string memory actualName = basicNft.name();
       
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testCanMintAndHaveABalance() public {
        // la siguinte transaccion va a simular que viene del usuario USER
        vm.prank(USER);
        // acuña un NFT para el usuario USER
        basicNft.mintNft(PUG);
        uint256 userBalance = basicNft.balanceOf(USER);

        // el numero de NFTs del usuario debe ser 1
        assert(userBalance == 1);

        assert(keccak256(abi.encodePacked(basicNft.tokenURI(1))) ==
        keccak256(abi.encodePacked(PUG)));
    }

}
