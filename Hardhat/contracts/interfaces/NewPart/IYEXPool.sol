// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// Contributor @HelloHaoWu

import './pool/IYEXPoolState.sol';
import './pool/IYEXPoolImmutables.sol';
import './pool/IYEXPoolActions.sol';

interface IYEXPool is
    IYEXPoolState,
    IYEXPoolImmutables,
    IYEXPoolActions
{

}

