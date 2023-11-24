// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EmployeeStorage {
    uint16 private shares;
    uint24 private salary;
    uint256 public idNumber;
    string public name;

    error TooManyShares(uint16 _shares);

    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber= 112358132134;
    }

    function viewSalary() public view returns(uint24) {
        return salary;
    }

    function viewShares() public view returns(uint16) {
        return shares;
    }

    function grantShares(uint16 _newShares) public {
        require(_newShares < 5000, "Too many shares");

        if ((shares + _newShares) > 5000) {
            revert TooManyShares(shares + _newShares);
        }

        shares += _newShares;
    }

    // Check for Packing and Debug Reset Shares
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}

