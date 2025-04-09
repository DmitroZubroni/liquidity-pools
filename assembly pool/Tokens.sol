// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ERC20.sol";

contract GerdaCoin is ERC20("GerdaCoin", "GERDA") {
    //конструктор который выпускает токены на адресс того, кто деплоил контракт
    constructor() {
        _mint(msg.sender, 100000 * 10 ** 12);
    }

    //функция определяющая цену токена
    function price() public pure returns(uint) {
        return 1000000 wei;
    }

    function decimals() public pure override   returns(uint8){
        return 12;
    }

    //функция для перевода токена от третьего лица
    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }
}

contract KrendelCoin is ERC20("KrendelCoin", "KRENDEL") {
    //конструктор который выпускает токены на адресс того, кто деплоил контракт
      constructor() {
        _mint(msg.sender, 150000 * 10 ** 12);
    }
    //функция определяющая цену токена
    function price() public pure returns(uint) {
        return 1500000 wei;
    }

    function decimals() public pure override   returns(uint8){
        return 12;
    } 


    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }
}


contract RTKCOIN is ERC20("RTKCOIN", "RTK") {
    //конструктор который выпускает токены на адресс того, кто деплоил контракт
      constructor() {
        _mint(msg.sender, 300000 * 10 ** 12);
    }
    //функция определяющая цену токена
    function price() public pure returns(uint) {
        return 3000000 wei;
    }

    function decimals() public pure override   returns(uint8){
        return 12;
    }

    //функция для перевода токена от третьего лица
    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }
}



contract LpToken is ERC20("Profesional", "PROFI") {
    //функция определяющая цену токена
    function price() public pure returns(uint) {
        return 6000000 wei;
    }
    
    function decimals() public pure override   returns(uint8){
        return 12;
    }

    //функция для перевода токена от третьего лица
    function transfer(address from, address to, uint amount) public {
        _transfer(from, to, amount);
    }
    //функция позволяющая выпускать токены
    function mint(address from, uint amount) public {
        _mint(from, amount);
    }
    //функция позволяющая сжигать токены
    function burn(address to, uint amount) public {
        _burn(to, amount);
    }
}