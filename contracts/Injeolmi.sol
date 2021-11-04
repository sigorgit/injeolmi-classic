pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./klaytn-contracts/lifecycle/Pausable.sol";
import "./interfaces/IInjeolmi.sol";

// 우리나라에는 새로 이사를 오면 떡을 돌리는 풍습이 있습니다.
// 이런 "떡돌리기" 문화를 토크노믹스로 만들어 보았습니다.
// 한국인의 정과 훈훈한 인심을 느껴보세요.
contract Injeolmi is Ownable, Pausable, IInjeolmi {
    using SafeMath for uint256;

    string public constant NAME = "Injeolmi";
    string public constant SYMBOL = "IJM";

    // 1억개 발행, 추가 발행 없음
    uint256 public constant COIN = 100000000**uint256(DECIMALS);
    uint8 public constant DECIMALS = 8;
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
        return COIN;
    }

    constructor() public {
        _userInfo[msg.sender].lastBalance = COIN;
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

            uint256 thisMultiplier = COIN.mul(MULTIPLIER).div(COIN.sub(dist));

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
