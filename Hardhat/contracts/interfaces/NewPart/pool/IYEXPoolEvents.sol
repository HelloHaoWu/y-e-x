// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

/// @title 由池发出的事件(Events)们
/// @notice 包含池发出的所有事件
interface IYEXPoolEvents {
    /// @notice 当第一次在池上调用#initialize时, 池子精准地触发一次
    /// @dev Mint/Burn/Swap 事件, 在Initialize事件前, 不能由池子触发
    /// @param sqrtPriceX96 池子的初始根号价格(sqrt price), as a Q64.96
    /// @param tick 池的初始刻度, 即以池的起始价格1.0001为基数的对数
    event Initialize(uint160 sqrtPriceX96, int24 tick);

    /// @notice 当由某一特定头寸(position)注入(mint)流动性时触发
    /// @param sender 注入流动性的地址
    /// @param owner 头寸(position)的所有者和任何铸造(mint)流动性的接收者
    /// @param tickLower 头寸(position)的下刻度
    /// @param tickUpper 头寸(position)的上刻度
    /// @param amount 在头寸范围(position range)内铸造的流动性总量
    /// @param amount0 铸造的流动性需要多少token0
    /// @param amount1 铸造的流动性需要多少token1
    event Mint(
        address sender,
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice 当持仓方收取费用时触发
    /// @dev 当调用者选择不收取费用时, 可能会以零amount0和amount1触发Collect事件
    /// @param owner 被收取费用的头寸(position)的所有者
    /// @param tickLower 头寸(position)的下刻度
    /// @param tickUpper 头寸(position)的上刻度
    /// @param amount0 所收取的token0费用的金额
    /// @param amount1 所收取的token1费用的金额
    event Collect(
        address indexed owner,
        address recipient,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount0,
        uint128 amount1
    );

    /// @notice 当一个头寸(position)的流动性被移除时触发
    /// @dev 该部分没有提取流动性头寸所赚取的任何费用, 必须通过#collect提取
    /// @param owner 流动性被移除的持仓者(The owner of position)
    /// @param tickLower 头寸(position)的下刻度
    /// @param tickUpper 头寸(position)的上刻度
    /// @param amount 要移除的流动性的量
    /// @param amount0 移除的token0的数量
    /// @param amount1 移除的token1的数量
    event Burn(
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice 对于token0和token1之间的任何交换, 该事件由池发出
    /// @param sender 发起交换调用和接收回调的地址
    /// @param recipient 接收交换输出的地址
    /// @param amount0 池中token0余额的增量(delta)(不一定是增加的)
    /// @param amount1 池中token1余额的增量(delta)(不一定是增加的)
    /// @param sqrtPriceX96 交换(swap)后池的平方根(价格), 作为Q64.96
    /// @param liquidity swap后资金池的流动性
    /// @param tick 交换后池价格的以1.0001为基数的日志(?)
    event Swap(
        address indexed sender,
        address indexed recipient,
        int256 amount0,
        int256 amount1,
        uint160 sqrtPriceX96,
        uint128 liquidity,
        int24 tick
    );

    /// @notice 由池为token0/token1的任何"闪电贷"而发出
    /// @param sender 发起交换(swap)调用和接收回调的地址
    /// @param recipient 从flash接收token的地址
    /// @param amount0 闪电贷的token0的数量
    /// @param amount1 闪电贷的token1的数量
    /// @param paid0 token0为flash支付的金额, 可以超过该金额加上费用(which can exceed the amount0 plus the fee)
    /// @param paid1 token1为flash支付的金额, 可以超过该金额加上费用(which can exceed the amount1 plus the fee)
    event Flash(
        address indexed sender,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1,
        uint256 paid0,
        uint256 paid1
    );

    /// @notice 由池发出，以增加可存储的观测数据的数量
    /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
    /// just before a mint/swap/burn.
    /// @param observationCardinalityNextOld 下一个观测基数的前一个值
    /// @param observationCardinalityNextNew 下一个观测基数的更新值
    event IncreaseObservationCardinalityNext(
        uint16 observationCardinalityNextOld,
        uint16 observationCardinalityNextNew
    );

    /// @notice 当池更改协议费用时发出
    /// @param feeProtocol0Old 之前的token0的协议费用
    /// @param feeProtocol1Old 之前的token1的协议费用
    /// @param feeProtocol0New 更新后的token0的协议费用
    /// @param feeProtocol1New 更新后的token1的协议费用
    event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);

    /// @notice 当工厂所有者收回所收取的协议费用时发出
    /// @param sender 收取协议费的地址(把协议费发给接收地址)
    /// @param recipient 接收所收协议费的地址
    /// @param amount0 提取的token0作为协议费用的数量
    /// @param amount0 提取的token1作为协议费用的数量
    event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
}
