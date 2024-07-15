// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;


 
import {IERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol"; 
import {UUPSUpgradeable} from "../lib/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "../lib/contracts-upgradeable/access/OwnableUpgradeable.sol";
 



import {ACConfig} from "./ACConfig.sol";

contract MinePool is OwnableUpgradeable,UUPSUpgradeable{

    ACConfig public acbConfig;

    modifier onlyMMStore(){
        require(msg.sender == acbConfig.mmStore(),'only mmStore');
        _;
    }

    function initialize(address _acbConfig)external initializer{
        __Ownable_init();

        acbConfig = ACConfig(_acbConfig);
    }

    // required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}


    function changeConfig(address _acbConfig)external onlyOwner{
        acbConfig = ACConfig(_acbConfig);
    }
    
    function withdraw(address to,uint256 amount) external onlyMMStore {
        IERC20Upgradeable(acbConfig.acb()).transfer(to,amount);
    }


}