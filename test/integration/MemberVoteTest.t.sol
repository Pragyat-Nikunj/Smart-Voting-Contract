// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MemberVote} from "src/MemberVote.sol";
import {DeployMemberVote} from "script/MemberVote.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract MemberVoteTest is Test {
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

    function testIfOptionsAreResetAfterElection() external {
        (uint256 entryFee) = helperConfig.activeNetworkConfig();
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        memberVote.vote{value: entryFee}(OPTION_A);
        vm.prank(USER2);
        memberVote.vote{value: entryFee}(OPTION_B);
        vm.prank(USER3);
        memberVote.vote{value: entryFee}(OPTION_A);

        vm.prank(msg.sender);
        memberVote.resetVotes();
        assertEq(memberVote.getOptionAVotes(), STARTING_OPTION_A_VOTES, "Option A votes should be reset to 0");
        assertEq(memberVote.getOptionBVotes(), STARTING_OPTION_B_VOTES, "Option B votes should be reset to 0");
    }

    function testIfVoterCanVoteAfterReset() external {
        (uint256 entryFee) = helperConfig.activeNetworkConfig();
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        memberVote.vote{value: entryFee}(OPTION_A);
        vm.prank(USER2);
        memberVote.vote{value: entryFee}(OPTION_B);
        vm.prank(USER3);
        memberVote.vote{value: entryFee}(OPTION_A);

        vm.startPrank(msg.sender);
        memberVote.resetVotes();
        memberVote.startVote();
        vm.stopPrank();
        vm.prank(USER1);
        memberVote.vote{value: entryFee}(OPTION_A);
        vm.prank(USER2);
        memberVote.vote{value: entryFee}(OPTION_B);
        vm.prank(USER3);
        memberVote.vote{value: entryFee}(OPTION_A);
        assertEq(memberVote.getOptionAVotes(), 2, "Option A should have 2 votes after reset and new votes");
        assertEq(memberVote.getOptionBVotes(), 1, "Option B should have 1 vote after reset and new votes");
    }
}
