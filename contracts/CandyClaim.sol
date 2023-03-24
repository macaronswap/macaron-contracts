/*
$$\      $$\  $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\  $$$$$$\  $$\      $$\  $$$$$$\  $$$$$$$\  
$$$\    $$$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$$\  $$ |$$  __$$\ $$ | $\  $$ |$$  __$$\ $$  __$$\ 
$$$$\  $$$$ |$$ /  $$ |$$ /  \__|$$ /  $$ |$$ |  $$ |$$ /  $$ |$$$$\ $$ |$$ /  \__|$$ |$$$\ $$ |$$ /  $$ |$$ |  $$ |
$$\$$\$$ $$ |$$$$$$$$ |$$ |      $$$$$$$$ |$$$$$$$  |$$ |  $$ |$$ $$\$$ |\$$$$$$\  $$ $$ $$\$$ |$$$$$$$$ |$$$$$$$  |
$$ \$$$  $$ |$$  __$$ |$$ |      $$  __$$ |$$  __$$< $$ |  $$ |$$ \$$$$ | \____$$\ $$$$  _$$$$ |$$  __$$ |$$  ____/ 
$$ |\$  /$$ |$$ |  $$ |$$ |  $$\ $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |\$$$ |$$\   $$ |$$$  / \$$$ |$$ |  $$ |$$ |      
$$ | \_/ $$ |$$ |  $$ |\$$$$$$  |$$ |  $$ |$$ |  $$ | $$$$$$  |$$ | \$$ |\$$$$$$  |$$  /   \$$ |$$ |  $$ |$$ |      
\__|     \__|\__|  \__| \______/ \__|  \__|\__|  \__| \______/ \__|  \__| \______/ \__/     \__|\__|  \__|\__|      
*/

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CandyClaim is Pausable, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    ERC20 public claimToken;
    mapping (address => uint256) public balances;
    
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");

    constructor(ERC20 _claimToken) {
        claimToken = _claimToken;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(ISSUER_ROLE, msg.sender);
    }

    function setClaimToken(ERC20 _claimToken) external onlyRole(DEFAULT_ADMIN_ROLE) {
        claimToken = _claimToken;
    }

    function setBalance(address _beneficiary, uint256 _amount) external onlyRole(ISSUER_ROLE) {
        balances[_beneficiary] = balances[_beneficiary] + _amount;
    }

    function setBalances(address[] memory _beneficiaries, uint256[] memory _amounts) external onlyRole(ISSUER_ROLE) {
        require(_beneficiaries.length == _amounts.length, "array lengths not match!");
        for(uint8 i = 0; i < _beneficiaries.length; i++) {
            balances[_beneficiaries[i]] = balances[_beneficiaries[i]] + _amounts[i];
        }
    }

    function claim() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "you don't have available amount for claim.");
        balances[msg.sender] = 0;
        claimToken.safeTransfer(msg.sender, amount);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @notice Withdraw unexpected tokens sent to the Contract
     */
    function inCaseTokensGetStuck(address _token) external onlyRole(DEFAULT_ADMIN_ROLE)  {
        uint256 amount = ERC20(_token).balanceOf(address(this));
        ERC20(_token).safeTransfer(msg.sender, amount);
    }

    /**
     * @notice Withdraw unexpected tokens sent to the Contract
     */
    function inCaseNativeGetStuck() external onlyRole(DEFAULT_ADMIN_ROLE)  {
        uint256 amount = address(this).balance;
        (bool success, ) = address(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }
}
