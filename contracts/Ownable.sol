// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// IMPORTING FILES
    // IMPORTING INTERFACES
import "interfaces/IOwnable.sol";
    // IMPORTING CONTRACTS
import "@openzeppelin/contracts/utils/Context.sol";

abstract contract Ownable is Context, IOwnable{
    // A variable to hold the current owner
    address private _owner;

    // A modifier to check if the caller is the owner
    modifier onlyOwner{
        if(!_isOwner(_msgSender())){
            revert UnauthorisedAccess(_msgSender());
        }

        _;
    }

    // A modifier to check if an address is a valid address
    modifier onlyValidAddress(address _account){
        if(_account == address(0)){
            revert InvalidAddress(_account);
        }

        _;
    }

    constructor(address _newOwner) onlyValidAddress(_newOwner){
        _transferOwnership(_newOwner);
    }

    // A function to get the current owner
    function getOwner() external view returns(address){
        return _owner;
    }

    // A function to transfer ownership to a valid address
    function transferOwnership(address _newOwner) external onlyValidAddress(_newOwner) onlyOwner{
        _transferOwnership(_newOwner);
    }

    // A function to renounce ownership
    function renounceOwnership() external onlyOwner{
        _transferOwnership(address(0));
    }

    // A function to check if a certain address is the owner
    function _isOwner(address _account) internal view returns(bool){
        return _account == _owner;
    }

    // A function to transfer ownership to any address
    function _transferOwnership(address _newOwner) internal{
        address oldOwner = _owner;
        _owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}