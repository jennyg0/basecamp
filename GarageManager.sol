// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping (address => Car[]) public garage;

    error BadCarIndex(uint _index);

    function addCar(string memory _make, string memory _model, string memory _color, uint _numberOfDoors) public  {
        Car memory newCar = Car(_make, _model, _color, _numberOfDoors);
        garage[msg.sender].push(newCar);
    }

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _user) public view returns (Car[] memory) {
        return garage[_user];
    }

    function updateCar(uint _carIndex, string memory _make, string memory _model, string memory _color, uint _numberOfDoors) public {
        if (_carIndex >= garage[msg.sender].length) {
            revert BadCarIndex(_carIndex);
        }
        garage[msg.sender][_carIndex] = Car(_make, _model, _color, _numberOfDoors);
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
