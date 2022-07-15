//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

/**
@author QuintusTheFifth
@title Inheritance contract
@dev This smart contract allows the owner to withdraw ETH from the contract.
* if the owner does not withdraw ETH from the contract for more than 1 month an
* heir can take control of the contract and designate a new heir.
* It is possible for the owner to withdraw 0 ETH just to reset the one month counter.
*/
contract Inheritance {
    // Events
    event Transfer(address indexed from, uint256 amount);
    event Withdrawal(address indexed from, uint256 amount);
    event NewOwner(
        address indexed from,
        address indexed to,
        address indexed newHeir
    );

    // Storage
    address private owner;
    address private heir;
    uint256 private timestamp;

    /*Functions*/
    /**
     * @dev Constructor
     * @param _heir The address of the heir
     */
    constructor(address _heir) {
        require(_heir != address(0));
        owner = msg.sender;
        heir = _heir;
        timestamp = block.timestamp;
    }

    /**
     *@dev Allows the owner to withdraw ETH from the contract or/and to
     * reset the one month counter.
     *@param _amount The amount of ETH to withdraw.
     */
    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "Only the owner can withdraw");
        timestamp = block.timestamp;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    /**
     *@dev Allows the heir to become owner and to designate a new heir.
     *@param _newHeir The new heir.
     */
    function updateHeirToOwner(address _newHeir) external {
        require(
            block.timestamp > (timestamp + 4 weeks),
            "Not enough time has passed"
        );
        require(msg.sender == heir, "Only heir can become the owner");
        require(_newHeir != address(0), "New heir cannot be the zero address");
        timestamp = block.timestamp;
        emit NewOwner(owner, msg.sender, _newHeir);
        owner = msg.sender;
        heir = _newHeir;
    }

    receive() external payable {
        emit Transfer(msg.sender, msg.value);
    }
}
