// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
This is a smart contract that allows a buyer to purchase an item from a seller

Architecture:
- The seller deploys the contract and sets the value for the item for sale
- The seller sends funds to the contract. The transaction goes into a locked state, freezing the fund.
- The buyer enters into agreement to buy the commodity and sends the required funds to the smart contract
- The seller ships the item to the buyer
- The buyer sends the confirmation receipt to the item to the smart contract; upon recieving which the smart contract 
releases the funds which is recieved by the seller

Loophole in the above startegy:
1. We are relying on the honesty of the buyer to send the received receipt (or invoke the received function) but
what if the buyer never invokes the received function, even after receiving the item. If this happens then the seller
will never recieve his deposited funds back.

2. There is no way of verifying if the item was shipped physically, the buyer can invoke the received function and the 
seller will recieve his locked funds even without selling the item.

Solution:
Both the sender and buyer send 2x the funds required for the transaction to the smart contract.

- In this way if the buyer does not invokes the received function even after recieving the item the he will not
 recieve his 1/2x amount back.

- For the seller the cost stuck in the transaction is = 
cost of the item + selling price = 2x funds
which he wants to recover so he has to ship the item to the buyer

In this way we can create an incentive for both the parties to be fair in the transaction.
*/

contract SafeRemotePurchase{
    // state variables
    uint public value;
    address payable public buyer;
    address payable public seller;

    enum State {CREATED, LOCKED, RELEASED, INACTIVE}
    // state of the transaction 
    State public state;

    constructor() payable {
        // the seller deploys the contract
        seller = payable (msg.sender);
        // amount send by the seller will be twice of the price of the item
        value = msg.value / 2;
    }

    /// The function cannot be called at current state
    error InvalidState();
    /// Only the buyer can call this function
    error OnlyBuyer();
    /// Only the seller can call this function
    error OnlySeller();

    modifier inState(State _state){
        if(state != _state){
            revert InvalidState();
        }
        _;
    }

    modifier onlyBuyer(){
        if(msg.sender!=buyer){
            revert OnlyBuyer();
        }
        _;
    }

    modifier onlySeller(){
        if(msg.sender != seller){
            revert OnlySeller();
        }
        _;
    }

    // invoked by the buyer 
    function confirmPurchase() external payable inState(State.CREATED) {
        require(msg.value == 2 * value,"Not enough funds sent, please send in 2x purchase amount");
        buyer = payable (msg.sender);
        state = State.LOCKED;
    }

    // invoked by the buyer after the item has been recieved to release the funds
    function confirmReceived() external inState(State.LOCKED) onlyBuyer{
        state = State.RELEASED;
        buyer.transfer(value);
    }

    // invoked by the seller after the item 
    function paySeller() external inState(State.RELEASED) onlySeller{
        state = State.INACTIVE;
        seller.transfer(value * 3);
    }

    /* 
    * used to cancel the transaction
    * can be invoked only before the seller sends in funds 
    */
    function abort() external inState(State.CREATED) onlySeller{
        state = State.INACTIVE;
        seller.transfer(address(this).balance);
    }
}