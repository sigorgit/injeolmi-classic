pragma solidity ^0.5.6;

import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IInjeolmiPool.sol";
import "./interfaces/IInjeolmi.sol";

contract InjeolmiPool is IInjeolmiPool {
    using SafeMath for uint256;

    IInjeolmi public ijm;

    constructor(IInjeolmi _ijm) public {
        ijm = _ijm;
    }

    function swapToIJM() payable external {
        uint256 totalKlay = address(this).balance;
        uint256 totalIJM = ijm.balanceOf(address(this));

        uint256 _ijm = totalIJM.mul(msg.value).div(totalKlay);

        ijm.transfer(msg.sender, _ijm);
 
        emit SwapToIJM(msg.sender, msg.value);
    }

    function swapToKlay(uint256 amount) external {
        uint256 totalIJM = ijm.balanceOf(address(this));
        uint256 totalKlay = address(this).balance;

        uint256 klay = totalKlay.mul(amount).div(totalIJM).mul(9).div(10);

        ijm.transferFrom(msg.sender, address(this), amount);
        msg.sender.transfer(klay);

        emit SwapToKlay(msg.sender, amount);
    }
}
