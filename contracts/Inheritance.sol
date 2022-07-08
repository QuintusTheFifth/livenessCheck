//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Inheritance {
    address public owner;
    address public heir;
    uint256 public timestamp;

    event Transfer(address indexed from, uint256 amount);

    constructor(address _heir) {
        require(_heir != address(0));
        owner = msg.sender;
        heir = _heir;
        timestamp = block.timestamp;
    }

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "Only the owner can withdraw");
        timestamp = block.timestamp;
        payable(msg.sender).transfer(_amount);
    }

    function updateHeirToOwner(address _newHeir) external {
        require(
            block.timestamp > (timestamp + 4 weeks),
            "Not enough time has passed"
        );
        require(msg.sender == heir, "Only heir can become the owner");
        require(_newHeir != address(0), "New heir cannot be the zero address");
        owner = msg.sender;
        heir = _newHeir;
    }

    receive() external payable {
        emit Transfer(msg.sender, msg.value);
    }
}
