// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
- This contract allow a user to buy a drink from the vending machine
- The vending machine has 100 drinks available initially
*/
contract VendingMachine {
    // state variables
    address owner;
    uint perDrinkPrice;
    mapping(address => uint256) drinksBalances;

    constructor() {
        // initializing the owner
        owner = msg.sender;
        // initializing the perDrinkPrice
        perDrinkPrice = 2 ether;
        // the machine has an inital count of 100 drinks
        drinksBalances[address(this)] = 100;
    }

    /*
        Allows a user to purchase a drink from the vending machine
    */
    function purchase(uint amountToPurchase) public payable {
        require(msg.value >= amountToPurchase * perDrinkPrice, "Not enough ether supplied");
        require(drinksBalances[address(this)] >= amountToPurchase, "Not enough drinks available");
        drinksBalances[address(this)] -= amountToPurchase; 
        drinksBalances[msg.sender] += amountToPurchase;
    }
    
    /*
        Adds to the supply in the vending machine
    */
    function restock(uint256 restockBalance) public {
        // checks if the address of the account currently accessing the smart contract is the owner or not
        require(msg.sender == owner, "You are not the owner, so you are not allowed to restock");
        // if yes then it increments the amount of drinks in the vending machine by the restockBalance provided
        drinksBalances[address(this)] += restockBalance;
    }

    /*
        Returns the amount of drinks in the vending machine
    */
    function getBalance() public view returns(uint){
        return drinksBalances[address(this)];
    }
}