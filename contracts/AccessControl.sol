// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// IMPORTING FILES
    // IMPORTING CONTRACTS
import "@openzeppelin/contracts/utils/Context.sol";
    // IMPORTING INTERFACES
import "interfaces/IAccessControl.sol";

contract AccessControl is IAccessControl, Context{
    // Defining a struct of a role and its admin
    struct Role{
        address admin;
        mapping (address account => bool) hasRole;
    }

    // Defining variables
    mapping(bytes32 roleName => Role) private _roles;
    address private _defaultAdmin;

    // A modifier to check if an address is the default admin
    modifier onlyDefaultAdmin(address _account){
        if(!_isDefaultAdmin(_account)){
            revert DefaultAdminOnlyAccess(_account);
        }

        _;
    }

    // A modifier to check if an account is the admin of a certain role
    modifier onlyRoleAdmin(address _account, bytes32 _roleName){
        if(!_isRoleAdmin(_account, _roleName)){
            revert RoleAdminOnlyAccess(_account, _roleName);
        }

        _;
    }

    // A modifier to check if an address is an account with a role
    modifier onlyRoleHolder(address _account, bytes32 _roleName){
        if(!hasRole(_account, _roleName)){
            revert RoleHolderOnlyAccess(_account, _roleName);
        }

        _;
    }

    // A modifier to check if an address is valid
    modifier onlyValidAccount(address _account){
        if(_account == address(0)){
            revert InvalidAddress(_account);
        }

        _;
    }

    constructor(address _newDefaultAdmin) onlyValidAccount(_newDefaultAdmin){
        _transferDefaultAdmin(_newDefaultAdmin);
    }

    // A function to get the bytes32 of a string
    function getBytes32(string memory _name) external pure returns(bytes32){
        return keccak256(abi.encodePacked(_name));
    }

    // A function to get the default admin
    function getDefaultAdmin() external view returns(address){
        return _defaultAdmin;
    }

    // A function to get the admin of a role
    function getRoleAdmin(bytes32 _roleName) external view returns(address){
        return _roles[_roleName].admin;
    }

    // A function to transfer ownership of a default admin, if the caller is a default admin
    function transferDefaultAdmin(address _newDefaultAdmin) 
        external 
        onlyValidAccount(_newDefaultAdmin) 
        onlyDefaultAdmin(_msgSender())
    {
        _transferDefaultAdmin(_newDefaultAdmin);
    }

    /* 
        A function to grant ownership of a role admin, if: 
            -> The new role admin is NOT the default admin
            -> The role admin is NOT occupied
            -> The new role admin is NOT a null address and 
            -> The caller IS the default admin
    */
    function grantRoleAdmin(address _newRoleAdmin, bytes32 _roleName) 
        external 
        onlyValidAccount(_newRoleAdmin)
        onlyDefaultAdmin(_msgSender())
    {
        if(_isDefaultAdmin(_newRoleAdmin)){
            revert InvalidAddress(_newRoleAdmin);
        }else if(_roles[_roleName].admin != address(0)){
            revert RoleAdminFound();
        }else{
            _transferRoleAdmin(_newRoleAdmin, _roleName);
            emit RoleAdminGranted(_newRoleAdmin, _roleName);
        }
    }

    /*
        A function to revoke ownership of a role admin, if:
            -> The caller IS an admin
            -> The role admin to revoke was an actual role admin
    */
    function revokeRoleAdmin(address _roleAdmin, bytes32 _roleName) 
        external 
        onlyDefaultAdmin(_msgSender())
        onlyRoleAdmin(_roleAdmin, _roleName)
    {
        _transferRoleAdmin(address(0), _roleName);
        emit RoleAdminRevoked(_roleAdmin, _roleName);
    }

    /*
        A function to grant a role to a person, if:
            -> The caller IS a role admin
            -> The role holder to be is not null
            -> The role holder is NOT a default admin OR a role admin
            -> The role holder is not occupied
    */
    function grantRole(address _roleHolder, bytes32 _roleName) 
        external 
        onlyValidAccount(_roleHolder)
        onlyRoleAdmin(_msgSender(), _roleName)
    {
        if(_isDefaultAdmin(_roleHolder) || _isRoleAdmin(_roleHolder, _roleName)){
            revert InvalidAddress(_roleHolder);
        }else if(hasRole(_roleHolder, _roleName)){
            revert RoleHolderFound();
        }else{
            _updateRole(_roleHolder, _roleName, true);
            emit RoleGranted(_roleHolder, _roleName);
        }
       
    }

    /*
        A function to revoke a role to a person, if:
            -> The caller IS a role admin
            -> The role holder actually exists
    */
    function revokeRole(address _roleHolder, bytes32 _roleName) 
        external
        onlyRoleAdmin(_msgSender(), _roleName)
        onlyRoleHolder(_roleHolder, _roleName)
    {
        _updateRole(_roleHolder, _roleName, false);
        emit RoleRevoked(_roleHolder, _roleName);
    }

    // A function to renounce a role of a default admin
    function renounceDefaultAdmin() external onlyDefaultAdmin(_msgSender()){
        _transferDefaultAdmin(address(0));
    }

    // A function to renounce a role of a role admin
    function renounceRoleAdmin(bytes32 _roleName) 
        external 
        onlyRoleAdmin(_msgSender(), _roleName)
    {
        _transferRoleAdmin(address(0), _roleName);
    }

    // A function to renounce the role of a role holder
    function renounceRoleHolder(address _roleHolder, bytes32 _roleName) 
        external 
        onlyRoleHolder(_msgSender(), _roleName)
    {
        _updateRole(_roleHolder, _roleName, false);
    }

    // A function to check if a person has a certain role
    function hasRole(address _account, bytes32 _roleName) public view returns(bool){
        return _roles[_roleName].hasRole[_account];
    }

    // A function to check if a person is the default admin
    function _isDefaultAdmin(address _account) internal view returns(bool){
        return _account == _defaultAdmin;
    }

    // A function to check if a person is an admin of a certain role
    function _isRoleAdmin(address _account, bytes32 _roleName) internal view returns(bool){
        return _roles[_roleName].admin == _account;
    }

    // A function to transfer ownership of a default admin
    function _transferDefaultAdmin(address _newDefaultAdmin) internal{
        address oldDefaultAdmin = _defaultAdmin;
        _defaultAdmin = _newDefaultAdmin;
        emit DefaultAdminTransferred(oldDefaultAdmin, _newDefaultAdmin);
    }

    // A function to transfer ownership of a role admin
    function _transferRoleAdmin(address _newRoleAdmin, bytes32 _roleName) internal{
        _roles[_roleName].admin = _newRoleAdmin;
    }

    // A function to update status of a role holder
    function _updateRole(address _roleHolder, bytes32 _roleName, bool _hasRole) internal{
        _roles[_roleName].hasRole[_roleHolder] = _hasRole;
    }
}