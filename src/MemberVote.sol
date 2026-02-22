// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title MemberVote
 * @author Pragyat Nikunj
 * @notice This contract is used to manage the voting process for members. It allows members to vote for candidates and keeps track of the votes.
 */
contract MemberVote {
    error MemberVote__NotOwner();
    error MemberVote__AlreadyVoted();
    error MemberVote__WrongWorkflowStation();
    error MemberVote__InvalidOption();
    error MemberVote__InvalidEntryFee();

    enum WorkFlowStation {
        Registering,
        Voting,
        Resetting
    }

    address private immutable i_owner;
    uint256 private s_electionId;
    uint256 private optionAVotes;
    uint256 private optionBVotes;
    uint256 private immutable i_entryFee;
    mapping(address => uint256) private s_addressToVoted;
    WorkFlowStation private s_workFlowStation;
    address[] private voters;

    constructor() {
        i_owner = msg.sender;
        i_entryFee = 0.01 ether;
        s_electionId = 1;
        s_workFlowStation = WorkFlowStation.Registering;
    }

    /**
     * @dev This modifier checks if the caller of a function is the owner of the contract. If the caller is not the owner, it reverts with an error. This is used to restrict certain functions to be only callable by the owner.
     */
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert MemberVote__NotOwner();
        }
        _;
    }

    /**
     * @notice This function allows the owner to start the voting process by changing the workflow station to Voting. It can only be called by the owner and will revert if called at the wrong workflow station.
     */
    function startVote() public onlyOwner {
        s_workFlowStation = WorkFlowStation.Voting;
    }

    /**
     * @notice This function allows the owner to reset the votes and return to the registering phase. It resets the vote counts for both options and marks all voters as not having voted. It can only be called by the owner and will revert if called at the wrong workflow station.
     * @dev This function is used to reset the voting process, allowing for a new round of voting to take place. It clears the vote counts and resets the voting status of all voters, effectively starting the process over from the registering phase.
     */
    function resetVotes() public onlyOwner {
        if (s_workFlowStation != WorkFlowStation.Voting) {
            revert MemberVote__WrongWorkflowStation();
        }
        s_workFlowStation = WorkFlowStation.Resetting;
        optionAVotes = 0;
        optionBVotes = 0;
        voters = new address[](0);
        s_electionId++;
    }

    /**
     * @notice This function allows a voter to cast their vote for a specific option.
     * @param option Option for which the voter is voting (0 for Option A, 1 for Option B)
     * @dev This function checks if the voting process is active, if the voter has already voted, and if the option is valid. If any of these conditions are not met, it reverts with an appropriate error. If the vote is successfully cast, it updates the vote count for the selected option and marks the voter as having voted.
     */
    function vote(uint256 option) public payable {
        address voter = msg.sender;
        if (msg.value < i_entryFee) {
            revert MemberVote__InvalidEntryFee();
        }
        if (s_workFlowStation != WorkFlowStation.Voting) {
            revert MemberVote__WrongWorkflowStation();
        }

        if (s_addressToVoted[voter] == s_electionId) {
            revert MemberVote__AlreadyVoted();
        }

        if (option != 0 && option != 1) {
            revert MemberVote__InvalidOption();
        }
        s_addressToVoted[voter] = s_electionId;
        voters.push(voter);

        if (option == 0) {
            optionAVotes += 1;
        }

        if (option == 1) {
            optionBVotes += 1;
        }
    }

    // Getters
    function getOptionAVotes() public view returns (uint256) {
        return optionAVotes;
    }

    function getOptionBVotes() public view returns (uint256) {
        return optionBVotes;
    }

    function getElectionId() public view returns (uint256) {
        return s_electionId;
    }

    function getWorkflowStation() public view returns (WorkFlowStation) {
        return s_workFlowStation;
    }

    function getVoters() public view returns (address[] memory) {
        return voters;
    }

    function addressVoted(address voter) public view returns (uint256) {
        return s_addressToVoted[voter];
    }
}
