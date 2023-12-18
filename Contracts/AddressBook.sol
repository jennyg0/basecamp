// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
        bool isDeleted;
    }

    error ContactNotFound(uint id);

    Contact[] private contacts;
    mapping(uint => uint) private idToIndex;

    function addContact(
        string memory _firstName,
        string memory _lastName,
        uint[] memory _phoneNumbers
    ) public onlyOwner {
        uint _id = contacts.length;
        Contact memory newContact = Contact(
            _id,
            _firstName,
            _lastName,
            _phoneNumbers,
            false
        );
        contacts.push(newContact);
        idToIndex[_id] = _id;
    }

    function deleteContact(uint _id) public onlyOwner {
        require(
            _id < contacts.length && !contacts[_id].isDeleted,
            "ContactNotFound"
        );
        contacts[_id].isDeleted = true;
    }

    function getContact(
        uint _id
    ) public view returns (string memory, string memory, uint[] memory) {
        require(
            _id < contacts.length && !contacts[_id].isDeleted,
            "ContactNotFound"
        );
        Contact memory contact = contacts[_id];
        return (contact.firstName, contact.lastName, contact.phoneNumbers);
    }

    function getAllContacts() public view returns (Contact[] memory) {
        uint activeCount = 0;
        for (uint i = 0; i < contacts.length; i++) {
            if (!contacts[i].isDeleted) {
                activeCount++;
            }
        }

        Contact[] memory activeContacts = new Contact[](activeCount);
        uint currentIndex = 0;
        for (uint i = 0; i < contacts.length; i++) {
            if (!contacts[i].isDeleted) {
                activeContacts[currentIndex] = contacts[i];
                currentIndex++;
            }
        }
        return activeContacts;
    }
}

contract AddressBookFactory {
    function deploy() public returns (address) {
        AddressBook newContract = new AddressBook();
        newContract.transferOwnership(msg.sender);
        return address(newContract);
    }
}
