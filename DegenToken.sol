// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable,ERC20Burnable  {

    struct ItemList {
        uint itemId;
        string name;
        uint price;
        string iteminfo;
    }

    ItemList[] private _storeItemLists;

    constructor() ERC20("Degen", "DGN") {
        _storeItemLists.push(ItemList(1,"platinum", 400,"premium"));
        _storeItemLists.push(ItemList(2,"gold", 200,"important"));
        _storeItemLists.push(ItemList(3,"silver", 100,"conductive"));
    }

    function mint(address to, uint256 amount) private onlyOwner {
        _mint(to, amount);
    }

      function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferTokens(address receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient Balance in your account");
        approve(msg.sender, amount);
        transferFrom(msg.sender, receiver, amount);
    }

    function redeemItems(uint256 ItemListNumber) external payable returns (string memory) {
        require(ItemListNumber > 0 && ItemListNumber <= _storeItemLists.length, "choice not avilable for you");
        ItemList memory itemList = _storeItemLists[ItemListNumber-1];
        require(this.balanceOf(msg.sender) >= itemList.price, "Insufficient Balance in your account");
        approve(msg.sender, itemList.price);
        transferFrom(msg.sender, owner(), itemList.price);
        return string.concat("Successfully redeemed tokens for ", itemList.name);
    }

    function checkBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }
  
  function getItemDetails(uint256 Item) external view  returns (string memory, uint256) {
        return (_storeItemLists[Item].name, _storeItemLists[Item].price );
    }

    function showStoreItemLists() external view returns (string memory) {
        string memory response = "Available ItemLists are shown as:";

        for (uint i = 0; i < _storeItemLists.length; i++) {
            response = string.concat(response, "\n", Strings.toString(i+1), ". ", _storeItemLists[i].name );
            }
 
        return response;
    }
}
