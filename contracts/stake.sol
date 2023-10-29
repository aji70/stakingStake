// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import './MyNFT.sol';

contract Stake is Ajidokwu(0x4246a99Db07C10fCE03ab238f68E5003AC5264a1) {

IERC721 public rewardToken;
    uint256 public rewardRate;
    uint256 public totalStaked;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastStakeTime;
    mapping(address => uint256) public rewardPerToken;
    mapping(address => uint256) public rewardsEarned;
    mapping(address => uint256) public rewardsPaid;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _rewardToken, uint256 _rewardRate) {
        rewardToken = IERC721(_rewardToken);
        rewardRate = _rewardRate;
    }
function stake(uint256 _tokenId) external {
        require(IERC721(msg.sender).ownerOf(_tokenId) == msg.sender, "You do not own this NFT");
        require(lastStakeTime[msg.sender] == 0 || block.timestamp > lastStakeTime[msg.sender] + 60 seconds, "You must wait at least 24 hours before staking again");

        // Transfer NFT to this contract
        IERC721(msg.sender).safeTransferFrom(msg.sender, address(this), _tokenId);

        // Calculate rewards earned
        uint256 rewards = rewardsEarned[msg.sender] + (stakedBalance[msg.sender] * (rewardPerToken[msg.sender] - rewardsPaid[msg.sender]));

        // Update user data
        stakedBalance[msg.sender] += 1;
        lastStakeTime[msg.sender] = block.timestamp;
        rewardPerToken[msg.sender] += rewards / stakedBalance[msg.sender];
        rewardsEarned[msg.sender] = 0;

        // Update contract data
        totalStaked += 1;

        emit Staked(msg.sender, 1);
    }

function unstake(uint256 _tokenId) external {
        require(IERC721(msg.sender).ownerOf(_tokenId) == address(this), "NFT is not staked");
        require(IERC721(msg.sender).getApproved(_tokenId) == address(this), "You must approve this contract to unstake your NFT");

        // Calculate rewards earned
        uint256 rewards = rewardsEarned[msg.sender] + (stakedBalance[msg.sender] * (rewardPerToken[msg.sender] - rewardsPaid[msg.sender]));

        // Update user data
        stakedBalance[msg.sender] -= 1;
        rewardPerToken[msg.sender] += rewards / stakedBalance[msg.sender];
        rewardsEarned[msg.sender] = rewards;
        rewardsPaid[msg.sender] = rewards;
        lastStakeTime[msg.sender] = block.timestamp;

        // Update contract data
        totalStaked -= 1;

        // Transfer NFT back to owner
        IERC721(msg.sender).safeTransferFrom(address(this), msg.sender, _tokenId);

        emit Unstaked(msg.sender, 1);
        }
}