// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

/// @title YEX工厂的接口
/// @notice  YEX工厂方便了YEX池的创建和协议费用的控制
interface IYEXFactory {
    /// @notice 当工厂合约的所有者发生变动时触发
    /// @param oldOwner 所有者变动前, 旧的工厂合约拥有者
    /// @param newOwner 所有者变动后, 新的工厂合约拥有者
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    /// @notice 创建新池时触发的事件
    /// @param token0 池子中第一个代币的地址
    /// @param token1 池子中第二个代币的地址
    /// @param fee 对池子中每次swap收取的费用
    /// @param tickSpacing 刻度线(tickSpacing)初始化的刻度之间的最小刻度数
    /// @param pool 创建的池子合约的地址
    event PoolCreated(
        address indexed token0,
        address indexed token1,
        uint24 indexed fee,
        int24 tickSpacing,
        address pool
    );

    /// @notice 启用新费用数额时触发的事件
    /// @param fee 新费用数额, 以 0.0001% 的比例表示
    /// @param tickSpacing 新费用下用于创建的池的初始化刻度(tick)数之间的最小距离
    event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);

    /// @notice 返回当前工厂所有者的地址
    /// @dev 能够通过setOwner被当前工厂合约的拥有者更改
    /// @return 工厂拥有者的地址
    function owner() external view returns (address);

    /// @notice 返回给定费用数额下的刻度(tick)间隔, 如果未启用则返回0.
    /// @dev 费用金额永远不能被删除，因此这个值应该硬编码或缓存在调用上下文中
    /// @param fee 启用费用, 以百分之一bip为单位. 如果未启用费用, 则返回0
    /// @return 刻度线(tickSpacing)
    function feeAmountTickSpacing(uint24 fee) external view returns (int24);

    /// @notice 返回给定代币和费用数额下的池地址, 如果池不存在则返回0.
    /// @dev tokenA和tokenB可以按照token0/token1或token1/token0的顺序传递
    /// @param tokenA token0或者token1的地址
    /// @param tokenB 另一种token的地址
    /// @param fee 对池中每一次掉期收取的费用
    /// @return pool 池子的地址
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);

    /// @notice 为给定的两个token和费用创建一个池子
    /// @param tokenA 池子中的一种token的合约地址
    /// @param tokenB 池子中的另一种token的合约地址
    /// @param fee 池子中的费用
    /// @dev tokenA和tokenB可以按任意顺序传递
    /// 从费用中检索tickSpacing. 如果池已经存在/费用无效或令牌参数无效, 则调用将恢复.
    /// @return pool 新创建的存储池地址
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);

    /// @notice 更新工厂合约的拥有者
    /// @dev 只能被现在工厂合约的拥有者调用
    /// @param _owner 工厂合约的新拥有者
    function setOwner(address _owner) external;

    /// @notice 启用指定的交易费用(fee)和价格刻度之间的距离(tickSpacing), 并将其应用于将来创建的所有池.
    /// @dev 费用金额一旦启用, 可能永远不会删除
    /// @param fee 启用的费用金额, 以百分之一bip(即1e-6)为单位。
    /// @param tickSpacing 对于所有使用给定费用金额创建的池强制执行的刻度(tick)之间的间隔
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
}
