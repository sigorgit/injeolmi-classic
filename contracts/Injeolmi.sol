pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IInjeolmi.sol";

// 우리나라에는 새로 이사를 오면 떡을 돌리는 풍습이 있습니다.
// 이런 "떡돌리기" 문화를 토크노믹스로 만들어 보았습니다.
// 한국인의 정과 훈훈한 인심을 느껴보세요.
contract Injeolmi is Ownable, IInjeolmi {
    using SafeMath for uint256;

    string constant public NAME = "Injeolmi";
    string constant public SYMBOL = "IJM";

    // 1억개 발행, 추가 발행 없음
    uint256 constant public COIN = 100000000 ** uint256(DECIMALS);
    uint8 constant public DECIMALS = 8;

    uint256 private _totalDist;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => bool) private excluded;

    function exclude(address addr) external onlyOwner {
        excluded[addr] = true;
    }

    function include(address addr) external onlyOwner {
        excluded[addr] = false;
    }

    function name() external pure returns (string memory) { return NAME; }
    function symbol() external pure returns (string memory) { return SYMBOL; }
    function decimals() external pure returns (uint8) { return DECIMALS; }
    function totalSupply() external pure returns (uint256) { return COIN; }

    constructor() public {
        _userInfo[msg.sender].lastBalance = COIN;
    }

    function balanceOf(address user) external view returns (uint256 balance) {
        uint256 balance = balances[user];
        return balance.add(_totalDist.mul(balance).div(COIN));
    }

    function _transfer(address from, address to, uint256 amount) private {
        uint256 realAmount = amount.mul(COIN).div(COIN.add(_totalDist));
        balances[from] = balances[from].sub(realAmount);
        if (excluded[from] != true) {

            // 9% 떡돌리기
            uint256 dist = realAmount.mul(9).div(100);
            // 1% 떡방앗간 팁
            uint256 fee = realAmount.div(100);

            _totalDist = _totalDist.add(dist);
            realAmount = realAmount.sub(dist).sub(fee);
            balances[owner()] = balances[owner()].add(fee);
        }
        balances[to] = balances[to].add(realAmount);
        emit Transfer(from, to, amount);
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address user, address spender) external view returns (uint256 remaining) {
        return allowed[user][spender];
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool success) {
        uint256 _allowance = allowed[from][msg.sender];
        if (_allowance != uint256(-1)) {
            allowed[from][msg.sender] = _allowance.sub(amount);
        }
        _transfer(from, to, amount);
        return true;
    }
}
