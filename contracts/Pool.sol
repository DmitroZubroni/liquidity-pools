// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Tokens.sol";


interface IToken is IERC20Metadata {
    function price() external pure returns(uint);
    function transfer(address to, address from, uint amount) external ;
    function mint(address from, uint amount) external ;
}

contract Pool {

    address tokenA;
    address tokenB;
    address owner;
    LpToken lpToken;


    constructor(address _tokenA, address _tokenB, address _owner, address _lpToken, uint reserveA, uint reserveB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        owner = _owner;
        lpToken = LpToken(_lpToken);

        IToken(_tokenA).transfer(_owner, address(this), reserveA);
        IToken(_tokenB).transfer(_owner, address(this), reserveB);
    }



    function swap(uint amount, bool fromAtoB) external returns(uint) {
        uint amountGo;
        if(fromAtoB){
            amountGo = amount * IToken(tokenB).balanceOf(address(this)) / IToken(tokenA).balanceOf(address(this));
            IToken(tokenA).transfer(msg.sender, address(this), amount);
            IToken(tokenB).transfer(address(this), msg.sender, amountGo);
        } else {
            amountGo = amount * IToken(tokenA).balanceOf(address(this)) / IToken(tokenB).balanceOf(address(this));
            IToken(tokenB).transfer(msg.sender, address(this), amount);
            IToken(tokenA).transfer(address(this), msg.sender, amountGo);
        }
        return amountGo;
    }


    function addLiquidity(uint amount, bool fromAtoB) external {
        uint lpPrice = lpToken.price();
        uint tokenPrice = fromAtoB ? IToken(tokenA).balanceOf(address(this)) : IToken(tokenB).balanceOf(address(this));
        uint tokenMint;
        if(fromAtoB){
            IToken(tokenA).transfer(msg.sender, address(this), amount);
        } else {
            IToken(tokenB).transfer(msg.sender, address(this), amount);
        }
        tokenMint = amount * tokenPrice / lpPrice;
        lpToken.mint(msg.sender, tokenMint);
    }


    function getToken() external view returns(address _tokenA, address _tokenB, string memory nameA, string memory nameB, uint priceA, uint priceB, uint amountA, uint amountB, address poolOwner) {
        return(
            address(tokenA),
            address(tokenB),
            IToken(tokenA).name(),
            IToken(tokenB).name(),
            IToken(tokenA).price(),
            IToken(tokenB).price(),
            IToken(tokenA).balanceOf(address(this)),
            IToken(tokenB).balanceOf(address(this)),
            owner
        );
    }
}