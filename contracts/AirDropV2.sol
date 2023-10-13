// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.19;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {IDAOResource} from "@q-dev/gdk-contracts/interfaces/IDAOResource.sol";
import {ACampaignAirDrop} from "./libs/ACampaignAirDrop.sol";

// AirDropV2 Contract
contract AirDropV2 is ACampaignAirDrop, Initializable, IDAOResource {
    // Resource name for the AirDropV2 module
    string public constant AIR_DROP_V2_RESOURCE = "AIR_DROP_V2";

    // Address of the voting contract
    address public votingContract;

    // Modifier to restrict access to functions only to the voting contract
    modifier onlyVotingContract() {
        require(msg.sender == votingContract, "AirDropV2: caller is not the voting contract.");
        _;
    }

    // Constructor to set the voting contract address during deployment
    function __AirDropV2_init(address votingContract_) public initializer {
        votingContract = votingContract_;
    }

    // Create a new token distribution campaign (can be called only by voting contract)
    function createCampaign(
        address rewardToken_,
        uint256 rewardAmount_,
        bytes32 merkleRoot_,
        uint256 startTimestamp_,
        uint256 endTimestamp_
    ) external onlyVotingContract returns (uint256) {
        return _createCampaign(rewardToken_, rewardAmount_, startTimestamp_, endTimestamp_, merkleRoot_);
    }

    // Claim rewards from a specific campaign
    function claimReward(
        uint256 campaignId_,
        address account_,
        bytes32[] calldata merkleProof_
    ) external {
        _claimReward(campaignId_, account_, merkleProof_);
    }

    // Check permission function from the IDAOResource interface (always returns true for simplicity)
    function checkPermission(
        address /*member_*/,
        string calldata /*permission_*/
    ) external pure returns (bool) {
        return true;
    }

    // Get the resource name associated with this contract (IDAOResource interface)
    function getResource() external pure returns (string memory) {
        return AIR_DROP_V2_RESOURCE;
    }
}
