// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MemberVote} from "../src/MemberVote.sol";

contract DeployMemberVote is Script {
    function run() external returns (MemberVote) {
        vm.startBroadcast();
        MemberVote memberVote = new MemberVote();
        vm.stopBroadcast();
        return memberVote;
    }
}