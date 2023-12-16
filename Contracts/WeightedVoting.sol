// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 constant MAX_SUPPLY = 1000000;
    Issue[] issues;
    mapping(address => bool) claimed;
    enum Votes {AGAINST, FOR, ABSTAIN}
    
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh();
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct GetIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    constructor() ERC20("WeightedVoting", "WVT") {
        issues.push();
    }

    function claim() public {
        if (claimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() + 100 > MAX_SUPPLY) revert AllTokensClaimed();

        _mint(msg.sender, 100);
        claimed[msg.sender] = true;
    }

    function createIssue(string memory _issueDesc, uint256 _quorum) external returns(uint256) {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();
        if (_quorum > totalSupply()) revert QuorumTooHigh();

        issues.push();
        uint256 issueIndex = issues.length - 1;

        Issue storage newIssue = issues[issueIndex];
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        return issueIndex;
    }

    function getIssue(uint256 _id) external view returns (GetIssue memory) {
        Issue storage issue = issues[_id];
        return GetIssue(
        issue.voters.values(),
        issue.issueDesc,
        issue.votesFor,
        issue.votesAgainst,
        issue.votesAbstain,
        issue.totalVotes,
        issue.quorum,
        issue.passed,
        issue.closed
        ); 
    }

    function vote(uint256 _issueId, Votes votes) public {
        Issue storage issue = issues[_issueId];
        uint256 voterBalance = balanceOf(msg.sender);
        if (issue.closed) revert VotingClosed();
        if (voterBalance == 0) revert NoTokensHeld(); 
        if (!issue.voters.add(msg.sender)) revert AlreadyVoted();

        if (votes == Votes.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else if (votes == Votes.FOR) {
            issue.votesFor += voterBalance;
        } else {
            issue.votesAbstain += voterBalance;
        }

        issue.totalVotes += voterBalance;

        if (issue.totalVotes > issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
