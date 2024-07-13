// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


 

import {IERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {ERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "../lib/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "../lib/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {ACConfig} from "./ACConfig.sol";


contract LV is ERC20Upgradeable,UUPSUpgradeable,OwnableUpgradeable{

    address public usdt;
    address public platformAddress;
    address public monthDividendAddress;
    uint256 public platformRate;
    uint256 public swapRate;
    
    ACConfig public btbConfig;


    function initialize(address _btbConfig)external initializer{
        __Ownable_init();
        __ERC20_init('LV','LV');

        btbConfig = ACConfig(_btbConfig);
	_mint(msg.sender, 1000000000000 ether);
    }

    // required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function changeConfig(address _btbConfig)external onlyOwner{
        btbConfig = ACConfig(_btbConfig);
    }

    function mint(uint256 amount)external onlyOwner{
        _mint(msg.sender, amount);
    }


    function burn(uint256 amount)external onlyOwner{
        _burn(msg.sender, amount);
    }

    function swap(uint256 amount)external {
        IERC20Upgradeable(btbConfig.usdt()).transferFrom(msg.sender, btbConfig.platformAddress(), amount * btbConfig.platformRate() / 1000);
        IERC20Upgradeable(btbConfig.usdt()).transferFrom(msg.sender, btbConfig.monthDividendAddress(), amount * (1000 - btbConfig.platformRate()) / 1000);

        _mint(msg.sender, amount * btbConfig.swapRate() / 1000);
    }
}