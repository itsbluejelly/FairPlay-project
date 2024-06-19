// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IOwnable{
    // An event triggered if the owner is changed
    event OwnershipTransferred(address indexed old_owner, address indexed new_owner);

    // A function to check the current owner
    function getOwner() external view returns(address);

    // An error if the an owner-only function is called by a non-owner
    error UnauthorisedAccess(address invalidAddress);
    // An error if the address is not valid
    error InvalidAddress(address invalidAddress);
}