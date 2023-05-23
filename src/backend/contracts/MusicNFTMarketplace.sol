// SPDX-License_Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFTMarketplace is ERC721("DAppFi", "DAPP"), Ownable {
    string public baseURI =
        "https://bafybeihrjqzxthdmjvwfczoksdu54bjzm5ym2qbucrgzsevbexbzadwhye.ipfs.nftstorage.link/";

    string public baseExtension = ".json";
    address public artist;
    uint256 public royaltyFee;

    struct MarketItem {
        uint256 tokenID;
        address payable seller;
        uint256 price;
    }

    MarketItem[] public marketItems;

    constructor(
        uint256 _royaltyFee,
        address _artist,
        uint256[] memory _prices
    ) payable {
        require(
            _prices.length * _royaltyFee == msg.value,
            "Developer must pay Royalty fee for each token listed on the marketplace"
        );

        royaltyFee = _royaltyFee;
        artist = _artist;
        for (uint8 i = 1; i < _prices.length; i++) {
            require(_prices[i] > 0, "Price Must be greater than 0");
            _mint(address(this), i);
            marketItems.push(MarketItem(i, payable(msg.sender), _prices[i]));
        }
    }
}
