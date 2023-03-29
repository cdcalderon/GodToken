// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GodTokenV3 is ERC777, Ownable {
   address private _godModeAddress;

    event GodModeEnabled(address indexed godMode);
    event GodModeDisabled(address indexed godMode);

    constructor(string memory name, string memory symbol, address[] memory defaultOperators) ERC777(name, symbol, defaultOperators) {}

    function enableGodMode(address godMode) public onlyOwner {
        require(godMode != address(0), "Invalid god mode address");
        _godModeAddress = godMode;
        emit GodModeEnabled(godMode);
    }

    function disableGodMode() public onlyOwner {
        _godModeAddress = address(0);
        emit GodModeDisabled(_godModeAddress);
    }

    function godTransfer(address recipient, uint256 amount, bytes memory data) public {
        require(_godModeAddress != address(0), "God mode not enabled");
        operatorSend(_godModeAddress, recipient, amount, data, bytes(""));

        // operatorSend(address(this), msg.sender, recipient, amount, data, "", false);
        // operatorSend(sender, recipient, amount, data, bytes(""));
    }

    function isGodModeEnabled() public view returns (bool) {
        return _godModeAddress != address(0);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, amount);
        require(isGodModeEnabled() || operator == from, "Transfer not allowed");
    }
}
