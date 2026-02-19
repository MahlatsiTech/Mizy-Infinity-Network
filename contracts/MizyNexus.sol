// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MizyNexus {
    
    struct SovereignNode {
        string nodeId;
        uint256 energyKwh;
        uint256 waterLiters;
        bool isActive;
        uint256 registrationTime;
    }
    
    mapping(string => SovereignNode) public registry;
    mapping(address => bool) public authorizedDeployers;
    
    address public owner;
    uint256 public totalNodes;
    uint256 public totalEnergyKwh;
    uint256 public totalWaterLiters;
    
    event NodeRegistered(string indexed nodeId, address indexed registrant, uint256 timestamp);
    event UtilityPaid(string indexed nodeId, uint256 amount, bool isWater, uint256 timestamp);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    modifier onlyAuthorized() {
        require(msg.sender == owner || authorizedDeployers[msg.sender], "Not authorized");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        authorizedDeployers[msg.sender] = true;
    }
    
    function registerNode(string memory _nodeId) public onlyAuthorized {
        require(bytes(_nodeId).length > 0, "Empty ID");
        require(bytes(registry[_nodeId].nodeId).length == 0, "Exists");
        
        registry[_nodeId] = SovereignNode({
            nodeId: _nodeId,
            energyKwh: 0,
            waterLiters: 0,
            isActive: true,
            registrationTime: block.timestamp
        });
        
        totalNodes++;
        emit NodeRegistered(_nodeId, msg.sender, block.timestamp);
    }
    
    function payUtility(string memory _nodeId, uint256 _amount, bool _isWater) public payable {
        require(bytes(registry[_nodeId].nodeId).length > 0, "Not found");
        require(registry[_nodeId].isActive, "Inactive");
        require(_amount > 0, "Zero amount");
        require(msg.value > 0, "Payment required");
        
        if (_isWater) {
            registry[_nodeId].waterLiters += _amount;
            totalWaterLiters += _amount;
        } else {
            registry[_nodeId].energyKwh += _amount;
            totalEnergyKwh += _amount;
        }
        
        emit UtilityPaid(_nodeId, _amount, _isWater, block.timestamp);
    }
    
    function getNodeDetails(string memory _nodeId) public view returns (SovereignNode memory) {
        require(bytes(registry[_nodeId].nodeId).length > 0, "Not found");
        return registry[_nodeId];
    }
    
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    
    receive() external payable {}
}
