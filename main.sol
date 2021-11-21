//SPDX-License-Identifier GPL-30
pragma solidity >= 0.7.0 < 0.9.0;
contract GambleGame{
    event WhoPaid(address indexed sender, uint256 payment);
    
    address owner;
    mapping (uint256=>mapping(address=>bool)) paidMemberList;
    uint256 round =1;
    
    constructor(){
        owner = msg.sender;
    }
    receive() external payable{
        require(msg.value==1 ether, "Only 1 ether indeed");
        require(paidMemberList[round][msg.sender]==false,"Every player can play just once each game");
        paidMemberList[round][msg.sender]=true;
        emit WhoPaid(msg.sender, msg.value);
        if(address(this).balance==3 ether){
            (bool sent,)=payable(msg.sender).call{value:address(this).balance}("");
            require(sent,"Fail");
            round++;
        }
    }
    function checkRound() public view returns(uint256){
        return round;
    }
    function checkValue() public view returns(uint256){
        require(owner==msg.sender, "only owner can access");
        return address(this).balance;
    }
}