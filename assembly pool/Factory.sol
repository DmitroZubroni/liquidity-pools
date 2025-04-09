// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Tokens.sol";
import "./Pool.sol";
import "./ERC20.sol";

contract Factory {

    address[] public poolAddress;
    address public gerda;
    address public krendel;
    address public rtk;
    address public lpToken;
    
    constructor( address _gerda, address _krendel, address _rtk, address _lpToken, address tom, address ben) {
        gerda = _gerda;
        krendel = _krendel;
        rtk = _rtk;
        lpToken = _lpToken;
        
        IToken(_gerda).transfer(msg.sender, address(this), 1500 * 10 ** 12);
        IToken(_krendel).transfer(msg.sender, address(this), 1000 * 10 ** 12);
        IToken(_krendel).transfer(msg.sender, address(this), 2000 * 10 ** 12);
        IToken(_rtk).transfer(msg.sender, address(this), 1000 * 10 ** 12);

        poolAddress.push(address(new Pool(_gerda, _krendel, _lpToken, tom, 1500 * 10 **12, 1000 * 10 **12)));
        poolAddress.push(address(new Pool(_krendel, _rtk, _lpToken, ben, 2000 *10 ** 12,1000 * 10 **12)));
    }

    function createPool(address tokenA, address tokenB, uint reserveA, uint reserveB) external {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, tokenA)
            mstore(add(ptr, 0x20), tokenB)
            mstore(add(ptr, 0x40), sload(lpToken.slot))
            mstore(add(ptr, 0x60), caller())
            mstore(add(ptr, 0x80), reserveA)
            mstore(add(ptr, 0xA0), reserveB)

            let newPool := create(0, ptr, 0xC0)
            if iszero(newPool) { revert(0, 0) }

            // Получаем хранилище массива poolAddress
            let poolSlot := poolAddress.slot
            let length := sload(poolSlot)
            let newSlot := add(keccak256(poolSlot, 0x20), length)

            sstore(newSlot, newPool) // Записываем новый pool в массив
            sstore(poolSlot, add(length, 1)) // Увеличиваем длину массива
        }
    }

    function getPools() external view returns (address[] memory pools) {
        assembly {
            let poolSlot := poolAddress.slot
            let length := sload(poolSlot)

            // Выделяем память под массив
            pools := mload(0x40)
            mstore(pools, length) // Записываем длину массива

            let dataStart := add(pools, 0x20)
            let storageStart := keccak256(poolSlot, 0x20)

            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                mstore(add(dataStart, mul(i, 0x20)), sload(add(storageStart, i)))
            }

            mstore(0x40, add(dataStart, mul(length, 0x20))) // Обновляем свободную память
        }
    }

    function getBalance() external view returns(uint gerdaBalance,uint krendekBalance, uint rkBalance, uint lpBalance, uint ethBalance) {
        return(
            IToken(gerda).balanceOf(msg.sender),
            IToken(krendel).balanceOf(msg.sender),
            IToken(rtk).balanceOf(msg.sender),
            IToken(lpToken).balanceOf(msg.sender),
            msg.sender.balance
        );
    }

}
