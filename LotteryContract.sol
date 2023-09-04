// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
    This is a lottery contract which chooses a winner and transfers the wnning amount to the winners wallet

    Members:
    1. Owner -> The person who deployed the contract and can perforn admin functions
    2. Players -> The people who play the lottery

    Required Funtions:
    1. Enter lottey -> Adds a new player to the lottery, each player must provide some min amount to enter the lottery
    2. Pick winner -> Choose the winner of the lottery from the players
    3. Get random number -> Generates a random number

    Optional functions:
    1. Get pot balance -> Get the amount in the lottery
    2. Get players -> Get the address of players

*/

contract LotteryContract{
    address public owner;
    // array of players
    address payable [] players;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOnwer() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // adds the current address interacting with the function as a new player
    function enterLottery() payable public {
        require(msg.value > .01 ether, "Entry fee not enough, min should be .01 ether");
        // casting and adding a player to the 'players' array
        players.push(payable(msg.sender));
    }

    function pickWinner() public onlyOnwer {
        // generate an index between 0 and length of the players array - 1
        uint index = generateRandomNumber() % players.length;
        // pay to the winner
        players[index].transfer(address(this).balance);
        // reset the state of the contract
        players = new address payable [](0);
    }

    // generating a pseudo random number using the onwer address and the current block timestamp
    function generateRandomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }
    
    function getPotBalance() public view returns(uint){
        return address(this).balance;
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
}