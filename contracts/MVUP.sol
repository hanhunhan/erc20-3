// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


 

import {IERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {ERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {Initializable} from "../lib/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "../lib/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "../lib/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {ACConfig} from "./ACConfig.sol";


contract MVEXCHANGE is Initializable,  ERC20Upgradeable,UUPSUpgradeable,OwnableUpgradeable{

    address public usdt;
    address public platformAddress;
    address public monthDividendAddress;
    address public acbConfig;
    address public teamRewardAddress;
    address public remainingAddress;
    uint256 public platformRate;
    uint256 public swapRate;
    
    


    function initialize(address _acbConfig)external initializer{
        __Ownable_init();
        __ERC20_init('MVEX','MVEX');
 
	    _mint(msg.sender, 2 ether);
        acbConfig =_acbConfig;
    }

    // required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function changeConfig(address _acbConfig)external onlyOwner{
        acbConfig = _acbConfig;
    }

 

 
 

   function usdtswap(uint256 amount)external {
    
        bool res = IERC20Upgradeable(ACCONFIG(acbConfig).usdt()).transferFrom(msg.sender, ACCONFIG(acbConfig).teamRewardAddress(), amount * ACCONFIG(acbConfig).swapRate() / 1000);
        if(res){
            IERC20Upgradeable(ACCONFIG(acbConfig).mv()).transferFrom( ACCONFIG(acbConfig).remainingAddress(),msg.sender , amount * ACCONFIG(acbConfig).swapRate() / 1000);
        }
        
	    		
        
    }
   
 
}


interface ACCONFIG {
    function usdt()external view returns (address);
    function platformAddress()external view returns (address);
    function mv()external view returns (address);
    function swapRate()external view returns (uint256 );
    function teamRewardAddress()external view returns (address );
    function remainingAddress()external view returns (address );
    function mvCollectionAddress()external view returns (address );
    function techAddress()external view returns (address );
    function marketAddress()external view returns (address );
     
    
}