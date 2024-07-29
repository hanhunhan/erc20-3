// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.18;
//import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
//import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
//import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
//import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

 
import {IERC20Upgradeable} from "../lib/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol"; 
import {UUPSUpgradeable} from "../lib/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "../lib/contracts-upgradeable/access/OwnableUpgradeable.sol";
 

contract MVEXContract is  OwnableUpgradeable, UUPSUpgradeable {
    address public usdt;
    address public platformAddress;
    address public monthDividendAddress;
    address public acbConfig;
    address public teamRewardAddress;
    address public remainingAddress;
    uint256 public platformRate;
    uint256 public swapRate;
    
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
       
    }

    function initialize(address _acbConfig) initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();
         acbConfig =_acbConfig;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}


    
   
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