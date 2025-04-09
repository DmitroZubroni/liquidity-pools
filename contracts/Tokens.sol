// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";



contract Gerda is ERC20("GerdaCoin", "GERDA") {

    constructor(address tom, address ben){
        _mint(msg.sender, 80000 * 10 ** 12);
        _mint(tom, 10000 * 10 ** 12);
        _mint(ben, 10000 * 10 ** 12);
    }

    function transfer(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function price() public pure returns(uint){
        return 1000000 wei;
    }
}

contract Krendel is ERC20("KrendelCoin", "KRENDEL") {

    constructor(address tom, address ben){
        _mint(msg.sender, 130000 * 10 ** 12);
        _mint(tom, 10000 * 10 ** 12);
        _mint(ben, 10000 * 10 ** 12);
    }

    function transfer(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function price() public pure returns(uint){
        return 1500000 wei;
    }
}

contract RTK is ERC20("RTKCoin", "RTK") {

    constructor(address tom, address ben){
        _mint(msg.sender, 280000 * 10 ** 12);
        _mint(tom, 10000 * 10 ** 12);
        _mint(ben, 10000 * 10 ** 12);
    }

    function transfer(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function price() public pure returns(uint){
        return 3000000 wei;
    }
}

contract LpToken is ERC20("Professional", "PROFI") {

    function transfer(address from, address to, uint amount) public {
        _transfer(from,to,amount);
    }

    function price() public pure returns(uint){
        return 6000000 wei;
    }

    function mint(address from, uint amount) public {
        _mint(from,amount);
    }

    function burn( address to, uint amount) public {
        _burn(to,amount);
    }
}