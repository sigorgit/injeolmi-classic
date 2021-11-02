pragma solidity ^0.5.6;

import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IInjeolmi.sol";

contract Airdrop {
    using SafeMath for uint256;

    IInjeolmi public ijm;

    constructor(IInjeolmi _ijm) public {
        ijm = _ijm;
    }

    function airdrop(address[] calldata to, uint256 amount) payable external {
        uint256 len = to.length;
        for (uint256 i = 0; i < len; i = i.add(1)) {
            ijm.transfer(to[i], amount);
        }
    }
}
