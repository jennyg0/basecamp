// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    error HaikuNotUnique();
    error NotYourHaiku();
    error NoHaikusShared();

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    uint256 public counter = 1;
    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) public lines;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function mintHaiku(
        string memory line1,
        string memory line2,
        string memory line3
    ) external {
        if (lines[line1] || lines[line2] || lines[line3])
            revert HaikuNotUnique();
        lines[line1] = true;
        lines[line2] = true;
        lines[line3] = true;

        Haiku memory newHaiku = Haiku(msg.sender, line1, line2, line3);
        haikus.push(newHaiku);
        _mint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(address _to, uint256 _tokenId) public {
        if (ownerOf(_tokenId) != msg.sender) revert NotYourHaiku();
        sharedHaikus[_to].push(_tokenId);
    }

    function getMySharedHaikus() public view returns (uint256[] memory) {
        if (sharedHaikus[msg.sender].length == 0) revert NoHaikusShared();
        return sharedHaikus[msg.sender];
    }
}
