// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// IMPORTING NECESSARY FILES
import "contracts/Ownable.sol";
import "contracts/Pausable.sol";

abstract contract OwnablePausable is Ownable, Pausable{
    constructor(address _newOwner) Ownable(_newOwner){}

    // A function to pause the contract
    function pause() public virtual override(Pausable) onlyOwner{
        super.pause();
    }

    // A function to unpause the contract
    function unpause() public virtual override(Pausable) onlyOwner{
        super.unpause();
    }

    // A function to transfer ownership
    function transferOwnership(address _newOwner) 
        public 
        virtual 
        override(Ownable) 
        onlyWhenUnpaused
    {
        super.transferOwnership(_newOwner);
    }

    // A function to renounce ownership
    function renounceOwnership() public virtual override(Ownable) onlyWhenUnpaused{
        super.renounceOwnership();
    }
}