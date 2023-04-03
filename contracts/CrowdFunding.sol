// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        address[] donators;
        uint256[] donations; // Changed type to uint256[] initially was address[]
    }

    Campaign[] public campaigns;

    // mapping( uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable {
        Campaign storage campaign = campaigns[_id];

        uint256 amount = msg.value;

        require(campaign.deadline > block.timestamp, "The deadline has passed");
        require(
            campaign.amountCollected < campaign.target,
            "The target has been reached"
        );
        campaign.amountCollected += amount;
        campaign.donators.push(msg.sender);
        campaign.donations.push(msg.value);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + msg.value;
        }
    }

    /**
     *
     * @dev This function is not working as expected
     *The issue with the getDonators function is that in the return statement, you're trying to return *campaigns[].donations, which is incomplete and will not compile.
     */

    // function getDonators(
    //     uint256 _id
    // ) public view returns (address[] memory, uint256[] memory) {
    //     return (campaigns[_id].donators, campaigns[].donations);
    // }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        Campaign storage campaign = campaigns[_id];
        return (campaign.donators, campaign.donations); // Using correct index for donations array
    }

    function getCampaign() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
