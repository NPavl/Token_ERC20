// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract Donate {
    
    string public str;
    function changeStr(string memory _str) public {
        str = _str;
    }
    
function showBalance () 

address public donator;
uint public donation;

function sendMoneyNigga() external payable {
    donator = msg.sender;
    donation = msg.value;
}

}
