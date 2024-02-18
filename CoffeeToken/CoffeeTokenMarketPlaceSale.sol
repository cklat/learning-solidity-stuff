// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/CoffeeToken.sol";

contract CoffeeTokenMarketPlaceSale  {

/*
* Simple contract representing a sale of the CoffeeToken on a Marketplace.
* - The owner of the CoffeeToken delegates spending allowance to the address of the marketplace.
* - The marketplace itself then offers a purchase option which allows the marketplace to transfer CoffeeTokens 
*   from the owner of the CoffeeTokens to the buyer's address.
*/
    uint tokenPrice = 1 ether;

    IERC20Metadata coffeeToken;
    address coffeeTokenOwner;

    constructor(address _token, address _tokenOwner) {
        coffeeToken = IERC20Metadata(_token);
        coffeeTokenOwner = _tokenOwner;
    }

    function purchaseToken() public payable  {
        require(msg.value >= tokenPrice, "Not enough money to purchase 1 unit.");
        uint amountOfTokensBought= msg.value / tokenPrice;
        uint changeToBeReturned = msg.value - (amountOfTokensBought*tokenPrice);

        coffeeToken.transferFrom(coffeeTokenOwner, msg.sender, amountOfTokensBought * 10 ** coffeeToken.decimals());
        payable(msg.sender).transfer(changeToBeReturned);
    }
}