// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MemberVote} from "src/MemberVote.sol";
import {DeployMemberVote} from "script/MemberVote.s.sol";

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

    function setUp() external {
        DeployMemberVote deployer = new DeployMemberVote();
        memberVote = deployer.run();
        vm.deal(USER1, STARTING_PLAYER_BALANCE);
        vm.deal(USER2, STARTING_PLAYER_BALANCE);
        vm.deal(USER3, STARTING_PLAYER_BALANCE);
    }

    function testIfWorkflowStationAtStartIsRegistering() public view {
        assertEq(uint256(memberVote.getWorkflowStation()), 0);
    }

    ///////////////////////
    // Start Vote Tests //
    /////////////////////
    function testIfOwnerCanStartVoting() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        assertEq(uint256(memberVote.getWorkflowStation()), 1);
    }

    function testIfVoterCannotStartVoting() public {
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__NotOwner.selector);
        memberVote.startVote();
    }

    ///////////////////////
    // Reset Vote Tests //
    /////////////////////
    function testIfOwnerCanResetVotes() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(msg.sender);
        memberVote.resetVotes();
        assertEq(uint256(memberVote.getWorkflowStation()), 2);
    }

    function testIfVoterCannotResetVotes() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__NotOwner.selector);
        memberVote.resetVotes();
    }

    function testIfOwnerCanDirectlyResetVotesWithoutStarting() public {
        vm.prank(msg.sender);
        vm.expectRevert(MemberVote.MemberVote__WrongWorkflowStation.selector);
        memberVote.resetVotes();
    }

    //////////////////////////
    // Vote Function Tests //
    /////////////////////////
    function testIfVoterCanVote() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        memberVote.vote{value: 0.01 ether}(OPTION_A);
        assertEq(memberVote.getOptionAVotes(), STARTING_OPTION_A_VOTES + 1);
        memberVote.vote{value: 0.01 ether}(OPTION_B);
        assertEq(memberVote.getOptionBVotes(), STARTING_OPTION_B_VOTES + 1);
    }

    function testIfVoterCanVoteInvalidOption() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__InvalidOption.selector);
        memberVote.vote{value: 0.01 ether}(2);
    }

    function testIfVoterCanVoteWithoutPayingEntryFee() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__InvalidEntryFee.selector);
        memberVote.vote(OPTION_A);
    }

    function testIfVoterCanVoteMoreThanOnce() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        vm.prank(USER1);
        memberVote.vote{value: 0.01 ether}(OPTION_A);
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__AlreadyVoted.selector);
        memberVote.vote{value: 0.01 ether}(OPTION_B);
    }

    function testIfVoterCanVoteWhenVotingNotStarted() public {
        vm.prank(USER1);
        vm.expectRevert(MemberVote.MemberVote__WrongWorkflowStation.selector);
        memberVote.vote{value: 0.01 ether}(OPTION_A);
    }

    ////////////////////////////
    // Getter Function Tests //
    //////////////////////////

    function testGetters() public {
        vm.prank(msg.sender);
        memberVote.startVote();
        assertEq(memberVote.getOptionAVotes(), STARTING_OPTION_A_VOTES);
        assertEq(memberVote.getOptionBVotes(), STARTING_OPTION_B_VOTES);
        assertEq(uint256(memberVote.getWorkflowStation()), 1);
        address[] memory expectedVoters = new address[](0);
        assertEq(memberVote.getVoters().length, expectedVoters.length);
    }
}
