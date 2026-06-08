// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// змінну стану для зберігання числа
// increment() — збільшує на 1
// decrement() — зменшує на 1
// reset() — скидає в 0

contract Counter {
    uint public counter;

    function increment () external {
        counter += 1;
    }

    function decrement() external {
        require(counter > 0, "Counter: already zero");
        counter -= 1;
    }

    function reset() external {
        counter = 0;
    }


}