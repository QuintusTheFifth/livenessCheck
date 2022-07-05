//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract Inheritance {

    address owner;
    address heir;
    uint256 timeleft;
    constructor() {
        console.log("Deploying a Inheritance contract");
        owner = msg.sender;
        timeleft = block.timestamp;
    }

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        console.log("Withdrawing");
        payable(msg.sender).transfer(_amount);
        timeleft = block.timestamp;
    }

    function setNewOwner(address newOwner) public {
        require(block.timestamp > (timeleft + 4 weeks), "Not enough time has passed");
        require(msg.sender == heir, "Only the heir can change the owner");
        console.log("Changing owner from '%s' to '%s'", owner, msg.sender);
        owner = msg.sender;
        heir = newOwner;
    }

    function setHeir(address _heir) public {
        console.log(4 weeks);
        require(msg.sender == owner);
        console.log("Changing heir from '%s' to '%s'", heir, _heir);
        heir = _heir;
    }

    receive() external payable{

    }
}