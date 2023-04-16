// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

/// @title 有权限的池子操作
/// @notice 包含只能由工厂所有者调用的对池子合约使用的方法
interface IYEXPoolOwnerActions {
    /// @notice 设置协议费用份额的分母
    /// @param feeProtocol0 池子中token0的新的协议费用
    /// @param feeProtocol1 池子中token1的新的协议费用
    function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;

    /// @notice 收取池子中应计的协议费
    /// @param recipient 协议费发送到的地址
    /// @param amount0Requested token0发送的最大金额, 此时不收取token1作为费用(can be 0 to collect fees in only token1)
    /// @param amount1Requested token1发送的最大金额, 此时不收取token0作为费用(can be 0 to collect fees in only token0)
    /// @return amount0 以token0作为的协议费用
    /// @return amount1 以token1作为的协议费用
    function collectProtocol(
        address recipient,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);
}