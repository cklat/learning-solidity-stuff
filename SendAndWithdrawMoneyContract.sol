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