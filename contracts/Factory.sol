// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Pool.sol";


contract Factory {

    address [] poolAddress;
    address gerda;
    address krendel;
    address rtk;
    address lpToken;


    constructor(address _gerda, address _krendel, address _rtk, address _lpToken, address tom, address ben) {
        gerda = _gerda;
        krendel = _krendel;
        rtk = _rtk;
        lpToken = _lpToken;

        IToken(_gerda).transfer(msg.sender, address(this), 1500 * 10 ** 12);
        IToken(_krendel).transfer(msg.sender, address(this), 1000 * 10 ** 12);
        IToken(_krendel).transfer(msg.sender, address(this), 2000 * 10 ** 12);
        IToken(_rtk).transfer(msg.sender, address(this), 1000 * 10 ** 12);

        poolAddress.push(address(new Pool(_gerda, _krendel, tom, _lpToken,  1500 * 10 **12, 1000 * 10 **12)));
        poolAddress.push(address(new Pool(_krendel, _rtk, ben, _lpToken,  2000 *10 ** 12,1000 * 10 **12)));
    }


    function createPool(address tokenA, address tokenB, uint reserveA, uint reserveB) external  {
        poolAddress.push(address(new Pool(tokenA, tokenB, msg.sender, lpToken, reserveA, reserveB)));
    }


    function getPool() external view returns(address [] memory) {
        return poolAddress;
    }


    function getBalance() external view returns(
    uint256 gerdaBalance,
    uint256 krendelBalance,
    uint256 rtkBalance,
    uint256 lpBalance,
    uint256 ethBalance
) {
    return (
        IToken(gerda).balanceOf(msg.sender),
        IToken(krendel).balanceOf(msg.sender),
        IToken(rtk).balanceOf(msg.sender),
        IToken(lpToken).balanceOf(msg.sender),
        msg.sender.balance 
    );
}
}