// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// IMPORTING FILES
    // IMPORTING INTERFACES
import "interfaces/IPausable.sol";
    // IMPORTING CONTRACTS
import "@openzeppelin/contracts/utils/Context.sol";

contract Pausable is IPausable, Context{
    // A variable to hold the pause state
    bool private _paused;

    // A modifier to check if the contract is paused
    modifier onlyWhenPaused{
        if(!isPaused()){
            revert ExpectedPause();
        }

        _;
    }

    // A modifier to check if the contract is not paused
    modifier onlyWhenUnpaused{
        if(isPaused()){
            revert ExpectedUnpause();
        }

        _;
    }

    constructor(){
        _unpause();
    }

    // A function to pause a contract, only when unpaused
    function pause() external onlyWhenUnpaused{
        _pause();
    }

    // A function to unpause a contract, only when paused
    function unpause() external onlyWhenPaused{
        _unpause();
    }

    // A function to return the current pause status
    function isPaused() public view returns(bool){
        return _paused;
    }

    // A function to pause a contract
    function _pause() internal{
        _paused = true;
        emit Paused(_msgSender());
    }

    // A function to unpause a contract
    function _unpause() internal{
        _paused = false;
        emit Unpaused(_msgSender());
    }
}