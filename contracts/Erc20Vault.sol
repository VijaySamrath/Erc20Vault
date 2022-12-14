// SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Erc20Vault is Ownable{
    using SafeERC20 for IERC20;

    struct  Diary{
      IERC20 Token;
      uint256 amount;
    }


    mapping (address => Diary) public _tokeninVault;

    event Withdraw(address withdrawer, uint256 amount);

    function depositErc20(IERC20 _Token, uint256 _amount)public onlyOwner{
        require(address(_Token) != address(0), "Token address is 0");
        require(_amount > 0, "amount of token to be deposited should be > 0");
        require(_Token.allowance(msg.sender, address(this)) >= _amount, "Approval not given by the token contract");

        _Token.safeTransferFrom(msg.sender, address(this), _amount);
        _tokeninVault[address(_Token)].Token = _Token;

        _tokeninVault[address(_Token)].amount += _amount;
}
    
    function withdraw(IERC20 _Token, address _TokenOwner, uint256 _amount)public onlyOwner{ 

    require(address(_Token) != address(0), "Token address is 0");
    require(address(_TokenOwner) != address(0), "_TokenOwner address is 0");

    require(_tokeninVault[address(_Token)].amount > 0, "No amount to withdraw");
    _tokeninVault[address(_Token)].amount -= _amount;

    _tokeninVault[address(_Token)].Token.safeTransfer(_TokenOwner,  _tokeninVault[address(_Token)].amount);
    emit Withdraw(address(_TokenOwner), _tokeninVault[address(_Token)].amount);

    }

   
   
}
    

