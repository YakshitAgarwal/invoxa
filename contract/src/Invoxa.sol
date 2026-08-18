// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Invoxa {
    address public owner;
    uint256 nextInvoiceId;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyCompanyOwner() {
        require(companies[msg.sender].exists == true, "Not a company owner");
        _;
    }

    modifier onlyInvestor() {
        require(investors[msg.sender].exists == true, "Not an investor");
        _;
    }

    enum InvoiceStatus {
        Open,
        Funded,
        Repaid,
        Closed
    }

    struct Company {
        address companyOwner;
        string companyName;
        string ownerName;
        string description;
        string proofOfIdentity;
        uint16 foundingYear;
        bool exists;
    }

    struct Invoice {
        uint256 id;
        address companyOwner;
        uint64 amount;
        uint64 totalTokens;
        uint64 tokensSold;
        uint64 dueDate;
        string documentCID;
        InvoiceStatus status;
    }

    struct Investor {
        string name;
        bool exists;
    }

    struct Investment {
        uint256 invoiceId;
        uint64 tokensOwned;
        bool claimed;
    }

    mapping(address => Company) public companies;

    address[] public companyOwners;

    mapping(uint256 => Invoice) public invoices;

    mapping(address => uint256[]) public companyInvoiceIds;

    mapping(address => Investor) public investors;

    mapping(address => Investment[]) public investments;

    mapping(uint256 => mapping(address => uint64)) public invoiceTokenOwnership;

    function registerCompany(
        string memory _companyName,
        string memory _ownerName,
        string memory _description,
        string memory _proofOfIdentity,
        uint16 _foundingYear
    ) public {
        Company memory company = Company({
            companyOwner: msg.sender,
            companyName: _companyName,
            ownerName: _ownerName,
            description: _description,
            proofOfIdentity: _proofOfIdentity,
            foundingYear: _foundingYear,
            exists: true
        });

        companies[msg.sender] = company;

        companyOwners.push(msg.sender);
    }

    function createInvoice(
        uint64 _amount,
        uint64 _totalTokens,
        uint64 _dueDate,
        string memory _documentCID
    ) public onlyCompanyOwner {
        Invoice memory invoice = Invoice({
            id: nextInvoiceId,
            companyOwner: msg.sender,
            amount: _amount,
            totalTokens: _totalTokens,
            tokensSold: 0,
            dueDate: _dueDate,
            documentCID: _documentCID,
            status: InvoiceStatus.Open
        });

        invoices[nextInvoiceId] = invoice;

        companyInvoiceIds[msg.sender].push(nextInvoiceId);

        nextInvoiceId++;
    }

    function registerInvestor(string memory _name) public {
        Investor memory investor = Investor({name: _name, exists: true});

        investors[msg.sender] = investor;
    }

    function buyInvoice(
        uint256 _id,
        uint64 _tokensBought
    ) public payable onlyInvestor {
        Invoice storage invoice = invoices[_id];

        require(_id < nextInvoiceId && _id >= 0, "Invalid invoice id");
        require(_tokensBought > 0, "Cannot buy zero tokens");
        require(
            _tokensBought <= invoice.totalTokens - invoice.tokensSold,
            "Cannot buy more tokens than available"
        );
        require(
            investors[msg.sender].exists == true,
            "You are not a registered investor"
        );
        require(invoice.status == InvoiceStatus.Open, "Invoice is not open");
        require(
            msg.value == _tokensBought * (invoice.amount / invoice.totalTokens),
            "Incorrect amount of ether sent"
        );

        (bool sent, ) = invoice.companyOwner.call{value: msg.value}("");
        require(sent, "Failed to send ether to company");

        invoice.tokensSold += _tokensBought;

        Investment memory investment = Investment({
            invoiceId: _id,
            tokensOwned: _tokensBought,
            claimed: false
        });

        investments[msg.sender].push(investment);

        invoiceTokenOwnership[_id][msg.sender] = _tokensBought;

        if (invoice.tokensSold == invoice.totalTokens) {
            invoice.status = InvoiceStatus.Funded;
        }
    }

    function repayInvoice() public payable onlyCompanyOwner {}

    function chnageOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
}
