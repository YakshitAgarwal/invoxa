// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Invoxa {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    uint256 public nextInvoiceId;

    struct Invoice {
        uint256 id;
        uint64 invoiceAmount;
        uint64 dueDate;
        uint64 numberOfInvestors;
        address[] investors;
        string invoice;
        bool isActive;
    }

    struct Company {
        address companyOwner;
        string companyName;
        string description;
        string proofOfId;
        uint64 foundingYear;
        Invoice[] invoices;
        bool exists;
    }

    mapping(address => Company) public companies;

    address[] public companyOwners;

    event CompanyRegistered(address indexed _companyOwner, string companyName);
    event InvoiceCreated(uint256 indexed invoiceId, address indexed company);

    error CompanyAlreadyRegistered();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function registerCompany(
        string memory _companyName,
        string memory _description,
        string memory _proofOfId,
        uint64 _foundingYear
    ) public {
        if (!companies[msg.sender].exists) {
            revert CompanyAlreadyRegistered();
        }

        require(
            bytes(_companyName).length > 0,
            "Company name cannot be an empty string"
        );
        require(
            bytes(_description).length > 0,
            "Description cannot be an empty string"
        );
        require(
            bytes(_companyName).length > 0,
            "Proof of ID cannot be an empty string"
        );
        require(
            _foundingYear < block.timestamp,
            "Founding year cannot be a future year"
        );

        Company storage company = companies[msg.sender];

        company.companyOwner = msg.sender;
        company.companyName = _companyName;
        company.description = _description;
        company.proofOfId = _proofOfId;
        company.foundingYear = _foundingYear;
        company.exists = true;

        companyOwners.push(msg.sender);

        emit CompanyRegistered(msg.sender, _companyName);
    }

    function createInvoice(
        uint64 _invoiceAmount,
        uint64 _dueDate,
        uint64 _numberOfInvestors,
        string memory _invoice
    ) public {
        require(companies[msg.sender].exists, "Register company first");
        require(
            bytes(_invoice).length > 0,
            "Invoice cannot be an empty string"
        );
        require(
            _invoiceAmount > 0,
            "Invoice amount cannot be less than or equal to zero"
        );
        require(
            _numberOfInvestors > 0,
            "Number of investors cannot be less than or equal to zero"
        );
        require(_dueDate > block.timestamp, "Due date has to be a future date");

        Company storage company = companies[msg.sender];

        if (company.invoices.length > 0) {
            require(
                !company.invoices[company.invoices.length - 1].isActive,
                "Outstanding invoice already exists"
            );
        }

        Invoice storage invoice = company.invoices.push();

        invoice.id = nextInvoiceId++;
        invoice.invoiceAmount = _invoiceAmount;
        invoice.dueDate = _dueDate;
        invoice.numberOfInvestors = _numberOfInvestors;
        invoice.invoice = _invoice;
        invoice.isActive = true;

        emit InvoiceCreated(invoice.id, msg.sender);
    }

    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function getCompany(
        address _companyOwner
    )
        public
        view
        returns (string memory, string memory, string memory, uint64, bool)
    {
        return (
            companies[_companyOwner].companyName,
            companies[_companyOwner].description,
            companies[_companyOwner].proofOfId,
            companies[_companyOwner].foundingYear,
            companies[_companyOwner].exists
        );
    }

    function getCompanyOwners() public view returns (address[] memory) {
        return companyOwners;
    }

    function getCompanyInvoices(
        address _companyOwner
    ) public view returns (Invoice[] memory) {
        return companies[_companyOwner].invoices;
    }

    function getInvoice(
        address _companyOwner,
        uint256 _index
    ) public view returns (Invoice memory) {
        require(
            _index < companies[_companyOwner].invoices.length,
            "Invalid invoice index"
        );
        return companies[_companyOwner].invoices[_index];
    }
}
