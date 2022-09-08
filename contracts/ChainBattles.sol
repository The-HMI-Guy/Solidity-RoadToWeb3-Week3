// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


// Contract deployed at 0x3c6bab8992f6d688AAA813DA5E6eEE3Acee389Ea
contract ChainBattles is ERC721URIStorage{
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Struct for different attributes for a warrior
    struct WarriorAttributes {
        uint256 levels;
        uint256 hp;
        uint256 strength;
        uint256 speed;
    }

    WarriorAttributes attributes;

    mapping(uint256 => WarriorAttributes) public tokenIdtoAttributes;
    mapping(uint256 => uint256) public tokenIdtoLevels;

    constructor() ERC721("Chain Battles","CBTLS"){

    }
    function generateCharacter(uint256 tokenId) public view returns (string memory){
        WarriorAttributes memory stats = tokenIdtoAttributes[tokenId];
        
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior Attributes",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",stats.levels.toString(),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "HP: ",stats.hp.toString(),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",stats.strength.toString(),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",stats.speed.toString(),'</text>',
            '</svg>'
            );
            return string(
                abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }
    function getLevels(uint256 tokenId) public view returns(string memory){
        uint256 levels = tokenIdtoLevels[tokenId];
        return levels.toString();
    }
    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        uint256 randNum = newItemId;
        WarriorAttributes memory stats;
        stats.levels = randomNumGenerator(randNum++);
        stats.hp = randomNumGenerator(randNum++);
        stats.strength = randomNumGenerator(randNum++);
        stats.speed = randomNumGenerator(randNum++);

        tokenIdtoAttributes[newItemId] = stats;

       _safeMint(msg.sender, newItemId);
       _setTokenURI(newItemId, getTokenURI(newItemId)); 
    }

    function randomNumGenerator(uint256 randNum) public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNum))) % 100;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an exisiting token!");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");

        uint256 randNum = tokenId;
        attributes.levels = randomNumGenerator(randNum++);
        attributes.hp = randomNumGenerator(randNum++);
        attributes.strength = randomNumGenerator(randNum++);
        attributes.speed = randomNumGenerator(randNum++);
        tokenIdtoAttributes[tokenId] = attributes;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}