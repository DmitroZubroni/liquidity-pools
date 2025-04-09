// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./ERC20.sol";
import "./Tokens.sol";

interface IToken is IERC20Metadata {
    function price() external pure returns (uint);
    function transfer(address from, address to, uint amount) external;
    function mint(address account, uint256 amount) external;
}

contract Pool {
    address tokenA;
    address tokenB;
    address owner;
    LpToken public lpToken;

    constructor(address _tokenA, address _tokenB, address _lpToken, address _owner, uint _reserveA, uint _reserveB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        lpToken = LpToken(_lpToken);
        owner = _owner;
        IToken(tokenA).transfer(owner, address(this), _reserveA);
        IToken(tokenB).transfer(owner, address(this), _reserveB);
    }

    /// @notice Обмен токенов в пуле
    /// @param amount Количество отправляемых токенов
    /// @param fromAtoB true, если обмениваем tokenA на tokenB, иначе наоборот
    /// @return amountTo Количество полученных токенов
    function swap(uint amount, bool fromAtoB) external returns (uint amountTo) {
        bytes4 transferSig = bytes4(keccak256("transfer(address,address,uint256)"));
        bytes4 balanceOfSig = bytes4(keccak256("balanceOf(address)"));
        
        assembly {
            let A := sload(tokenA.slot)
            let B := sload(tokenB.slot)
            let from := A
            let to := B
            if iszero(fromAtoB) {
                from := B
                to := A
            }
            
            let ptr := mload(0x40)
            mstore(ptr, balanceOfSig)
            mstore(add(ptr, 0x04), address())
            let success := staticcall(gas(), from, ptr, 0x24, ptr, 0x20)
            if iszero(success) { revert(0, 0) }
            let balanceFrom := mload(ptr)

            mstore(ptr, balanceOfSig)
            mstore(add(ptr, 0x04), address())
            success := staticcall(gas(), to, ptr, 0x24, ptr, 0x20)
            if iszero(success) { revert(0, 0) }
            let balanceTo := mload(ptr)
            
            amountTo := div(mul(amount, balanceTo), balanceFrom)
            
            mstore(ptr, transferSig)
            mstore(add(ptr, 0x04), caller())
            mstore(add(ptr, 0x24), address())
            mstore(add(ptr, 0x44), amount)
            success := call(gas(), from, 0, ptr, 0x64, 0, 0)
            if iszero(success) { revert(0, 0) }

            mstore(ptr, transferSig)
            mstore(add(ptr, 0x04), address())
            mstore(add(ptr, 0x24), caller())
            mstore(add(ptr, 0x44), amountTo)
            success := call(gas(), to, 0, ptr, 0x64, 0, 0)
            if iszero(success) { revert(0, 0) }
        }
    }

    /// @notice Добавление ликвидности в пул
    /// @param amount Количество добавляемых токенов
    /// @param transferA true, если добавляется tokenA, иначе tokenB
    function addLiquidity(uint amount, bool transferA) external {
        bytes4 transferSig = bytes4(keccak256("transfer(address,address,uint256)"));
        bytes4 priceSig = bytes4(keccak256("price()"));
        bytes4 mintSig = bytes4(keccak256("mint(address,uint256)"));
        
        assembly {
            let A := sload(tokenA.slot)
            let B := sload(tokenB.slot)
            let token := A
            if iszero(transferA) { token := B }
            
            let ptr := mload(0x40)
            mstore(ptr, priceSig)
            let success := staticcall(gas(), token, ptr, 0x4, ptr, 0x20)
            if iszero(success) { revert(0, 0) }
            let tokenPrice := mload(ptr)

            mstore(ptr, priceSig)
            success := staticcall(gas(), sload(lpToken.slot), ptr, 0x4, ptr, 0x20)
            if iszero(success) { revert(0, 0) }
            let lpPrice := mload(ptr)
            
            let tokenMint := div(mul(amount, tokenPrice), lpPrice)
            
            mstore(ptr, transferSig)
            mstore(add(ptr, 0x04), caller())
            mstore(add(ptr, 0x24), address())
            mstore(add(ptr, 0x44), amount)
            success := call(gas(), token, 0, ptr, 0x64, 0, 0)
            if iszero(success) { revert(0, 0) }
            
            mstore(ptr, mintSig)
            mstore(add(ptr, 0x04), caller())
            mstore(add(ptr, 0x24), tokenMint)
            success := call(gas(), sload(lpToken.slot), 0, ptr, 0x44, 0, 0)
            if iszero(success) { revert(0, 0) }
        }
    }


    function getTokenInfo() external view returns (string memory nameA, string memory nameB, uint priceA, uint priceB, uint amountA, uint amountB) {
    bytes4 nameSig = bytes4(keccak256("name()"));
    bytes4 priceSig = bytes4(keccak256("price()"));
    bytes4 balanceOfSig = bytes4(keccak256("balanceOf(address)"));

    assembly {
        let A := sload(tokenA.slot)
        let B := sload(tokenB.slot)

        // Получаем имя токена A
        let ptr := mload(0x40)
        mstore(ptr, nameSig)
        let success := staticcall(gas(), A, ptr, 0x4, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        nameA := mload(ptr)
        mstore(ptr, add(ptr, 0x20)) // Обнуляем значение указателя

        // Получаем имя токена B
        mstore(ptr, nameSig)
        success := staticcall(gas(), B, ptr, 0x4, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        nameB := mload(ptr)
        mstore(ptr, add(ptr, 0x20))

        // Получаем цену токена A
        mstore(ptr, priceSig)
        success := staticcall(gas(), A, ptr, 0x4, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        priceA := mload(ptr)
        mstore(ptr, add(ptr, 0x20))

        // Получаем цену токена B
        mstore(ptr, priceSig)
        success := staticcall(gas(), B, ptr, 0x4, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        priceB := mload(ptr)
        mstore(ptr, add(ptr, 0x20))

        // Получаем баланс токена A в пуле
        mstore(ptr, balanceOfSig)
        mstore(add(ptr, 0x04), address()) // Адрес пула (this)
        success := staticcall(gas(), A, ptr, 0x24, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        amountA := mload(ptr)
        mstore(ptr, add(ptr, 0x24))

        // Получаем баланс токена B в пуле
        mstore(ptr, balanceOfSig)
        mstore(add(ptr, 0x04), address()) // Адрес пула (this)
        success := staticcall(gas(), B, ptr, 0x24, ptr, 0x20)
        if iszero(success) { revert(0, 0) }
        amountB := mload(ptr)
        mstore(ptr, add(ptr, 0x24))
    }
}

}
