pragma solidity ^0.5.6;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address payable private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address payable) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address payable newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(msg.sender);
    }

    modifier onlyPauser() {
        require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(msg.sender);
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is PauserRole {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

interface IInjeolmi {

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external pure returns (uint256);

    function excluded(address user) external view returns (bool);
    function _userInfo(address user) external view returns (uint256 lastBalance, uint256 lastMultiplier, uint256 resettingCount);

    function balanceOf(address owner) external view returns (uint256 balance);
    function transfer(address to, uint256 amount) external returns (bool success);
    function transferFrom(address from, address to, uint256 amount) external returns (bool success);
    function approve(address spender, uint256 amount) external returns (bool success);
    function allowance(address owner, address spender) external view returns (uint256 remaining);
}

// 우리나라에는 새로 이사를 오면 떡을 돌리는 풍습이 있습니다.
// 이런 "떡돌리기" 문화를 토크노믹스로 만들어 보았습니다.
// 한국인의 정과 훈훈한 인심을 느껴보세요.
contract Injeolmi is Ownable, Pausable, IInjeolmi {
    using SafeMath for uint256;

    string public constant NAME = "Injeolmi";
    string public constant SYMBOL = "IJM";
    uint8 public constant DECIMALS = 8;

    // 1억개 발행, 추가 발행 없음
    uint256 public constant TOTAL_SUPPLY = 100000000 * 10**uint256(DECIMALS);
    uint256 private constant MULTIPLIER = 10**9;

    struct UserInfo {
        uint256 lastBalance;
        uint256 lastMultiplier;
        uint256 resettingCount;
    }

    mapping(address => UserInfo) public _userInfo;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => bool) public excluded;

    uint256 public accMultiplier = MULTIPLIER;
    uint256 public resettingCount;

    function exclude(address addr) external onlyOwner {
        excluded[addr] = true;
    }

    function include(address addr) external onlyOwner {
        excluded[addr] = false;
    }

    function name() external pure returns (string memory) {
        return NAME;
    }

    function symbol() external pure returns (string memory) {
        return SYMBOL;
    }

    function decimals() external pure returns (uint8) {
        return DECIMALS;
    }

    function totalSupply() external pure returns (uint256) {
        return TOTAL_SUPPLY;
    }

    constructor() public {
        _userInfo[msg.sender].lastBalance = TOTAL_SUPPLY;
        _userInfo[msg.sender].lastMultiplier = MULTIPLIER;
    }

    function updateMultiplier(address[] calldata _addresses) external onlyOwner whenPaused {
        uint256 length = _addresses.length;
        uint256 _accMultiplier = accMultiplier;
        for (uint256 i = 0; i < length; i++) {
            UserInfo storage _uInfo = _userInfo[_addresses[i]];
            uint256 _lastMultiplier = _uInfo.lastMultiplier;

            if (_uInfo.resettingCount == resettingCount + 1 || _lastMultiplier == 0) {} else if (_lastMultiplier == _accMultiplier) {
                _uInfo.lastMultiplier = MULTIPLIER;
                _uInfo.resettingCount = resettingCount + 1;
            } else {
                _uInfo.lastBalance = _uInfo.lastBalance.mul(_accMultiplier).div(_lastMultiplier);
                _uInfo.lastMultiplier = MULTIPLIER;
                _uInfo.resettingCount = resettingCount + 1;
            }
        }
    }

    /**
        Should update all of token holders not only EOAs but also the contracts and the owner.
    */
    function finishUpdatingMultiplier() external onlyOwner whenPaused {
        accMultiplier = MULTIPLIER;
        resettingCount = resettingCount + 1;
    }

    function balanceOf(address user) external view returns (uint256 balance) {
        UserInfo memory _uInfo = _userInfo[user];
        if (_uInfo.lastBalance == 0 || _uInfo.lastMultiplier == 0) return 0;
        return _uInfo.lastBalance.mul(accMultiplier).div(_uInfo.lastMultiplier);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        UserInfo storage _fromInfo = _userInfo[from];
        UserInfo storage _toInfo = _userInfo[to];

        uint256 _accMultiplier = accMultiplier;

        uint256 fromUpdatedBalance;
        {
            //avoids stack too deep errors
            uint256 fromLastBalance = _fromInfo.lastBalance;
            uint256 fromLastMultiplier = _fromInfo.lastMultiplier;
            fromUpdatedBalance = fromLastBalance;
            if (fromLastBalance != 0 && fromLastMultiplier != _accMultiplier) {
                fromUpdatedBalance = fromLastBalance.mul(_accMultiplier).div(fromLastMultiplier);
            }
        }

        uint256 toUpdatedBalance;
        {
            //avoids stack too deep errors
            uint256 toLastBalance = _toInfo.lastBalance;
            uint256 toLastMultiplier = _toInfo.lastMultiplier;
            toUpdatedBalance = toLastBalance;
            if (toLastBalance != 0 && toLastMultiplier != _accMultiplier) {
                toUpdatedBalance = toLastBalance.mul(_accMultiplier).div(toLastMultiplier);
            }
        }

        if (amount == uint256(-1)) amount = fromUpdatedBalance;

        if (excluded[from]) {
            _fromInfo.lastBalance = fromUpdatedBalance.sub(amount);
            _toInfo.lastBalance = toUpdatedBalance.add(amount);
        } else {
            // 9% 떡돌리기
            uint256 dist = amount.mul(9).div(100);
            // 1% 떡방앗간 팁
            uint256 fee = amount.div(100);

            uint256 thisMultiplier = TOTAL_SUPPLY.mul(MULTIPLIER).div(TOTAL_SUPPLY.sub(dist));

            if (to != address(owner())) {
                UserInfo storage _ownerInfo = _userInfo[address(owner())];
                uint256 ownerUpdatedBalance;
                {
                    //avoids stack too deep errors
                    uint256 ownerLastBalance = _ownerInfo.lastBalance;
                    uint256 ownerLastMultiplier = _ownerInfo.lastMultiplier;
                    ownerUpdatedBalance = ownerLastBalance;
                    if (ownerLastBalance != 0 && ownerLastMultiplier != _accMultiplier) {
                        ownerUpdatedBalance = ownerLastBalance.mul(_accMultiplier).div(ownerLastMultiplier);
                    }
                }
                {
                    //avoids stack too deep errors
                    (_fromInfo.lastBalance, _toInfo.lastBalance, _ownerInfo.lastBalance) = __transfer(fromUpdatedBalance, toUpdatedBalance, ownerUpdatedBalance, amount, dist, fee, thisMultiplier);
                }
                _ownerInfo.lastMultiplier = _accMultiplier.mul(thisMultiplier).div(MULTIPLIER);
            } else {
                _fromInfo.lastBalance = (fromUpdatedBalance.sub(amount)).mul(thisMultiplier).div(MULTIPLIER);
                _toInfo.lastBalance = (toUpdatedBalance.add(amount.sub(dist))).mul(thisMultiplier).div(MULTIPLIER);
            }

            _accMultiplier = _accMultiplier.mul(thisMultiplier).div(MULTIPLIER);
            accMultiplier = _accMultiplier;
        }

        _fromInfo.lastMultiplier = _accMultiplier;
        _toInfo.lastMultiplier = _accMultiplier;

        emit Transfer(from, to, amount);
    }

    function __transfer(
        uint256 fromUB,
        uint256 toUB,
        uint256 oUB,
        uint256 amount,
        uint256 dist,
        uint256 fee,
        uint256 thisMultiplier
    )
        private
        pure
        returns (
            uint256 f,
            uint256 t,
            uint256 o
        )
    {
        f = (fromUB.sub(amount)).mul(thisMultiplier).div(MULTIPLIER);
        t = (toUB.add(amount.sub(dist.add(fee)))).mul(thisMultiplier).div(MULTIPLIER);
        o = (oUB.add(fee)).mul(thisMultiplier).div(MULTIPLIER);
    }

    function transfer(address to, uint256 amount) public whenNotPaused returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address user, address spender) external view returns (uint256 remaining) {
        return allowed[user][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external whenNotPaused returns (bool success) {
        uint256 _allowance = allowed[from][msg.sender];
        if (_allowance != uint256(-1)) {
            allowed[from][msg.sender] = _allowance.sub(amount);
        }
        _transfer(from, to, amount);
        return true;
    }
}