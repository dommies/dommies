// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dommies is ERC721Enumerable, Ownable {
    uint public constant MAX_TOKENS = 10000;
    uint public constant TOKEN_PRICE = 69 * 10 ** 15; // 0.069 ETH
    uint public constant MAX_DOMMIES_PURCHASE = 69;
    bool public isSalesActive = false;
	string _baseTokenURI;
    string _contractURI;	

    //LFG
    constructor(string memory baseURI) ERC721("Dommies", "DOMMIES")  {
        setBaseURI(baseURI);
    }

    function mintMyNFT(address _to, uint _count) public payable {
        require(isSalesActive, "Dommies Sale has not started!");
        require(totalSupply() + _count <= MAX_TOKENS, "Sorry you tried to mint too many Dommies!");
        require(totalSupply() < MAX_TOKENS, "No more Dommies left!");
        require(_count <= MAX_DOMMIES_PURCHASE, "Leave some Dommies for others!");
        require(msg.value >= (TOKEN_PRICE * _count), "Need more ETH to unwrap the Dommies!");

        uint mintTime = block.timestamp;
        for(uint i = 0; i < _count; i++){
            uint mintIndex = totalSupply();
            _safeMint(_to, mintIndex);
            emit TokenMinted(msg.sender, mintIndex, mintTime);
        }
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    // Events
    event TokenMinted(address owner, uint tokenId, uint mintTime);

    // onlyOwner Functions //
    function setSaleState(bool newState) public onlyOwner {
        isSalesActive = newState;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function setContractURI(string memory newContractURI) public onlyOwner {
        _contractURI = newContractURI;
    }
    
    function withdrawAll() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
