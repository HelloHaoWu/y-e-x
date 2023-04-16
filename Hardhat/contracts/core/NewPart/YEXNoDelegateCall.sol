// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

// 该部分代码定义了一个抽象合约
abstract contract NoDelegateCall {
    // ↓ "immutable"指不可变变量
    address private immutable original;

    // ↓ 在创建该合约时, 记录合约地址为初始地址
    constructor() {
        original = address(this);
    }

    // ↓ 检测当前合约地址是否等于合约创建时的地址(即初始地址original)
    function checkNotDelegateCall() private view {
        require(address(this) == original);
    }

    // ↓ 提供了一个修饰符, 用于防止委托调用到子合约中的方法
    modifier noDelegateCall() {
        checkNotDelegateCall();
        _;
    }
}
