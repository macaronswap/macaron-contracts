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

/*

// SPDX-License-Identifier: MIT
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

pragma solidity ^0.6.12;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeERC20 {
    using SafeMath for uint256;
    // using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        _notEntered = true;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipRenounced(address indexed previousOwner);
  
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    _owner = msg.sender;
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(_owner);
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conforms
 * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract MacaronSwapIFOv1 is ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // The token being sold
    IERC20 public token;
    // The token used to buy
    IERC20 public lpToken;
    
    // Macaron Token for whitelisting
    IERC20 public macaron;
    
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    
    uint256 public burnAmountForWhitelist = 1 ether;
    
    // Address where funds are collected
    address payable public fundWallet;
    address private tokenWallet;

    uint256 public tokenPerLPToken;   // token per lp token

    // Amount of wei raised
    uint256 public raisedLPT;
    uint256 public tokenAmountForSale;
    uint256 public soldTokenAmount;
    
    //Whitelisted addresses
    mapping (address => bool) whitelist;
    
    mapping (address => uint256) usedCAPAmount;
    mapping (address => uint256) purchasedTokenAmount;
    mapping (address => uint256) claimedTokenAmount;
    
    uint256 public minCapPerUser = 100000000000000000;
    uint256 public maxCapPerUser = 20000000000000000000;
    uint256 public releasedPercent = 0;
    uint256 public releaseBlock;
    uint256 public startBlock;
    uint256 public endBlock;

    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    /**
     * @param _fundWallet Address where collected funds will be forwarded to
     * @param _tokenPerLPToken How much token give away per LPT
     * @param _token Address of the token being sold
     */
    constructor (address _tokenWallet, address payable _fundWallet, IERC20 _token, IERC20 _lpToken, IERC20 _macaron, uint256 _tokenPerLPToken, uint256 _tokenAmountForSale, uint256 _startBlock, uint256 _endBlock, uint256 _releaseBlock) public {
        require(_fundWallet != address(0), "Crowdsale: wallet is the zero address");
        require(address(_token) != address(0), "Crowdsale: token is the zero address");
        require(_tokenWallet != address(0), "MacaronCrowdsale: token wallet is the zero address");
        tokenWallet = _tokenWallet;
        
        fundWallet = _fundWallet;
        token = _token;
        lpToken = _lpToken;
        macaron = _macaron;
        tokenPerLPToken = _tokenPerLPToken;
        tokenAmountForSale = _tokenAmountForSale;
        
        // Set saleDuration
        startBlock = _startBlock;
        endBlock = _endBlock;
        releaseBlock = _releaseBlock;
    }

    /* ========== VIEW FUNCTIONS ========== */
    
    /**
     * Returns 'true' if there are tokens left in the allowance.
     */
    function isSaleActive() public view returns (bool) {
      return (
          block.number > startBlock && block.number < endBlock &&
          soldTokenAmount < tokenAmountForSale
          );
    }

    function unclaimedToken(address _address) external view returns (uint256) {
        return purchasedTokenAmount[_address].sub(claimedTokenAmount[_address]);
    }
    
    function claimableToken(address _address) public view returns (uint256) {
        uint256 purchased = purchasedTokenAmount[_address];
        uint256 claimed = claimedTokenAmount[_address];
        uint256 claimable = purchased.mul(releasedPercent).div(100).sub(claimed);
        return claimable;
    }
    
    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function getTokenAmount(uint256 weiAmount) public view returns (uint256) {
        uint256 result = tokenPerLPToken.mul(weiAmount);
        require(result > 0, "Less than minimum amount paid");
        return result;        
    }
    
    function getRemainingCapAllocation(address beneficiary) public view returns (uint256) {
        uint256 remainingCAPAllocation = maxCapPerUser - usedCAPAmount[beneficiary];
        return remainingCAPAllocation;
    }
    
    /**
     * Returns 'true' if address in whitelist
     */
    function isWhitelisted(address participant) external view returns (bool) {
      return whitelist[participant];
    }
    
    /* ========== EXTERNAL & PUBLIC FUNCTIONS ========== */

    function setEndBlock(uint256 _endBlock) external onlyOwner {
        require(startBlock < _endBlock, "endBlock can not be greater than startBlock");
        endBlock = _endBlock;
    }
    
    function setStartBlock(uint256 _startBlock) external onlyOwner {
        require(_startBlock < endBlock, "startBlock can not be lower than endBlock");
        startBlock = _startBlock;
    }
    
    function setReleaseBlock(uint256 _releaseBlock) external onlyOwner {
        require(endBlock < _releaseBlock, "endBlock can not be greater than releaseBlock");
        releaseBlock = _releaseBlock;
    }
    
    function setReleasedPercent(uint256 _releasedPercent) external onlyOwner {
        releasedPercent = _releasedPercent;
    }

    /**
     * @param _tokenPerLPToken How much tokens worth equals 1 LPT
     */
    function updatetokenPerLPToken(uint256 _tokenPerLPToken) external onlyOwner {
      tokenPerLPToken = _tokenPerLPToken;
    }
    
    function updateBurnAmountForWhitelisting(uint256 _burnAmountForWhitelist) external onlyOwner {
      burnAmountForWhitelist = _burnAmountForWhitelist;
    }
    
    function updateBurnAddress(address _burnAddress) external onlyOwner {
      burnAddress = _burnAddress;
    }

    /**
     * @param participant whitelisted address for IFO
     */
    function addWhitelistParticipant(address participant) external onlyOwner {
      whitelist[participant] = true;
    }
    
    function addWhitelistParticipants(address[] memory participants) external onlyOwner {
        for(uint i=0; i<participants.length; i++) {
            whitelist[participants[i]] = true;
        }
    }
    
    /**
     * @param participant unwhitelisted address for presale
     */
    function removeWhitelistParticipant(address participant) external onlyOwner {
      whitelist[participant] = false;
    }
    
    /**
     * @notice Burn 1 MCRN and join whitelist
     */
    function joinWhitelist() external {
        macaron.safeTransferFrom(msg.sender, burnAddress, burnAmountForWhitelist);
        whitelist[msg.sender] = true;
    }
    
    /**
     * @dev Checks the amount of tokens left in the allowance.
     * @return Amount of tokens left in the allowance
     */
    function remainingTokens() public view returns (uint256) {
        return Math.min(token.balanceOf(tokenWallet), token.allowance(tokenWallet, address(this)));
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     * @param weiAmount depositted LPT amount
     */
    function deposit(uint256 weiAmount) external nonReentrant {
        require(isSaleActive(), "Sale is not active!");
        
        address beneficiary = msg.sender;
        //check whitelist
        require(whitelist[beneficiary] == true, "You are not whitelisted for this IFO!");
        
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

        uint256 remainingCapAllocation = getRemainingCapAllocation(beneficiary);
        // max buyable amount check
        require(remainingCapAllocation > 0, "Your remaining allocation is over.");
        require(remainingCapAllocation >= weiAmount, "Your remaining allocation is not enough.");
        
        // calculate token amount to be created
        uint256 tokens = getTokenAmount(weiAmount);
        // update state
        raisedLPT = raisedLPT.add(weiAmount);
        soldTokenAmount = soldTokenAmount.add(tokens);
        purchasedTokenAmount[beneficiary] = purchasedTokenAmount[beneficiary].add(tokens);
        usedCAPAmount[beneficiary] = usedCAPAmount[beneficiary] + weiAmount;
        
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
    }
    
    function claim() external nonReentrant {
        require(!isSaleActive(), "Sale is still active!");
        require(purchasedTokenAmount[msg.sender] > 0, "You did not participate this IFO!");
        
        uint256 claimable = claimableToken(msg.sender);
        require(claimable > 0, "You have not claimable amount!");
        token.transferFrom(tokenWallet, msg.sender, claimable);
    }
}