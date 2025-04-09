// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Factory.sol";
import "./Pool.sol";

contract Router {
    
    Factory factory;

    constructor(address _factory) {
        factory = Factory(_factory);
    }

    function trade(address supplyToken, address demandToken, uint256 supplyAmount) external {
        uint256 intermediateTokenAmount;
        address intermediateToken;
        uint demandTokenAmount;

        // Перевод токенов предложения от пользователя в контракт
        IToken(supplyToken).transfer(msg.sender, address(this), supplyAmount);

        // Получаем адреса пулов из фабрики
        address[] memory poolAddresses = factory.getPool();

        // Первый цикл: Ищем прямой обмен или промежуточный токен
        for (uint256 i = 0; i < poolAddresses.length; i++) {
            Pool pool = Pool(poolAddresses[i]);
            (address tokenA, address tokenB, , , , , , , ) = pool.getToken();

            if (tokenA == supplyToken) {
                // Проверяем, можно ли сразу обменять на токен спроса
                if (tokenB == demandToken) {
                    demandTokenAmount = pool.swap(supplyAmount, true); // Используем глобальную переменную
                    IToken(demandToken).transfer(address(this), msg.sender, demandTokenAmount);
                    return;
                }

                // Выполняем обмен на промежуточный токен
                intermediateTokenAmount = pool.swap(supplyAmount, true);
                intermediateToken = tokenB;
                break;
            }

            if (tokenB == supplyToken) {
                // Проверяем, можно ли сразу обменять на токен спроса
                if (tokenA == demandToken) {
                    demandTokenAmount = pool.swap(supplyAmount, false); // Используем глобальную переменную
                    IToken(demandToken).transfer(address(this), msg.sender, demandTokenAmount);
                    return;
                }

                // Выполняем обмен на промежуточный токен
                intermediateTokenAmount = pool.swap(supplyAmount, false);
                intermediateToken = tokenA;
                break;
            }
        }

        // Второй цикл: Ищем путь от промежуточного токена к токену спроса
        for (uint256 i = 0; i < poolAddresses.length; i++) {
            Pool pool = Pool(poolAddresses[i]);
            (address tokenA, address tokenB, , , , , , , ) = pool.getToken();

            if (tokenA == intermediateToken && tokenB == demandToken) {
                demandTokenAmount = pool.swap(intermediateTokenAmount, true);
                break;
            }

            if (tokenB == intermediateToken && tokenA == demandToken) {
                demandTokenAmount = pool.swap(intermediateTokenAmount, false);
                break;
            }
        }

        require(demandTokenAmount > 0);

        // Передача токенов спроса пользователю
        IToken(demandToken).transfer(address(this), msg.sender, demandTokenAmount);
    }
}
