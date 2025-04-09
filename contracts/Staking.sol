// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Pool.sol";

contract Staking{


    uint totalToken;
    LpToken lpToken;

    constructor(address _lpToken) {
        lpToken = LpToken(_lpToken);
    }

    struct Stake{
        uint lastDepositTime;
        uint lastRewardTime;
        uint stakedTokens;
    }


    mapping(address => Stake) stakes;


    function deposit(uint amount) external {
        lpToken.transfer(msg.sender, address(this), amount);
        stakes[msg.sender].stakedTokens += amount;
        totalToken += amount;
        stakes[msg.sender].lastDepositTime = block.timestamp;
    }

    function calculateReward() internal view returns(uint) {
        uint timeDiff = block.timestamp - stakes[msg.sender].lastRewardTime;

        uint rewardGo = stakes[msg.sender].stakedTokens * timeDiff * 13 /
        (stakes[msg.sender].stakedTokens / totalToken + 1) *
        (((timeDiff / 30 days)  / 20 ) + 1); 
        return rewardGo; 
    }

    function claimReward() external {
        require(stakes[msg.sender].stakedTokens > 0, unicode"вы не вкладывали токены");
        uint reward = calculateReward();
        lpToken.mint(msg.sender, reward);
        stakes[msg.sender].lastRewardTime = block.timestamp;
    }


    function getStaking() external view returns(uint depositTime, uint rewardGo, uint tokenGo){
            depositTime = stakes[msg.sender].lastDepositTime;
            rewardGo = calculateReward();
            tokenGo = stakes[msg.sender].stakedTokens;
    }
}