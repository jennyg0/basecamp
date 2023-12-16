// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for SillyStringUtils.Haiku;

    SillyStringUtils.Haiku public haiku;

    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku = SillyStringUtils.Haiku(_line1, _line2, _line3);
    }

    function getHaiku() public view returns(SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku(haiku.line1, haiku.line2, SillyStringUtils.shruggie(haiku.line3));
    }
}
