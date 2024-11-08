// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import  {ERC20Burnable, ERC20} from  "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from  "@openzeppelin/contracts/access/Ownable.sol";

contract StableCoin is ERC20Burnable , Ownable {

    //errors
    error StableCoin_NotEnoughAmount();
    error StableCoin_NotEnoughBalance();
    error StableCoin_InvalidUser();

     constructor() ERC20("StableCoin", "SC") Ownable(msg.sender){}

    //events
    event minted(address account, uint amount);
     
     function burn(uint amount) public  override onlyOwner   {
         uint balance =  balanceOf(msg.sender);
          if(amount <= 0) {
            revert StableCoin_NotEnoughAmount();
          }
          if(balance < amount){
            revert StableCoin_NotEnoughBalance();
          }

          super.burn(amount);
     }

     function mint(address to , uint amount) public{
         if(amount <= 0) {
            revert StableCoin_NotEnoughAmount();
            
         }
         if(to == address(0)){
            revert StableCoin_InvalidUser();
         }
         _mint(to, amount);
        emit minted(to, amount); 
     }
     

}