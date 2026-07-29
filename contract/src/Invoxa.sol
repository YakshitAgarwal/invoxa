// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Invoxa {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    uint256 public nextInvoiceId;

    enum InvoiceStatus {
        Open,
        Funded,
        Repaid,
        Closed
    }

    struct Invoice {
        uint256 id;
        address companyOwner;
        uint64 invoiceAmount;
        uint64 dueDate;
        uint64 numberOfInvestors;
        string invoice;
        InvoiceStatus status;
    }

    struct Company {
        address companyOwner;
        string companyOwnerName;
        string companyName;
        string description;
        string proofOfIdentity;
        uint16 foundingYear;
        bool exists;
    }

    mapping(address => Company) public companies;

    mapping(uint256 => Invoice) public invoices;

    mapping(address => uint256[]) public companyInvoiceIds;

    address[] public companyOwners;

    event CompanyRegistered(address indexed companyOwner, string companyName);

    event InvoiceCreated(
        uint256 indexed invoiceId,
        address indexed companyOwner
    );

    error CompanyAlreadyRegistered();
    error CompanyNotRegistered();
    error OutstandingInvoiceExists();
    error InvalidInvoice();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function registerCompany(
        string memory _companyName,
        string memory _companyOwnerName,
        string memory _description,
        string memory _proofOfIdentity,
        uint16 _foundingYear
    ) public {
        if (companies[msg.sender].exists) {
            revert CompanyAlreadyRegistered();
        }

        require(bytes(_companyName).length > 0, "Invalid company name");
        require(bytes(_companyOwnerName).length > 0, "Invalid owner name");
        require(bytes(_description).length > 0, "Invalid description");
        require(bytes(_proofOfIdentity).length > 0, "Invalid proof");

        Company storage company = companies[msg.sender];

        company.companyOwner = msg.sender;
        company.companyOwnerName = _companyOwnerName;
        company.companyName = _companyName;
        company.description = _description;
        company.proofOfIdentity = _proofOfIdentity;
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
        if (!companies[msg.sender].exists) {
            revert CompanyNotRegistered();
        }

        require(bytes(_invoice).length > 0, "Invalid invoice");
        require(_invoiceAmount > 0, "Invalid amount");
        require(_numberOfInvestors > 0, "Invalid investor count");
        require(_dueDate > block.timestamp, "Invalid due date");

        // One outstanding invoice at a time
        uint256[] storage ids = companyInvoiceIds[msg.sender];

        if (ids.length > 0) {
            Invoice storage previousInvoice = invoices[ids[ids.length - 1]];

            if (previousInvoice.status != InvoiceStatus.Closed) {
                revert OutstandingInvoiceExists();
            }
        }

        uint256 invoiceId = nextInvoiceId++;

        Invoice memory invoice = Invoice({
            id: invoiceId,
            companyOwner: msg.sender,
            invoiceAmount: _invoiceAmount,
            dueDate: _dueDate,
            numberOfInvestors: _numberOfInvestors,
            invoice: _invoice,
            status: InvoiceStatus.Open
        });

        invoices[invoiceId] = invoice;

        companyInvoiceIds[msg.sender].push(invoiceId);

        emit InvoiceCreated(invoiceId, msg.sender);
    }

    function changeOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "Invalid owner");
        owner = _owner;
    }

    function getCompany(
        address _companyOwner
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            uint16,
            bool
        )
    {
        Company storage company = companies[_companyOwner];

        return (
            company.companyName,
            company.companyOwnerName,
            company.description,
            company.proofOfIdentity,
            company.foundingYear,
            company.exists
        );
    }

    function getCompanyOwners() public view returns (address[] memory) {
        return companyOwners;
    }

    function getCompanyInvoiceIds(
        address _companyOwner
    ) public view returns (uint256[] memory) {
        return companyInvoiceIds[_companyOwner];
    }

    function getCompanyInvoiceCount(
        address _companyOwner
    ) public view returns (uint256) {
        return companyInvoiceIds[_companyOwner].length;
    }

    function getInvoice(
        uint256 _invoiceId
    ) public view returns (Invoice memory) {
        if (_invoiceId >= nextInvoiceId) {
            revert InvalidInvoice();
        }

        return invoices[_invoiceId];
    }
}
