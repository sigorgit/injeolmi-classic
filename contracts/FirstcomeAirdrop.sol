pragma solidity ^0.5.6;

import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IInjeolmi.sol";

contract FirstcomeAirdrop is Ownable {
    using SafeMath for uint256;

    IInjeolmi public ijm;
    uint256 public season = 0;
    uint256 public airdropAmount = 1000 * 1e8;
    mapping(uint256 => mapping(address => bool)) public dropped;

    constructor(IInjeolmi _ijm) public {
        ijm = _ijm;
    }

    function setAirdropAmount(uint256 amount) external onlyOwner {
        airdropAmount = amount;
    }

    function newSeason() external onlyOwner {
        season = season.add(1);
    }

    function airdrop() external {
        require(dropped[season][msg.sender] != true);
        ijm.transfer(msg.sender, airdropAmount);
        dropped[season][msg.sender] = true;
    }
}
