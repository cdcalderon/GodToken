// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GodTokenV2 is ERC777, Ownable {
   mapping(address => bool) private _godModes;

    event GodModeEnabled(address indexed godMode);
    event GodModeDisabled(address indexed godMode);

    constructor(string memory name, string memory symbol, address[] memory defaultOperators) ERC777(name, symbol, defaultOperators) {}

    function enableGodMode(address godMode) public onlyOwner {
        require(godMode != address(0), "Invalid god mode address");
        _godModes[godMode] = true;
        emit GodModeEnabled(godMode);
    }

    function disableGodMode(address godMode) public onlyOwner {
        require(godMode != address(0), "Invalid god mode address");
        _godModes[godMode] = false;
        emit GodModeDisabled(godMode);
    }

    function godTransfer(address sender, address recipient, uint256 amount) public {
        require(_godModes[msg.sender], "Caller does not have god mode enabled");
       _send(sender, recipient, amount, bytes(""), bytes(""), false);
    }
}
