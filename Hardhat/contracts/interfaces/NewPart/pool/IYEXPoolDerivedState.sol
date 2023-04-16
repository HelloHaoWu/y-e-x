// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

/// DerivedState → 派生的状态
/// @title 未存储的池状态
/// @notice 包含视图函数, 以提供有关计算而不是存储在区块链上的池的信息. 这里的函数可能有不同的燃气成本(gas costs).
interface IYEXPoolDerivedState {
    /// @notice 从当前块时间戳中返回每个时间戳'secondsAgo'的累计tick和流动性
    /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
    /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
    /// you must call it with secondsAgos = [3600, 0].
    /// @dev 时间加权平均刻度表示池的几何时间加权平均价格, 以token1 / token0的对数根号(1.0001)为单位. TickMath库可用于从刻度值转换为比率.
    /// @param secondsAgos 从多长时间以前, 每个累计刻度(tick)和应返回的流动性价值
    /// @return tickCumulatives 当前块时间戳中每个'secondsAgos'的累积刻度(tick)值
    /// @return secondsPerLiquidityCumulativeX128s 从当前块的每个'secondsAgos'开始，每个范围内流动性值的累积秒数
    /// timestamp
    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);

    /// @notice 返回刻度(tick)累积的快照(Snapshots)，每个流动性秒和滴答范围内的秒
    /// @dev 快照只能与在某个位置存在的时间段内拍摄的其他快照进行比较.
    /// I.e., 如果在第一个快照和第二个快照之间的整个时间内, 某个快照位置没有被占用, 则不允许进行快照比较.
    /// @param tickLower 范围的下刻度
    /// @param tickUpper 范围的上刻度
    /// @return tickCumulativeInside 范围的刻度累加器的快照
    /// @return secondsPerLiquidityInsideX128 范围内每个流动性的秒快照
    /// @return secondsInside 范围内每个流动性的秒快照
    function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
        external
        view
        returns (
            int56 tickCumulativeInside,
            uint160 secondsPerLiquidityInsideX128,
            uint32 secondsInside
        );
}
