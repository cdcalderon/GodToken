// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777.sol";

contract GodToken is ERC777, Ownable {
    mapping(address => bool) private _godModes;

    event GodModeEnabled(address indexed godMode);
    event GodModeDisabled(address indexed godMode);

    constructor(
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    ) ERC777(name, symbol, defaultOperators) {}

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

    function godTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data
    ) public {
        require(_godModes[msg.sender], "Caller does not have god mode enabled");
        operatorSend(sender, recipient, amount, data, bytes(""));
    }
}

// /**
//      * @dev See {IERC777-operatorSend}.
//      *
//      * Emits {Sent} and {IERC20-Transfer} events.
//      */
//     function operatorSend(
//         address sender,
//         address recipient,
//         uint256 amount,
//         bytes memory data,
//         bytes memory operatorData
//     ) public virtual override {
//         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
//         _send(sender, recipient, amount, data, operatorData, true);
//     }
