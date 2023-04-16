// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

interface IYEXPoolImmutables { // immutables → 不可变的
    /// @notice 用来部署池子合约的函数, 必须符合IYEXFactory合约的接口
    /// @return 部署后的池子合约的地址
    function factory() external view returns (address);

    /// @notice 获取该池中第一个代币的地址, 按地址排序
    /// @return 返回值是: 第一个代币合约的地址
    function token0() external view returns (address);

    /// @notice 获取该池中第二个代币的地址，按地址排序
    /// @return 返回值是: 第二个代币合约的地址
    function token1() external view returns (address);

    /// @notice 获取该池的交易手续费, 以百分之一万分之一(即 1e-6)为单位
    /// @return 返回值是: 该池的交易手续费
    function fee() external view returns (uint24);

    /// @notice 获取该池中刻度线(tick)的间距.
    /// @dev 池标记的刻度只能用于此值(即tickSpacing)的倍数, 最小值为1, 且始终为正.
    /// 例如, 当tickSpacing为3, 表示刻度线可以为..., -6, -3, 0, 3, 6, ...
    /// 该值为int24, 以避免强制转换, 即使它总是正的。
    /// @return 返回值是: 该池子的刻度线
    function tickSpacing() external view returns (int24);

    /// @notice 获取每个刻度线范围内可用的最大头寸流动性.
    /// @dev 这个参数在每个刻度线处(tick)强制执行一次, 以防止流动性在任何时候溢出uint128, 也防止使用范围外的流动性来防止向池中添加范围内的流动性
    /// @return 每个刻度线处的最大流动金额
    function maxLiquidityPerTick() external view returns (uint128);
}
