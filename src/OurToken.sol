// SPDX-License-Identifier: MIT
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.21;

contract OurToken is ERC20{
    address public admin;
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
       admin = msg.sender;
    }
    function adminintrator() public view returns(address){
        return admin;
    }
}
