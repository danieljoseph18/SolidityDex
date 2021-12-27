import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet is Ownable {

using SafeMath for uint256;
    
    mapping(address => mapping(bytes32 => uint256)) public balances;

    struct Token{
        bytes32 ticker;
        address tokenAddress;
    }

    bytes32[] public tokenList;
    mapping(bytes32 => Token) public tokenMapping;

    function addToken(bytes32 _ticker, address _tokenAddress) external onlyOwner {
        tokenMapping[_ticker] = Token(_ticker, _tokenAddress);
        tokenList.push(_ticker);
    }

    function deposit(uint _amount, bytes32 _ticker) external tokenExists(_ticker) {
        balances[msg.sender][_ticker] = balances[msg.sender][_ticker].add(_amount);
        IERC20(tokenMapping[_ticker].tokenAddress).transferFrom(msg.sender, address(this), _amount);
        }

    function withdraw(uint _amount, bytes32 _ticker) external tokenExists(_ticker) {
        require(balances[msg.sender][_ticker] >= _amount);
        balances[msg.sender][_ticker] = balances[msg.sender][_ticker].sub(_amount);
        IERC20(tokenMapping[_ticker].tokenAddress).transfer(msg.sender, _amount);
    }

    modifier tokenExists(bytes32 _ticker) {
        require(tokenMapping[_ticker].tokenAddress != address(0));
        _;
    }
}
