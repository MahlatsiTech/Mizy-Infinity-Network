// SPDX-License-Identifier: MIT
// MizyNexus.sol - Empire-Scale Dual-Utility Blockchain Infrastructure Protocol
// Built for BNB Chain Smart Builders Challenge 2026
// Author: Nthabiseng Mahlatsi
// Location: Soweto, South Africa
// GitHub: https://github.com/MahlatsiTech/Mizy-Infinity-Network

pragma solidity ^0.8.20;

/**
 * @title MizyNexus
 * @dev Empire-Scale Dual-Utility Blockchain Infrastructure Protocol
 * @author Nthabiseng Mahlatsi - Red Seal Certified Electrical Engineer
 * @notice Transparent energy, water, and infrastructure management for emerging markets
 * 
 * THREE-PILLAR EMPIRE STRUCTURE:
 * 1. Infrastructure Pillar: Power Stations, Solar, Water, Manufacturing (Hard Assets)
 * 2. Human Capital Pillar: Education, Coders, Developers (Growth Engine)
 * 3. Capital & Services Pillar: Investments, Accounts, Governance (Capital Layer)
 */
contract MizyNexus {
    
    // ============ STRUCTS ============
    
    /**
     * @dev SovereignNode - Represents any infrastructure entity in the protocol
     */
    struct SovereignNode {
        string nodeId;
        uint8 nodeType; // 0=Household, 1=PowerStation, 2=ChargingStation, 3=WaterPlant, 4=Manufacturing
        uint256 energyKwh;
        uint256 waterLiters;
        bool isActive;
        uint256 registrationTime;
        string location;
        uint256 totalPayments;
    }
    
    /**
     * @dev PaymentRecord - Immutable transaction record
     */
    struct PaymentRecord {
        string nodeId;
        uint256 amount;
        uint8 utilityType; // 0=Energy, 1=Water, 2=Service
        uint256 timestamp;
        address payer;
    }
    
    /**
     * @dev InfrastructureAsset - For power stations, charging stations, etc.
     */
    struct InfrastructureAsset {
        string assetId;
        uint8 assetType; // 0=SolarFarm, 1=PowerStation, 2=ChargingStation, 3=WaterPlant
        uint256 capacity;
        uint256 currentOutput;
        string location;
        bool isOperational;
        uint256 installationDate;
        address operator;
    }
    
    // ============ STATE VARIABLES ============
    
    mapping(string => SovereignNode) public registry;
    mapping(string => PaymentRecord[]) public paymentHistory;
    mapping(string => InfrastructureAsset) public infrastructureAssets;
    mapping(address => bool) public authorizedDeployers;
    mapping(address => string[]) public operatorNodes;
    
    string[] public nodeList;
    string[] public assetList;
    
    address public owner;
    address public pendingOwner;
    uint256 public treasuryBalance;
    bool public paused = false;
    
    uint256 public totalNodes;
    uint256 public totalAssets;
    uint256 public totalEnergyKwh;
    uint256 public totalWaterLiters;
    uint256 public totalPayments;
    uint256 public totalTransactions;
    
    uint256 public transactionFeePercent = 1;
    uint256 public nodeRegistrationFee = 0.001 ether;
    uint256 public assetRegistrationFee = 0.01 ether;
    
    uint256 public deploymentTime;
    string public deploymentNetwork;
    
    // ============ CONSTANTS ============
    
    uint8 public constant TYPE_HOUSEHOLD = 0;
    uint8 public constant TYPE_POWER_STATION = 1;
    uint8 public constant TYPE_CHARGING_STATION = 2;
    uint8 public constant TYPE_WATER_PLANT = 3;
    uint8 public constant TYPE_MANUFACTURING = 4;
    
    uint8 public constant ASSET_SOLAR_FARM = 0;
    uint8 public constant ASSET_POWER_STATION = 1;
    uint8 public constant ASSET_CHARGING_STATION = 2;
    uint8 public constant ASSET_WATER_PLANT = 3;
    
    uint8 public constant UTILITY_ENERGY = 0;
    uint8 public constant UTILITY_WATER = 1;
    uint8 public constant UTILITY_SERVICE = 2;
    
    // ============ EVENTS ============
    
    event NodeRegistered(
        string indexed nodeId,
        uint8 nodeType,
        address indexed registrant,
        string location,
        uint256 timestamp
    );
    
    event UtilityPaymentRecorded(
        string indexed nodeId,
        uint256 amount,
        uint8 utilityType,
        uint256 timestamp,
        address indexed payer
    );
    
    event InfrastructureAssetRegistered(
        string indexed assetId,
        uint8 assetType,
        uint256 capacity,
        string location,
        address indexed operator,
        uint256 timestamp
    );
    
    event AssetOutputUpdated(
        string indexed assetId,
        uint256 newOutput,
        uint256 timestamp
    );
    
    event NodeStatusChanged(
        string indexed nodeId,
        bool isActive,
        address indexed changedBy,
        uint256 timestamp
    );
    
    event TreasuryWithdrawal(
        address indexed to,
        uint256 amount,
        uint256 timestamp
    );
    
    event DeployerAuthorized(address indexed deployer, address indexed authorizedBy);
    event DeployerDeauthorized(address indexed deployer, address indexed deauthorizedBy);
    event OwnershipTransferInitiated(address indexed currentOwner, address indexed pendingOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ProtocolPaused(address indexed pausedBy);
    event ProtocolUnpaused(address indexed unpausedBy);
    
    // ============ MODIFIERS ============
    
    modifier onlyOwner() {
        require(msg.sender == owner, "MizyNexus: Caller is not owner");
        _;
    }
    
    modifier onlyAuthorized() {
        require(
            authorizedDeployers[msg.sender] || msg.sender == owner,
            "MizyNexus: Not authorized"
        );
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "MizyNexus: Protocol is paused");
        _;
    }
    
    modifier nodeExists(string memory _nodeId) {
        require(registry[_nodeId].registrationTime > 0, "MizyNexus: Node does not exist");
        _;
    }
    
    modifier nodeIsActive(string memory _nodeId) {
        require(registry[_nodeId].isActive, "MizyNexus: Node is not active");
        _;
    }
    
    modifier newNode(string memory _nodeId) {
        require(registry[_nodeId].registrationTime == 0, "MizyNexus: Node already exists");
        _;
    }
    
    // ============ CONSTRUCTOR ============
    
    constructor(string memory _network) {
        owner = msg.sender;
        authorizedDeployers[msg.sender] = true;
        deploymentTime = block.timestamp;
        deploymentNetwork = _network;
        emit DeployerAuthorized(msg.sender, msg.sender);
    }
    
    // ============ NODE MANAGEMENT ============
    
    function registerNode(
        string memory _nodeId,
        uint8 _nodeType,
        string memory _location
    ) 
        public 
        payable 
        whenNotPaused
        onlyAuthorized
        newNode(_nodeId) 
    {
        require(bytes(_nodeId).length > 0, "MizyNexus: Invalid node ID");
        require(_nodeType <= 4, "MizyNexus: Invalid node type");
        require(msg.value >= nodeRegistrationFee, "MizyNexus: Insufficient fee");
        
        registry[_nodeId] = SovereignNode({
            nodeId: _nodeId,
            nodeType: _nodeType,
            energyKwh: 0,
            waterLiters: 0,
            isActive: true,
            registrationTime: block.timestamp,
            location: _location,
            totalPayments: 0
        });
        
        nodeList.push(_nodeId);
        operatorNodes[msg.sender].push(_nodeId);
        totalNodes++;
        treasuryBalance += msg.value;
        totalTransactions++;
        
        emit NodeRegistered(_nodeId, _nodeType, msg.sender, _location, block.timestamp);
    }
    
    function recordUtilityUsage(
        string memory _nodeId,
        uint256 _amount,
        uint8 _utilityType
    ) 
        public 
        whenNotPaused
        onlyAuthorized
        nodeExists(_nodeId)
        nodeIsActive(_nodeId) 
    {
        require(_amount > 0, "MizyNexus: Amount must be > 0");
        require(_utilityType <= 2, "MizyNexus: Invalid utility type");
        
        SovereignNode storage node = registry[_nodeId];
        
        if (_utilityType == UTILITY_ENERGY) {
            node.energyKwh += _amount;
            totalEnergyKwh += _amount;
        } else if (_utilityType == UTILITY_WATER) {
            node.waterLiters += _amount;
            totalWaterLiters += _amount;
        }
        
        node.totalPayments++;
        totalPayments++;
        totalTransactions++;
        
        paymentHistory[_nodeId].push(PaymentRecord({
            nodeId: _nodeId,
            amount: _amount,
            utilityType: _utilityType,
            timestamp: block.timestamp,
            payer: msg.sender
        }));
        
        emit UtilityPaymentRecorded(_nodeId, _amount, _utilityType, block.timestamp, msg.sender);
    }
    
    function toggleNodeStatus(string memory _nodeId) 
        public 
        onlyAuthorized
        nodeExists(_nodeId) 
    {
        bool newStatus = !registry[_nodeId].isActive;
        registry[_nodeId].isActive = newStatus;
        
        if (newStatus) {
            totalNodes++;
        } else {
            totalNodes--;
        }
        
        emit NodeStatusChanged(_nodeId, newStatus, msg.sender, block.timestamp);
    }
    
    // ============ INFRASTRUCTURE ASSETS ============
    
    function registerInfrastructureAsset(
        string memory _assetId,
        uint8 _assetType,
        uint256 _capacity,
        string memory _location
    ) 
        public 
        payable 
        whenNotPaused
        onlyAuthorized
    {
        require(bytes(_assetId).length > 0, "MizyNexus: Invalid asset ID");
        require(_assetType <= 3, "MizyNexus: Invalid asset type");
        require(_capacity > 0, "MizyNexus: Capacity must be > 0");
        require(infrastructureAssets[_assetId].installationDate == 0, "MizyNexus: Asset exists");
        require(msg.value >= assetRegistrationFee, "MizyNexus: Insufficient fee");
        
        infrastructureAssets[_assetId] = InfrastructureAsset({
            assetId: _assetId,
            assetType: _assetType,
            capacity: _capacity,
            currentOutput: 0,
            location: _location,
            isOperational: true,
            installationDate: block.timestamp,
            operator: msg.sender
        });
        
        assetList.push(_assetId);
        totalAssets++;
        treasuryBalance += msg.value;
        totalTransactions++;
        
        emit InfrastructureAssetRegistered(_assetId, _assetType, _capacity, _location, msg.sender, block.timestamp);
    }
    
    function updateAssetOutput(
        string memory _assetId,
        uint256 _newOutput
    ) 
        public 
        whenNotPaused
        onlyAuthorized
    {
        InfrastructureAsset storage asset = infrastructureAssets[_assetId];
        require(asset.installationDate > 0, "MizyNexus: Asset not found");
        require(_newOutput <= asset.capacity, "MizyNexus: Output exceeds capacity");
        
        asset.currentOutput = _newOutput;
        totalTransactions++;
        
        emit AssetOutputUpdated(_assetId, _newOutput, block.timestamp);
    }
    
    // ============ VIEW FUNCTIONS ============
    
    function getNodeDetails(string memory _nodeId) 
        public 
        view 
        returns (SovereignNode memory) 
    {
        return registry[_nodeId];
    }
    
    function getPaymentHistory(string memory _nodeId) 
        public 
        view 
        returns (PaymentRecord[] memory) 
    {
        return paymentHistory[_nodeId];
    }
    
    function getAssetDetails(string memory _assetId) 
        public 
        view 
        returns (InfrastructureAsset memory) 
    {
        return infrastructureAssets[_assetId];
    }
    
    function getAllNodes() public view returns (string[] memory) {
        return nodeList;
    }
    
    function getAllAssets() public view returns (string[] memory) {
        return assetList;
    }
    
    function getNodesByOperator(address _operator) 
        public 
        view 
        returns (string[] memory) 
    {
        return operatorNodes[_operator];
    }
    
    function getProtocolStats() 
        public 
        view 
        returns (
            uint256 _totalNodes,
            uint256 _totalAssets,
            uint256 _totalEnergy,
            uint256 _totalWater,
            uint256 _totalPayments,
            uint256 _totalTransactions,
            uint256 _treasuryBalance
        ) 
    {
        return (
            totalNodes,
            totalAssets,
            totalEnergyKwh,
            totalWaterLiters,
            totalPayments,
            totalTransactions,
            treasuryBalance
        );
    }
    
    function isNodeActive(string memory _nodeId) public view returns (bool) {
        return registry[_nodeId].isActive;
    }
    
    function getNodeTypeString(uint8 _type) public pure returns (string memory) {
        if (_type == TYPE_HOUSEHOLD) return "Household";
        if (_type == TYPE_POWER_STATION) return "Power Station";
        if (_type == TYPE_CHARGING_STATION) return "Charging Station";
        if (_type == TYPE_WATER_PLANT) return "Water Plant";
        if (_type == TYPE_MANUFACTURING) return "Manufacturing";
        return "Unknown";
    }
    
    function getAssetTypeString(uint8 _type) public pure returns (string memory) {
        if (_type == ASSET_SOLAR_FARM) return "Solar Farm";
        if (_type == ASSET_POWER_STATION) return "Power Station";
        if (_type == ASSET_CHARGING_STATION) return "Charging Station";
        if (_type == ASSET_WATER_PLANT) return "Water Plant";
        return "Unknown";
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    function authorizeDeployer(address _deployer) public onlyOwner {
        require(_deployer != address(0), "MizyNexus: Invalid address");
        require(!authorizedDeployers[_deployer], "MizyNexus: Already authorized");
        authorizedDeployers[_deployer] = true;
        emit DeployerAuthorized(_deployer, msg.sender);
    }
    
    function deauthorizeDeployer(address _deployer) public onlyOwner {
        require(authorizedDeployers[_deployer], "MizyNexus: Not authorized");
        require(_deployer != owner, "MizyNexus: Cannot deauthorize owner");
        authorizedDeployers[_deployer] = false;
        emit DeployerDeauthorized(_deployer, msg.sender);
    }
    
    function setFees(
        uint256 _txFeePercent,
        uint256 _nodeFee,
        uint256 _assetFee
    ) public onlyOwner {
        require(_txFeePercent <= 10, "MizyNexus: Fee too high");
        transactionFeePercent = _txFeePercent;
        nodeRegistrationFee = _nodeFee;
        assetRegistrationFee = _assetFee;
    }
    
    function pause() public onlyOwner {
        paused = true;
        emit ProtocolPaused(msg.sender);
    }
    
    function unpause() public onlyOwner {
        paused = false;
        emit ProtocolUnpaused(msg.sender);
    }
    
    function initiateOwnershipTransfer(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "MizyNexus: Invalid address");
        pendingOwner = _newOwner;
        emit OwnershipTransferInitiated(owner, _newOwner);
    }
    
    function acceptOwnership() public {
        require(msg.sender == pendingOwner, "MizyNexus: Not pending owner");
        address previousOwner = owner;
        owner = pendingOwner;
        pendingOwner = address(0);
        authorizedDeployers[owner] = true;
        emit OwnershipTransferred(previousOwner, owner);
    }
    
    function withdrawTreasury(uint256 _amount, address payable _to) public onlyOwner {
        require(_amount <= treasuryBalance, "MizyNexus: Insufficient balance");
        require(_to != address(0), "MizyNexus: Invalid address");
        treasuryBalance -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "MizyNexus: Transfer failed");
        emit TreasuryWithdrawal(_to, _amount, block.timestamp);
    }
    
    // ============ FALLBACK ============
    
    receive() external payable {
        treasuryBalance += msg.value;
    }
    
    fallback() external payable {
        treasuryBalance += msg.value;
    }
}
