// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

// ↓ 这段代码定义了一个 Solidity 接口 IYEXPoolDeployer, 用于获取YEX创建的池子的各种参数.
interface IYEXPoolDeployer {
    // ↓↓ 一个名为"parameters"的方法, 该方法用于获取YEX池子创建参数.
    // ↓ 该方法没有修改合约状态, 因此使用了view关键字来标记它为只读方法.
    function parameters()
    external // 指只可被外部调用
    view
    returns (
        address factory, // 工厂创建的池子的合约地址
        address token0, // 池子中第一个代币的地址
        address token1, // 池子中第二个代币的地址
        uint24 fee, // 池子中每次交易收取的费用
        int24 tickSpacing // 池子中两个基础刻度(tick)线值的间距
    );
}