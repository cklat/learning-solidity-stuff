// Smart contract that 
// 1. accepts deposits from any address
// 2. withdraws all of the contract's balance to the caller's address
// 3. withdraws all of the contract's balance to a given address
// view function to return the contract's address' balance


// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SendAndWithdrawMoney {

    uint public balanceDeposited;

    function deposit() public payable {
        balanceDeposited += msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function withdrawAll() public {
        address payable toAddress = payable(msg.sender);
        toAddress.transfer(getContractBalance());
    }

    function withdrawAllToAddress(address payable _toAddress) public {
        _toAddress.transfer(getContractBalance());
    }
}