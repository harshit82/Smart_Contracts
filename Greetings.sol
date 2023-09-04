// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

 // This is a contract for greeting a new member on the blockchain
contract Greeting{
    /*
        The state variables automatically get a getter function with the same name as the variable. 
        This all happens behind the scene.
    */
    // state varibles
    string public name;
    string public greetingPrefix = "Hello ";

    /*
    We use the 'memory' keyword to signify that we are going to store this string type data 'name' in the temporary memory 
    till the function is being called

    There are 3 memory spaces in solidity:
    - storage: permanent memory => we use it to store the data that is to be permanently stored on the blockchain.
    - memory: temporary memory => we use it to store the data this is used between function calls.
    - calldata: special location that contains the functions arguments. It can used only with the keyword 'external'.
    */

    constructor(string memory initialName){
        name = initialName;
    }

    function setName(string memory newName) public {
        name = newName;
    }

    function getName() public view returns(string memory){
        /* 
        We use the helper function abi.encodePacked(arg) to concatenate the two strings
        and finally caste to string
        */
        return string(abi.encodePacked(greetingPrefix,name));
    }
}