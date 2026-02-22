// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MemberVote} from "../src/MemberVote.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployMemberVote is Script {
    function run() external returns (MemberVote, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (uint256 entryFee) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        MemberVote memberVote = new MemberVote(entryFee);
        vm.stopBroadcast();
        return (memberVote, helperConfig);
    }
}
