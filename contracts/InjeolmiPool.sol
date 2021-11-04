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

    function () payable external {}

    function swapToIJM() external payable {
        uint256 newKlay = address(this).balance;
        uint256 lastIJM = ijm.balanceOf(address(this));

        uint256 newIJM = (newKlay.sub(msg.value)).mul(lastIJM).div(newKlay);

        ijm.transfer(msg.sender, lastIJM.sub(newIJM));

        emit SwapToIJM(msg.sender, msg.value);
    }

    function swapToKlay(uint256 amount) external {
        uint256 lastKlay = address(this).balance;
        uint256 lastIJM = ijm.balanceOf(address(this));

        uint256 newKlay = lastIJM.mul(lastKlay).div(lastIJM.add(amount.mul(9).div(10)));

        ijm.transferFrom(msg.sender, address(this), amount);
        msg.sender.transfer(lastKlay.sub(newKlay));

        emit SwapToKlay(msg.sender, amount);
    }

    function addLiquidity() external payable {
        uint256 lastKlay = (address(this).balance).sub(msg.value);
        uint256 lastIJM = ijm.balanceOf(address(this));

        uint256 inputIJM = lastIJM.mul(msg.value).div(lastKlay);
        if(ijm.excluded(msg.sender)) {
            ijm.transferFrom(msg.sender, address(this), inputIJM);
        } else {
            ijm.transferFrom(msg.sender, address(this), inputIJM.mul(10).div(9));
        }
    }
}
