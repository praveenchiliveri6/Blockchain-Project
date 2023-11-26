// SPDX-License-Identifier: UNLICENCED
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract VotingContract {
    
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters;
    mapping(uint => bool) public uniqueVoterIds;
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public adminAccountIds;
    uint public candidatesCount=0;
    uint public votingEndTime;

    event votedEvent (
        uint indexed _candidateId
    );

    constructor () public {
        // Initialize unique voter IDs
        uniqueVoterIds[123] = true;
        uniqueVoterIds[456] = true;
        uniqueVoterIds[789] = true;

        // Initialize admin account IDs
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0x4b3527ad07fA1Ab3E7bFe83ec18cC6cB57d6c908)] = true;
        adminAccountIds[address(0x76D81132eb074d4d2277fB10FdF14177fBFA7341)] = true;

        votingEndTime = block.timestamp;
    }

    function addCandidate(string memory _name) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can add the candidate"); // Check if msg.sender is an admin
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public {
        require(block.timestamp < votingEndTime, "Voting has ended");
        require(!voters[msg.sender], "You have already voted");
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }

    function getCandidates() public returns (Candidate[] memory) {
        Candidate[] memory result = new Candidate[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            result[i - 1] = candidates[i];
        }

        return result;
    }

    function getVotingEndTime() public returns (uint) {
        return votingEndTime;
    }

    function updateVotingEndTime(uint newTimeStamp) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can update the end time"); // Check if msg.sender is an admin
        votingEndTime = newTimeStamp;
    }

    function checkIfVoterIdExists(uint voterId) public returns (bool) {
        return uniqueVoterIds[voterId];
    }

    // Updated function to check if an admin account exists
    function checkIfAdminUser(address adminAccountId) public returns (bool) {
        return adminAccountIds[adminAccountId];
    }
}
