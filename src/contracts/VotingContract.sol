// SPDX-License-Identifier: UNLICENCED
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract VotingContract {
    
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        uint voterId;
        bool hasVoted;
    }

    mapping(address => Voter) public voters;
    mapping(uint => bool) public uniqueVoterIds;
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public adminAccountIds;
    address[] public voterAddresses;
    uint public candidatesCount=0;
    uint public votingEndTime;

    event votedEvent (
        uint indexed _candidateId
    );

    event voterRegisteredEvent (
        address indexed _voterAddress,
        uint indexed _voterId
    );

    constructor () public {
        // Initialize admin account IDs
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0x4b3527ad07fA1Ab3E7bFe83ec18cC6cB57d6c908)] = true;

        votingEndTime = block.timestamp;
    }

    function addCandidate(string memory _name) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can add the candidate"); // Check if msg.sender is an admin
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId, uint _voterId) public {
        require(block.timestamp < votingEndTime, "Voting has ended");
        require(voters[msg.sender].voterId != 0, "Voter not registered");
        require(voters[msg.sender].voterId == _voterId, "InvalidVoterId" );
        require(!voters[msg.sender].hasVoted, "You have already voted");
        voters[msg.sender].hasVoted = true;
        voterAddresses.push(msg.sender);
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }

    function registerVoter(uint _voterId, address _voterAddress) public{
        require(uniqueVoterIds[_voterId] && voters[_voterAddress].voterId!=0, "Already with same voter Id exists in Pool" );
        voters[_voterAddress] = Voter(_voterId, false);
        uniqueVoterIds[_voterId] = true;
        voterAddresses.push(_voterAddress);
        emit voterRegisteredEvent(_voterAddress, _voterId);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory result = new Candidate[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            result[i - 1] = candidates[i];
        }

        return result;
    }

    function getVotingEndTime() public view returns (uint) {
        return votingEndTime;
    }

    function updateVotingEndTime(uint newTimeStamp) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can update the end time"); // Check if msg.sender is an admin
        votingEndTime = newTimeStamp;
    }

    function checkIfVoterIdExists(uint _voterId) public view returns (bool) {
        return uniqueVoterIds[_voterId] && voters[msg.sender].voterId == _voterId;
    }

    // Updated function to check if an admin account exists
    function checkIfAdminUser(address adminAccountId) public view returns (bool) {
        return adminAccountIds[adminAccountId];
    } 

    function startNewPoll(uint newTimeStamp) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can start a new poll");

        // Clear candidates
        for (uint i = 1; i <= candidatesCount; i++) {
            delete candidates[i];
        }
        candidatesCount = 0;

        // Reset voters
        for (uint i = 0; i < voterAddresses.length; i++) {
            delete uniqueVoterIds[voters[voterAddresses[i]].voterId];
            delete voters[voterAddresses[i]];
            
        }

        delete voterAddresses;

        // Update voting end time to the given timestamp
        votingEndTime = newTimeStamp;
    }

    function getWinner() public view returns (string memory) {
        require(candidatesCount > 0, "No candidates available");

        uint maxVotes = 0;
        uint winningCandidateId;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;
    }


}

/*
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract VotingContract {
    
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        uint voterId;
        string biometricData;
        bool hasVoted;
    }

    mapping(uint => Voter) public voters;
    mapping(uint => bool) public uniqueVoterIds;
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public adminAccountIds;
    uint public candidatesCount = 0;
    uint public votingEndTime;

    event votedEvent (
        uint indexed _candidateId
    );

    constructor () public {
        // Initialize admin account IDs
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0xAe1DdF39a90FeeAc8708739aacCa6e8781daC6c6)] = true;
        adminAccountIds[address(0x4b3527ad07fA1Ab3E7bFe83ec18cC6cB57d6c908)] = true;
    }

    function addCandidate(string memory _name) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can add the candidate"); // Check if msg.sender is an admin
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        votingEndTime = block.timestamp;
    }

    function registerVoter(uint _voterId, string memory _biometricData) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can register voters");
        require(!uniqueVoterIds[_voterId], "Voter ID already exists");
        uniqueVoterIds[_voterId] = true;
        voters[_voterId] = Voter(_voterId, _biometricData, false);
    }

    function authenticateVoter(uint _voterId, string memory _biometricData) public view returns (bool) {
        Voter memory voter = voters[_voterId];
        return (voter.voterId == _voterId && keccak256(bytes(voter.biometricData)) == keccak256(bytes(_biometricData)));
    }

    function vote(uint _candidateId, uint _voterId, string memory _biometricData) public {
        require(block.timestamp < votingEndTime, "Voting has ended");
        require(!voters[_voterId].hasVoted, "You have already voted");
        require(authenticateVoter(_voterId, _biometricData), "Voter authentication failed");

        voters[_voterId].hasVoted = true;
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory result = new Candidate[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            result[i - 1] = candidates[i];
        }

        return result;
    }

    function getVotingEndTime() public view returns (uint) {
        return votingEndTime;
    }

    function updateVotingEndTime(uint newTimeStamp) public {
        require(adminAccountIds[msg.sender], "Only admin accounts can update the end time"); // Check if msg.sender is an admin
        votingEndTime = newTimeStamp;
    }

    function checkIfVoterIdExists(uint _voterId) public view returns (bool) {
        return uniqueVoterIds[_voterId];
    }

    // Updated function to check if an admin account exists
    function checkIfAdminUser(address adminAccountId) public view returns (bool) {
        return adminAccountIds[adminAccountId];
    }

    function getVoterInfo(uint _voterId) public view returns (uint, string memory, bool) {
        Voter memory voter = voters[_voterId];
        return (voter.voterId, voter.biometricData, voter.hasVoted);
    }
}
*/
