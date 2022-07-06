//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Inheritance {
    address public owner;
    address public heir;
    uint256 public timestamp;

    event Transfer(address indexed from, uint256 amount);

    constructor(address _heir) {
        owner = msg.sender;
        heir = _heir;
        timestamp = block.timestamp;
    }

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(msg.sender).transfer(_amount);
        timestamp = block.timestamp;
    }

    function setNewOwner(address _newHeir) public {
        //change function name
        require(
            block.timestamp > (timestamp + 4 weeks),
            "Not enough time has passed"
        );
        require(msg.sender == heir, "Only heir can become the owner");
        owner = msg.sender;
        heir = _newHeir;
    }

    receive() external payable {
        emit Transfer(msg.sender, msg.value);
    }
}
