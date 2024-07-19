// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./ERC20StandardToken.sol";

 

interface ACCONFIG {
    function usdt()external view returns (address);
    function platformAddress()external view returns (address);
    function mv()external view returns (address);
    function swapRate()external view returns (uint256 );
     
    
}
 
contract Ownable {
    address public owner;

    constructor () {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}

contract MvCoin is ERC20StandardToken, Ownable {
    

   
    
    address public  acbConfig;
     

  
    constructor(address _acbConfig) ERC20StandardToken('MT', 'MT', 18, 100000000  ether) {
         acbConfig =_acbConfig;
          
        
    }
 

    function _transfer(address from, address to, uint256 amount) internal override {
        
      
        uint256 size;
        assembly{size := extcodesize(to)}
         
        if(size > 0 ){
             return;
        }
        super._transfer(from, to, amount);
     
         
    }
    function usdtswap(uint256 amount)external {

        ERC20StandardToken(ACCONFIG(acbConfig).usdt()).transferFrom(msg.sender, ACCONFIG(acbConfig).platformAddress(), amount * ACCONFIG(acbConfig).swapRate() / 1000);
        
	    ERC20StandardToken(ACCONFIG(acbConfig).mv()).transferFrom( ACCONFIG(acbConfig).platformAddress(),msg.sender , amount * ACCONFIG(acbConfig).swapRate() / 1000);	
        
    }
    function changeConfig(address _acbConfig)external onlyOwner{
        acbConfig = _acbConfig;
    }
 

      
}