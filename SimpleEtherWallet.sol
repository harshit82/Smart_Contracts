// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

/*
    This is a simple ether wallet that has the following:
    - It can accept ether from anyone
    - Only the wallet onwner can withdraw the balance from the wallet

    State variables:
    - address of the onwer

    Functions:
    - withdraw
    - deposit
    - get balance
*/

contract SimpleEtherWallet{
    address payable public owner;

    constructor(){
        owner = payable(msg.sender);
    }

    // this function allows the wallet to recieve funds from any external user
    receive() external payable {}

    function getBalance() external view returns(uint){
        // address(this) refers to the address of the current smart contract
        // .balance gives us the balance in the contract
        return address(this).balance;
    }

    function withdraw(uint _withdrawalAmount) external {
        require(msg.sender == owner,"Only onwer can withdraw amount");
        payable(msg.sender).transfer(_withdrawalAmount);
    }
}