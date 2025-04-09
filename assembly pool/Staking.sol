// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Pool.sol";
import "./Tokens.sol";

contract Staking {
    uint rewardSecond;
    uint TotalTokens;
    LpToken private lpToken;

    struct Stakes {
        uint lastDepositTime;
        uint lastRewardTime;
        uint tokens;
    }

    mapping(address => Stakes) public stakes;

    constructor(address _lpToken) {
        lpToken = LpToken(_lpToken);
    }

    function deposit(uint amount) external {
    assembly {
        let sender := caller()
        let ptr := mload(0x40)

        // Получаем баланс пользователя
        mstore(ptr, 0x70a08231) // balanceOf(address) selector
        mstore(add(ptr, 0x04), sender)
        let success := staticcall(gas(), sload(lpToken.slot), ptr, 0x24, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        let userBalance := mload(ptr)

        // Проверяем, хватает ли токенов
        if lt(userBalance, amount) { revert(0, 0) }

        // Выполняем transfer
        mstore(ptr, 0xa9059cbb) // transfer(address,uint256) selector
        mstore(add(ptr, 0x04), address())
        mstore(add(ptr, 0x24), amount)
        
        // Исправление: используем `call` для выполнения функции, которая изменяет состояние (transfer)
        success := call(gas(), sload(lpToken.slot), ptr, 0x44, 0, 0, 0)
        if iszero(success) { revert(0, 0) }

        // Обновляем lastDepositTime
        let stakePtr := keccak256(sender, 0x00) // Получаем хеш-адреса для mapping
        sstore(add(stakePtr, 0x00), timestamp()) // lastDepositTime

        // Если lastRewardTime == 0, устанавливаем его
        let lastRewardTime := sload(add(stakePtr, 0x20))
        if iszero(lastRewardTime) { sstore(add(stakePtr, 0x20), timestamp()) }

        // Обнуляем TotalTokens
        sstore(TotalTokens.slot, 0)
    }
}


    function calculateReward(uint timeDiff) internal view returns (uint reward) {
        assembly {
            let sender := caller()
            let stakePtr := keccak256(sender, 0x00)
            let tokens := sload(add(stakePtr, 0x40))
            let totalTokens := sload(TotalTokens.slot)
            let rewardPerSecond := sload(rewardSecond.slot)

            if iszero(tokens) { reward := 0 }
            if iszero(totalTokens) { reward := 0 }
            if iszero(rewardPerSecond) { reward := 0 }

            let multiplier := div(tokens, add(div(tokens, totalTokens), 1))
            let periodBonus := add(div(div(timeDiff, 2592000), 20), 1)


            reward := mul(mul(tokens, timeDiff), rewardPerSecond)
            reward := mul(reward, multiplier)
            reward := mul(reward, periodBonus)
        }
    }

    function claimReward() external {
        assembly {
            let sender := caller()
            let stakePtr := keccak256(sender, 0x00)

            let tokens := sload(add(stakePtr, 0x40))
            if iszero(tokens) { revert(0, 0) }

            let lastRewardTime := sload(add(stakePtr, 0x20))
            let timeDiff := sub(timestamp(), lastRewardTime)

            let ptr := mload(0x40)
            let reward := 0

            // Вызываем calculateReward через delegatecall
            mstore(ptr, 0x61bc221a) // calculateReward(uint256) selector
            mstore(add(ptr, 0x04), timeDiff)
            let success := staticcall(gas(), address(), ptr, 0x24, ptr, 0x20)
            if iszero(success) { revert(0, 0) }
            reward := mload(ptr)

            // Минтим токены пользователю
            mstore(ptr, 0x40c10f19) // mint(address,uint256) selector
            mstore(add(ptr, 0x04), sender)
            mstore(add(ptr, 0x24), reward)
            success := call(gas(), sload(lpToken.slot), 0, ptr, 0x44, 0, 0)
            if iszero(success) { revert(0, 0) }

            // Обновляем lastRewardTime
            sstore(add(stakePtr, 0x20), timestamp())
        }
    }

    function getStaking() external view returns (uint rewardGo, uint depositTime, uint stakedTokens) {
    assembly {
        let sender := caller()
        let stakePtr := keccak256(sender, 0x00)

        // Загружаем данные из хранилища
        stakedTokens := sload(add(stakePtr, 0x40))
        depositTime := sload(add(stakePtr, 0x00))

        let lastRewardTime := sload(add(stakePtr, 0x20))

        // Используем switch для ветвления
        switch iszero(lastRewardTime)
        case 1 {
            // Если lastRewardTime == 0
            rewardGo := 0
        }
        default {
            // Если lastRewardTime != 0
            let timeDiff := sub(timestamp(), lastRewardTime)
            let ptr := mload(0x40)

            // Вызываем calculateReward через staticcall
            mstore(ptr, 0x61bc221a) // calculateReward(uint256) selector
            mstore(add(ptr, 0x04), timeDiff)
            let success := staticcall(gas(), address(), ptr, 0x24, ptr, 0x20)
            if iszero(success) { 
                revert(0, 0) 
            }
            rewardGo := mload(ptr)
        }
    }
}

}
