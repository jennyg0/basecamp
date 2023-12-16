// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnburnableToken {
    uint256 public totalSupply;
    uint256 public totalClaimed;
    mapping (address => uint256) public balances;
    mapping (address => bool) public claimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address _address);
    error NotEnoughToSend(uint256 _balance);

    constructor() {
        totalSupply = 100000000;
    }

    function claim() public {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }
        claimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }
        if (balances[msg.sender] < _amount) {
            revert NotEnoughToSend(balances[msg.sender]);
        }
        balances[msg.sender] -= _amount;
            balances[_to] += _amount;
    }
}
