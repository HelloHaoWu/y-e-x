// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

// ↓ 接口大全
import './pool/IYEXPoolState.sol'; // 定义了池子中变量状态
import './pool/IYEXPoolImmutables.sol'; // 包含factory()函数, 以及获取token合约地址, 和tick刻度线间距的方法函数
import './pool/IYEXPoolActions.sol'; // 没有权限限制的池子函数, 如mint, collect, burn, swap, flash等
import './pool/IYEXPoolOwnerActions.sol'; // 只有池子拥有者可以调用的函数, 如setFeeProtocol, collectProtocol等
import './pool/IYEXPoolEvents.sol'; // 包含mint, collect, burn, swap, flash等多个功能在内的事件
import './pool/IYEXPoolDerivedState.sol'; // 提供关于池子的统计性数据和快照

interface IYEXPool is
    IYEXPoolState,
    IYEXPoolImmutables,
    IYEXPoolActions,
    IYEXPoolOwnerActions,
    IYEXPoolEvents
{

}

