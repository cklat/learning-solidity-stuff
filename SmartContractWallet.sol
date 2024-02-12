// SPDX-License-Identifier: MIT
pragma solidity "0.8.15";


contract SmartContractWallet {
    /* This Smart Contract wallet provides the following features:
    * 1. Wallet has 1 Owner
    * 2. Receive funds with a fallback function
    * 3. Spend wallet funds on EOA and Contracts
    * 4. The owner can give allowance to certain other people to spend certain amount of funds their deposited funds
    * 5. Owner can set up to 5  addresses as guardians
    * 6. Wallet owner can be changed with a majority vote (i.e. 3 out of 5 guardians vote for same address) 
    */

    error MaxNumberOfGuardiansReached();
    uint multiplier = 10;
    address public walletOwner;
    struct Allowance {
        uint depositedFunds;
        uint allowanceAmount;
        bool isAllowedToSpend;
    }

    mapping(address => Allowance) public allowances;

    uint8 public numOfGuardians;
    uint8 maxNumberOfGuardians = 5;

    uint8 public numOfVotes;
    mapping(address => bool) public guardians;
    mapping(address => bool) guardianVotes;
    mapping(address => uint) votesPerNewWalletOwnerAddress;


    constructor() {
        walletOwner = msg.sender;
    }

    function setGuardian(address _address) public {
        require(walletOwner == msg.sender, "You are not the owner.");
        if(numOfGuardians >= maxNumberOfGuardians) 
            revert MaxNumberOfGuardiansReached();
        
        guardians[_address] = true;
        numOfGuardians++;
    }

    function voteNewWalletOwner(address _newOwnerAddress) public {
        require(guardians[msg.sender] == true, "You are not allowed to vote.");
        require(guardianVotes[msg.sender] == false, "You have already voted.");
        votesPerNewWalletOwnerAddress[_newOwnerAddress]++;
        numOfVotes++;
        guardianVotes[msg.sender] = true;
        if((votesPerNewWalletOwnerAddress[_newOwnerAddress] * multiplier) > getMinVotesForMajorityThreshold()) {
            setNewWalletOwner(_newOwnerAddress);
        }
    }

    function setNewWalletOwner(address _newOwner) private {
        walletOwner = _newOwner;
    }

    function getMinVotesForMajorityThreshold() public view returns(uint) {
        return (numOfGuardians * multiplier) / 2;
    }

    function setAllowanceAmount(address _address, uint _allowanceAmount) public {
        require(walletOwner == msg.sender);
        allowances[_address].allowanceAmount = _allowanceAmount;
    } 

    function setSpendingAllowance(address _address, bool _isAllowedToSpend) public {
        require(walletOwner == msg.sender);
        allowances[_address].isAllowedToSpend = _isAllowedToSpend;
    }

    function spendWalletFunds(address payable _to, string memory _payload) public payable returns(bytes memory){
        require(walletOwner == msg.sender, "Only the wallet owner can spend global wallet funds.");
        require(msg.value <= address(this).balance, "You are trying to send more funds than the wallet's balance. Reverting.");
        bytes memory payload = abi.encodeWithSignature(_payload);
        (bool success, bytes memory returnData) = _to.call{value: msg.value}(payload);
        require(success, "Transfer of funds not successful, reverting.");
        return returnData;
    }

    function depositFunds() public payable  {
        allowances[msg.sender].depositedFunds += msg.value;
    }

    function spendAllowanceFunds(address payable _to) payable public {
        require(allowances[msg.sender].isAllowedToSpend == true, "You are not allowed to spend funds.");
        require(allowances[msg.sender].allowanceAmount <= allowances[msg.sender].depositedFunds, "You don't have enough funds that you are allowed to spend. Reverting.");
        _to.transfer(msg.value);
        allowances[msg.sender].depositedFunds -= msg.value;
    }

    receive() external payable {}

}
