// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

interface IYEXPoolState {
    // ↓ 一个函数, 包含一系列参数, 用来描述当前流动池状态
    function slot0()
    external
    view
    returns (
        uint160 sqrtPriceX96,
        int24 tick,
        uint16 observationIndex,
        uint16 observationCardinality,
        uint16 observationCardinalityNext,
        uint8 feeProtocol,
        bool unlocked
    );

    // ↓↓↓ 一个函数, 用于获取池子中代币0的全局费用增长
    // ↓↓ 这些值是使用 Q128.128 格式表示的, 这意味着它们使用了固定小数位数来表示小数部分, 以避免精度损失.
    // ↓ 这些值可能会溢出 uint256.
    function feeGrowthGlobal0X128() external view returns (uint256);

    // ↓↓↓ 一个函数, 用于获取池子中代币1的全局费用增长
    // ↓↓ 这些值是使用 Q128.128 格式表示的, 这意味着它们使用了固定小数位数来表示小数部分, 以避免精度损失.
    // ↓ 这些值可能会溢出 uint256.
    function feeGrowthGlobal1X128() external view returns (uint256);

    // ↓↓ 一个函数, 用于获取协议从池子中收集的代币0和代币1的数量.
    // ↓ 这些数量不会超过 uint128 的最大值.
    function protocolFees() external view returns (uint128 token0, uint128 token1);

    // ↓↓ 一个函数用于获取池中可用的流动性.
    // ↓ 这个值与所有刻度线上的总流动性没有任何关系(这句话如何理解?)
    function liquidity() external view returns (uint128);

}
