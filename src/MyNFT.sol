// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant PRICE = 0.01 ether;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/QmPlaceholder/";
    }

    function mint(address to) public onlyOwner {
        require(nextTokenId < MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(to, tokenId);
    }

    function publicMint() public payable {
        require(msg.value == PRICE, "Wrong price");
        require(nextTokenId < MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        (bool ok,) = payable(owner()).call{value: address(this).balance}("");
        require(ok, "Withdraw failed");
    }
}