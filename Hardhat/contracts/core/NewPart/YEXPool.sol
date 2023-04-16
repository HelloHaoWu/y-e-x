// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

import './YEXNoDelegateCall.sol';
import '../../interfaces/NewPart/IYEXPool.sol';
import '../../interfaces/NewPart/IYEXPoolDeployer.sol';
import '../../interfaces/NewPart/IYEXFactory.sol';

import '../../library/Tick.sol';
import '../../library/LowGasSafeMath.sol';
import '../../library/SafeCast.sol';
import '../../library/TickBitmap.sol';
import '../../library/Position.sol';
import '../../library/Oracle.sol';

import '../../library/FullMath.sol';
import '../../library/FixedPoint128.sol';
import '../../library/TransferHelper.sol';
import '../../library/TickMath.sol';
import '../../library/LiquidityMath.sol';
import '../../library/SqrtPriceMath.sol';
import '../../library/SwapMath.sol';


contract YEXPool is IYEXPool, NoDelegateCall{
    
    /// @inheritdoc IYEXPoolImmutables
    address public immutable override factory;
    /// @inheritdoc IYEXPoolImmutables
    address public immutable override token0;
    /// @inheritdoc IYEXPoolImmutables
    address public immutable override token1;
    /// @inheritdoc IYEXPoolImmutables
    uint24 public immutable override fee;

    /// @inheritdoc IYEXPoolImmutables
    int24 public immutable override tickSpacing;

    /// @inheritdoc IYEXPoolImmutables
    uint128 public immutable override maxLiquidityPerTick;

    // ↓ 用于标定IYEXPoolState中的"当前流动池状态"结构
    struct Slot0 {
        // 当前价格(the current price)
        uint160 sqrtPriceX96; // 当前价格的平方根乘以 2^96，以固定点表示，用于计算任意两种资产之间的价格；
        // 当前刻度值(the current tick)
        int24 tick; // 当前刻度值，用于指示当前价格处于哪个价格区间；
        // the most-recently updated index of the observations array
        uint16 observationIndex; // 最近更新的观察值数组的索引；
        // the current maximum number of observations that are being stored
        uint16 observationCardinality; // 当前观察值数组的最大存储量；
        // the next maximum number of observations to store, triggered in observations.write
        uint16 observationCardinalityNext; // 观察值数组的下一个最大存储量；
        // the current protocol fee as a percentage of the swap fee taken on withdrawal
        // represented as an integer denominator (1/x)%
        uint8 feeProtocol; // 协议费用，即在赎回时从交易费用中抽取的一部分比例；
        // whether the pool is locked
        bool unlocked; // 布尔值，表示池是否被锁定。
    }
    // @inheritdoc IYEXPoolState
    Slot0 public override slot0;

    // @inheritdoc IYEXPoolState
    uint256 public override feeGrowthGlobal0X128;
    // @inheritdoc IYEXPoolState
    uint256 public override feeGrowthGlobal1X128;

    // ↓ 以token0/token1单位计算的累计协议费用
    struct ProtocolFees {
        uint128 token0;
        uint128 token1;
    }
    // @inheritdoc IYEXPoolState
    ProtocolFees public override protocolFees;

    // @inheritdoc IYEXPoolState
    uint128 public override liquidity;

    /// @inheritdoc IYEXPoolState
    mapping(int24 => Tick.Info) public override ticks; // override指示该函数是覆盖父合约或接口中的同名函数
    /// @inheritdoc IYEXPoolState
    mapping(int16 => uint256) public override tickBitmap;
    /// @inheritdoc IYEXPoolState
    mapping(bytes32 => Position.Info) public override positions;
    /// @inheritdoc IYEXPoolState
    Oracle.Observation[65535] public override observations;

    // ↓ 修饰器, 用来给池子上锁
    modifier lock() {
        require(slot0.unlocked, 'LOK');
        slot0.unlocked = false;
        _;
        slot0.unlocked = true;
    }

    // ↓ 修饰器, 用来仅允许工厂合约的拥有者调用函数
    modifier onlyFactoryOwner() {
        require(msg.sender == IYEXFactory(factory).owner());
        _;
    }

    // ↓ 初始化IYEXPoolDeployer中的参数
    constructor(){
        int24 _tickSpacing;
        (factory, token0, token1, fee, _tickSpacing) = IYEXPoolDeployer(msg.sender).parameters();
        tickSpacing = _tickSpacing;

        maxLiquidityPerTick = Tick.tickSpacingToMaxLiquidityPerTick(_tickSpacing);
    }
}
