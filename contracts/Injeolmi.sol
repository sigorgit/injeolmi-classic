pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IInjeolmi.sol";

// 우리나라에는 새로 이사를 오면 떡을 돌리는 풍습이 있습니다.
// 이런 "떡돌리기" 문화를 토크노믹스로 만들어 보았습니다.
// 한국인의 정과 훈훈한 인심을 느껴보세요.
contract Injeolmi is Ownable, IInjeolmi {
    using SafeMath for uint256;

    string  constant public NAME = "Injeolmi";
    string  constant public SYMBOL = "IJM";

    // 1억개 발행, 추가 발행 없음
    uint256 constant public COIN = 100000000 ** uint256(DECIMALS);
    uint8   constant public DECIMALS = 18;

    uint256 private _totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    function name() external pure returns (string memory) { return NAME; }
    function symbol() external pure returns (string memory) { return SYMBOL; }
    function decimals() external pure returns (uint8) { return DECIMALS; }
    function totalSupply() external view returns (uint256) { return _totalSupply; }
    
    function balanceOf(address user) external view returns (uint256 balance) {
        return balances[user];
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(msg.sender, to, amount);
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
        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(from, to, amount);
        return true;
    }
}
