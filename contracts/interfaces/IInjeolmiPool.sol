pragma solidity ^0.5.6;

interface IInjeolmiPool {

    event SwapToIJM(address indexed user, uint256 amount);
    event SwapToKlay(address indexed user, uint256 amount);

    function swapToIJM() payable external;
    function swapToKlay(uint256 amount) external;
}
