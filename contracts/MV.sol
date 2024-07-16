// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


 

import {IERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {ERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "../lib/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "../lib/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {ACConfig} from "./ACConfig.sol";


contract MV is ERC20Upgradeable,UUPSUpgradeable,OwnableUpgradeable{

    address public usdt;
    address public platformAddress;
    address public monthDividendAddress;
    uint256 public platformRate;
    uint256 public swapRate;
    
    ACConfig public acbConfig;


    function initialize(address _acbConfig)external initializer{
        __Ownable_init();
        __ERC20_init('MV','MV');

        acbConfig = ACConfig(_acbConfig);
	_mint(msg.sender, 100000000 ether);
    }

    // required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function changeConfig(address _acbConfig)external onlyOwner{
        acbConfig = ACConfig(_acbConfig);
    }

    function mint(uint256 amount)external onlyOwner{
        _mint(msg.sender, amount);
    }


    function burn(uint256 amount)external onlyOwner{
        _burn(msg.sender, amount);
    }

    function swap(uint256 amount)external {
        IERC20Upgradeable(acbConfig.usdt()).transferFrom(msg.sender, acbConfig.platformAddress(), amount * acbConfig.platformRate() / 1000);
        IERC20Upgradeable(acbConfig.usdt()).transferFrom(msg.sender, acbConfig.monthDividendAddress(), amount * (1000 - acbConfig.platformRate()) / 1000);

        _mint(msg.sender, amount * acbConfig.swapRate() / 1000);
    }

   function usdtswap(uint256 amount)external {
        IERC20Upgradeable(acbConfig.usdt()).transferFrom(msg.sender, acbConfig.platformAddress(), amount * acbConfig.swapRate() / 1000);
        
	    IERC20Upgradeable(acbConfig.mv()).transferFrom( acbConfig.platformAddress(),msg.sender , amount * acbConfig.swapRate() / 1000);	
        
    }
      function _acbPrice()internal view returns(uint256) {
        
    }
 
}