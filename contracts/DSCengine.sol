// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

import {StableCoin} from "./Lock.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract DSCEngine {
      /////////////////////////////////////////
                   //ERROR 
       ////////////////////////////////////////

       error DSCEngine_NotZeroAmount();
       error DSCEngine_NotValidTokenPriceFeedAddress();
       error DSCEngine_NotAllowedAddress();
       error DSCEngine__TransferFailed();
       /////////////////////////////////////////
                //State Variables
       /////////////////////////////////////////

       mapping(address token => address pricefeed) private s_allowedAddress;
       mapping(address user => mapping(address token => uint amount)) private s_colletralAmount;
       mapping(address user => uint colletralAmount) private s_mintedColletralAmount;
       address[] private s_tokenAddress;
       address[] private s_priceFeedAddress;
       StableCoin private immutable d_sc;

       ///////////////////////////////////////////
                    //EVENTS
       ///////////////////////////////////////////
       event ColletralDeposited(address user, address tokenaddress , uint tokenAmount);

       ///////////////////////////////////////////
                    //MODIFIER
       ///////////////////////////////////////////
       modifier isAllowedToken(address token){
             if(token == address(0)){
                revert DSCEngine_NotAllowedAddress(); 
             }
             _;
       }

       ////////////////////////////////////////////
                // EXTERNAL FUNCTION
       ////////////////////////////////////////////
       
       constructor(address[] memory _tokenAddress , address[] memory _pricefeed , address d_scAddress){
        if(_tokenAddress.length != _pricefeed.length){
            revert DSCEngine_NotValidTokenPriceFeedAddress();
        }
             for(uint i = 0 ; i < _tokenAddress.length ; i++){
                 s_allowedAddress[_tokenAddress[i]] = _pricefeed[i];
               }
               d_sc = StableCoin(d_scAddress);
       }
       
       
       function despositeColletral(
        uint256 amount,
        address tokenAddress
       ) external isAllowedToken(tokenAddress) {
          if(amount <= 0 ){
            revert DSCEngine_NotZeroAmount();
          }
          s_colletralAmount[msg.sender ][tokenAddress] = amount;
          emit ColletralDeposited(msg.sender, tokenAddress, amount);
          bool success = IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
          if(!success){
            revert DSCEngine__TransferFailed();
          }
          
       }

       function mintDSCToken(uint dscToken) external {
           s_mintedColletralAmount[msg.sender] += dscToken ;
           revertifHealthFactorIsBroken();
       }

       /////////////////////////////////////////////////////////
              // INTERNAL FUNCTION AND PRIVATE AND VIEW 
       /////////////////////////////////////////////////////////
       function revertifHealthFactorIsBroken() internal {
          // if health factor is broken revert 
       }

       function _healthFactor() internal returns(bool) {

       }
       function _getInformation() internal returns(uint){
        
       }

}