/**********************************************************************
*These solidity codes have been obtained from Etherscan for extracting
*the smartcontract related info.
*The data will be used by MATRIX AI team as the reference basis for
*MATRIX model analysis,extraction of contract semantics,
*as well as AI based data analysis, etc.
**********************************************************************/
pragma solidity ^0.4.19;

contract Leaderboard {
    struct User {
        address user;
        uint balance;
        string name;
    }
    
    User[3] public leaderboard;
    
    address owner;
    
    function Leaderboard() public {
        owner = msg.sender;
    }
    
    function addScore(string name) public payable returns (bool) {
        if (leaderboard[2].balance >= msg.value)
            // user didn't make it into top 3
            return false;
        for (uint i=0; i<3; i++) {
            if (leaderboard[i].balance < msg.value) {
                // resort
                if (leaderboard[i].user != msg.sender) {
                    bool duplicate = false;
                    for (uint j=i+1; j<3; j++) {
                        if (leaderboard[j].user == msg.sender) {
                            duplicate = true;
                            delete leaderboard[j];
                        }
                        if (duplicate)
                            leaderboard[j] = leaderboard[j+1];
                        else
                            leaderboard[j] = leaderboard[j-1];
                    }
                }
                // add new highscore
                leaderboard[i] = User({
                    user: msg.sender,
                    balance: msg.value,
                    name: name
                });
                return true;
            }
            if (leaderboard[i].user == msg.sender)
                // user is alrady in list with higher or equal score
                return false;
        }
    }
    
    function withdrawBalance() public {
        owner.transfer(this.balance);
    }
    
    function get() public constant returns (User[3]){
        return leaderboard;
    }
}