// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FavouriteRecords {
    mapping (string => bool) public approvedRecords;
    string[] private approvedRecordNames;
    mapping (address => mapping(string => bool)) public userFavorites;
    mapping(address => string[]) private userFavoriteRecords;

    error NotApproved(string _albumName);

      constructor() {
         string[9] memory records = ["Thriller", "Back in Black", "The Bodyguard", 
                                    "The Dark Side of the Moon", "Their Greatest Hits (1971-1975)",
                                    "Hotel California", "Come On Over", "Rumours",
                                    "Saturday Night Fever"];
        for (uint i = 0; i < records.length; i++) {
            approvedRecords[records[i]] = true;
            approvedRecordNames.push(records[i]);
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordNames;
    }

    function addRecord(string calldata _albumName) public {
        if (approvedRecords[_albumName] == false) {
            revert NotApproved(_albumName);
        }

        userFavorites[msg.sender][_albumName] = true;
        userFavoriteRecords[msg.sender].push(_albumName);
    }

    function getUserFavorites(address _address) public view returns (string[] memory) {
        return userFavoriteRecords[_address];
    }

    function resetUserFavorites() public {
       for (uint i = 0; i < userFavoriteRecords[msg.sender].length; i++) {
            delete userFavorites[msg.sender][userFavoriteRecords[msg.sender][i]];
        }
        delete userFavoriteRecords[msg.sender];
    }
}
