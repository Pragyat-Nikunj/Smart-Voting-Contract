// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {MemberVote} from "src/MemberVote.sol";
import {DeployMemberVote} from "script/MemberVote.s.sol";
import {StartVote, ResetVotes, Vote} from "script/Interactions.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract InteractionsTest is Test {
    address public USER1 = makeAddr("user");
    address public USER2 = makeAddr("user2");
    address public USER3 = makeAddr("user3");
    uint256 public constant OPTION_A = 0;
    uint256 public constant OPTION_B = 1;
    uint256 public constant STARTING_ELECTION_ID = 1;
    uint256 public constant STARTING_OPTION_A_VOTES = 0;
    uint256 public constant STARTING_OPTION_B_VOTES = 0;
    uint256 public constant STARTING_PLAYER_BALANCE = 1 ether;
    MemberVote public memberVote;
    HelperConfig public helperConfig;

    function setUp() external {
        DeployMemberVote deployer = new DeployMemberVote();
        (memberVote, helperConfig) = deployer.run();
        vm.deal(USER1, STARTING_PLAYER_BALANCE);
        vm.deal(USER2, STARTING_PLAYER_BALANCE);
        vm.deal(USER3, STARTING_PLAYER_BALANCE);
    }

    function testStartVote() public {
        StartVote startVoteScript = new StartVote();
        startVoteScript.startVote(address(memberVote));
        assertEq(uint256(memberVote.getWorkflowStation()), 1);
    }

    function testResetVotes() public {
        StartVote startVoteScript = new StartVote();
        startVoteScript.startVote(address(memberVote));
        ResetVotes resetVotesScript = new ResetVotes();
        resetVotesScript.resetVote(address(memberVote));
        assertEq(uint256(memberVote.getWorkflowStation()), 2);
    }

    function testVote() public {
        StartVote startVoteScript = new StartVote();
        startVoteScript.startVote(address(memberVote));
        Vote voteScript = new Vote();
        (uint256 entryFee) = helperConfig.activeNetworkConfig();
        voteScript.vote{value: entryFee}(address(memberVote), OPTION_A, entryFee);
        assertEq(memberVote.getOptionAVotes(), STARTING_OPTION_A_VOTES + 1);
    }
}
