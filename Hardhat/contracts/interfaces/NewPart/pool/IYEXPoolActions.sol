// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

/// @title 无需权限的池操作
/// @notice 包含能被任何人调用的池子的方法
interface IYEXPoolActions {
    /// @notice 设置池子的初始价格
    /// @dev Price被定义为√(amountToken1/amountToken0) 的 Q64.96值
    /// @param sqrtPriceX96 池子的初始根号价格为Q64.96
    function initialize(uint160 sqrtPriceX96) external;

    /// @notice 为给定的recipient/tickLower/tickUpper头寸(position)增加流动性
    /// @dev 该方法的调用者接收一个形式为IUniswapV3MintCallback#的回调, 其中, 他们必须支付流动性所欠的任何token0或token1.
    /// token0/token1的到期金额取决于tickLower, tickUpper, 流动性金额和当前价格.
    /// @param recipient 将为池子创建流动性的用户/合约地址
    /// @param tickLower 增加流动性的位置的低刻度
    /// @param tickUpper 增加流动性的位置的高刻度
    /// @param amount 铸造的流动性的数量
    /// @param data 应该传递给回调的任何数据
    /// @return amount0 为制造给定数量的流动性而支付的token0的数量. 匹配回调中的值
    /// @return amount1 为制造给定数量的流动性而支付的token1的数量. 匹配回调中的值
    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice 把欠的代币"收集"到一个位置
    /// @dev 不重新计算赚取的费用, 重新计算赚取的费用必须通过mint或burn任何数量的流动性实现.
    /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
    /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
    /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
    /// @param recipient 收取费用的地址
    /// @param tickLower 要收取费用的位置的下刻度
    /// @param tickUpper 要收取费用的位置的上刻度
    /// @param amount0Requested 应从所欠费用中提取多少token0
    /// @param amount1Requested 应从所欠费用中提取多少token1
    /// @return amount0 在token0中收取的费用金额
    /// @return amount1 在token1中收取的费用金额
    function collect(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);

    /// @notice 从发送方和账户token中burn流动性
    /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
    /// @dev 费用必须通过调用#collect单独收取
    /// @param tickLower 需要burn流动性的头寸的下刻度
    /// @param tickUpper 需要burn流动资金的头寸的上课度(上限)
    /// @param amount 需要burn多少流动性
    /// @return amount0 发送给接收者的token0的数量
    /// @return amount1 发送给接收者的token1的数量
    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice 将token0替换(swap)为token1，或将token1替换(swap)为token0
    /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
    /// @param recipient 接收交换输出的地址
    /// @param zeroForOne 交换的方向: token0到token1为真, token1到token0为假
    /// @param amountSpecified 交换量, 它隐式地将交换配置为精确输入(正)或精确输出(负)
    /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
    /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
    /// @param data 要传递给回调的任何数据
    /// @return amount0 池中token0的余额的delta, exact when negative, minimum when positive
    /// @return amount1 池中token1的余额的delta, exact when negative, minimum when positive
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);

    /// @notice 接收token0和/或token1, 并在回调中偿还它, 外加一笔费用(即闪电贷)
    /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
    /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
    /// with 0 amount{0,1} and sending the donation amount(s) from the callback
    /// @param recipient 接收token0和token1的地址
    /// @param amount0 要发送的token0的数量
    /// @param amount1 要发送的token1的数量
    /// @param data 要传递给回调的任何数据
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;

    /// @notice 增加此池将存储的价格和流动性观察的最大数量
    /// @dev 如果池中已经有一个大于或等于输入observationCardinalityNext的observationCardinalityNext，则此方法是无操作的。
    /// @param observationCardinalityNext 池要存储的所需的最小观测数
    function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
}
