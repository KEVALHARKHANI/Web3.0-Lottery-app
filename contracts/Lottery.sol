// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Lottery is Ownable {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethusedpricefeed;
    enum LOTTERY_STATE{OPEN, CLOSED, CALCULATING_WINNER }
    LOTTERY_STATE public lottery_state;
    constructor(address _pricefeed) public{
        usdEntryFee = 50*(10**18);
        ethusedpricefeed = AggregatorV3Interface(_pricefeed);
        lottery_state = LOTTERY_STATE.CLOSED;
}

    function enter() public payable{
        //$50 minimum
        require(lottery_state == LOTTERY_STATE.OPEN,'Lottery is not Open yet');
        require(msg.value>=getEntranceFee(),'Not enough eth');
        players.push(msg.sender);


    }

    function getEntranceFee() public view returns(uint256){
    (,int price,,,) = ethusedpricefeed.latestRoundData();
        uint256 adjustedPrice = uint256(price)*10**10;
        uint256 costToenter = (usdEntryFee*10**18)/adjustedPrice;
        return costToenter;

    }

    function startLottery() public onlyOwner{
        require(lottery_state == LOTTERY_STATE.CLOSED,"Can't start lottery");
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public {

        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        uint256 winner = uint256(
        73428374345334924%players.length
    );
        address payable winner_player = players[winner];
        winner_player.transfer(address(this).balance);

    }
}
