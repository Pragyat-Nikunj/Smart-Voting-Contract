// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MemberVote} from "src/MemberVote.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract StartVote is Script {
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MemberVote", block.chainid);
        startVote(mostRecentDeployed);
    }

    function startVote(address _contractAddress) public {
        vm.startBroadcast();
        MemberVote(_contractAddress).startVote();
        vm.stopBroadcast();
    }
}

contract ResetVotes is Script {
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MemberVote", block.chainid);
        resetVote(mostRecentDeployed);
    }

    function resetVote(address _contractAddress) public {
        vm.startBroadcast();
        MemberVote(_contractAddress).resetVotes();
        vm.stopBroadcast();
    }
}

contract Vote is Script {
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MemberVote", block.chainid);
        HelperConfig helperConfig = new HelperConfig();
        (uint256 entryFee) = helperConfig.activeNetworkConfig();
        uint256 option = vm.envOr("VOTE_OPTION", uint256(0));
        vote(mostRecentDeployed, option, entryFee);
    }

    function vote(address _contractAddress, uint256 _option, uint256 _value) public payable {
        vm.startBroadcast();
        MemberVote(_contractAddress).vote{value: _value}(_option);
        vm.stopBroadcast();
    }
}
