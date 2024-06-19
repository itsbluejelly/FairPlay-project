// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IPausable {
    // An event triggered if the contract is paused by a certain account
    event Paused(address indexed pauser);
    // An event triggered if the contract is unpaused by a certain account
    event Unpaused(address indexed resumer);

    // An error if a non-paused function is called at a paused state
    error ExpectedUnpause();
    // An error if a paused function is called at a non-paused state
    error ExpectedPause();
}