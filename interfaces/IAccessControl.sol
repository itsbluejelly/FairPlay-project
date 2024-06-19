// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IAccessControl{
    // An event emitted after transfer of the default admin
    event DefaultAdminTransferred(address indexed old_admin, address indexed new_admin);
    // An event emitted after granting the admin of a role
    event RoleAdminGranted(address indexed admin, bytes32 indexed roleName);
    // An event emitted after revoking the admin of the role
    event RoleAdminRevoked(address indexed admin, bytes32 indexed roleName);
    // An event emitted after granting a role
    event RoleGranted(address indexed account, bytes32 indexed roleName);
    // An event emitted after revoking a role
    event RoleRevoked(address indexed account, bytes32 indexed roleName);

    // A function to get the default admin;
    function getDefaultAdmin() external view returns(address);
    // A function to get the admin of a certain role;
    function getRoleAdmin(bytes32 _roleName) external view returns(address);
    // A function to get the bytes32 of a string
    function getBytes32(string memory _name) external pure returns(bytes32);

    // An error if a default-admin only function is called
    error DefaultAdminOnlyAccess(address invalidAdmin);
    // An error if a role-admin only function is called
    error RoleAdminOnlyAccess(address invalidAdmin, bytes32 roleName);
    // An error if a role-holder only function is called
    error RoleHolderOnlyAccess(address invalidAccount, bytes32 roleName);
    // An error if the address is not valid
    error InvalidAddress(address invalidAddress);
    // An error if the role already has an admin
    error RoleAdminFound();
    // An error if the account already has a role
    error RoleHolderFound();
}