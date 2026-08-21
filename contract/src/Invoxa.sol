// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Invoxa {
    address public owner;
    uint256 nextInvoiceId;
    uint256 public constant RETURN_RATE = 150;
    uint256 public constant PLATFORM_FEE_BPS = 100;
    uint256 private totalPlatformFees;
    uint256 private reserveBalance;

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
        PartiallyFunded,
        FullyFunded,
        Repaid,
        Closed,
        Expired
    }

    enum TimeToPayment {
        Thirty,
        Sixty,
        Ninety
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
        uint256 amount;
        uint256 totalTokens;
        uint256 tokensSold;
        string documentCID;
        uint256 fundingDeadline;
        uint256 investorsCount;
        uint256 investorsClaimed;
        TimeToPayment timeToPayment;
        InvoiceStatus status;
    }

    struct Investor {
        string name;
        bool exists;
    }

    struct Investment {
        uint256 invoiceId;
        uint256 tokensOwned;
        bool claimed;
    }

    mapping(address => Company) public companies;

    address[] public companyOwners;

    mapping(uint256 => Invoice) public invoices;

    mapping(address => uint256[]) public companyInvoiceIds;

    mapping(address => Investor) public investors;

    mapping(address => Investment[]) public investments;

    mapping(uint256 => mapping(address => uint256))
        public invoiceTokenOwnership;

    function registerCompany(
        string memory _companyName,
        string memory _ownerName,
        string memory _description,
        string memory _proofOfIdentity,
        uint16 _foundingYear
    ) public {
        require(!companies[msg.sender].exists, "Company already registered");
        require(bytes(_companyName).length > 0, "Invalid company name");
        require(bytes(_ownerName).length > 0, "Invalid owner name");
        require(bytes(_description).length > 0, "Invalid description");
        require(bytes(_proofOfIdentity).length > 0, "Invalid proof");

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
        uint256 _amount,
        uint256 _totalTokens,
        string memory _documentCID,
        uint16 dueIn
    ) public onlyCompanyOwner {
        TimeToPayment timeToPayment;
        uint256 fundingPeriod;

        if (dueIn == 30) {
            timeToPayment = TimeToPayment.Thirty;
            fundingPeriod = 5 days;
        } else if (dueIn == 60) {
            timeToPayment = TimeToPayment.Sixty;
            fundingPeriod = 10 days;
        } else if (dueIn == 90) {
            timeToPayment = TimeToPayment.Ninety;
            fundingPeriod = 15 days;
        } else {
            revert("Invalid Time to Payment");
        }

        uint256[] storage ids = companyInvoiceIds[msg.sender];

        if (ids.length > 0) {
            Invoice storage previousInvoice = invoices[ids[ids.length - 1]];
            require(
                previousInvoice.status == InvoiceStatus.Closed ||
                    previousInvoice.status == InvoiceStatus.Expired,
                "Outstanding invoice exists"
            );
        }

        require(_amount > 0, "Invalid amount");
        require(_totalTokens > 0, "Invalid token count");
        require(
            _amount % _totalTokens == 0,
            "Amount must be divisible by token count"
        );
        require(bytes(_documentCID).length > 0, "Invalid document CID");

        Invoice memory invoice = Invoice({
            id: nextInvoiceId,
            companyOwner: msg.sender,
            amount: _amount,
            totalTokens: _totalTokens,
            tokensSold: 0,
            documentCID: _documentCID,
            fundingDeadline: block.timestamp + fundingPeriod,
            investorsCount: 0,
            investorsClaimed: 0,
            timeToPayment: timeToPayment,
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
        uint256 _tokensBought
    ) public payable onlyInvestor {
        Invoice storage invoice = invoices[_id];

        require(_id < nextInvoiceId, "Invalid invoice id");
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
        require(
            block.timestamp <= invoice.fundingDeadline,
            "Funding period has ended"
        );

        uint256 amountToCompany = (4 * msg.value) / 5;
        reserveBalance += msg.value / 5;

        (bool sent, ) = invoice.companyOwner.call{value: amountToCompany}("");
        require(sent, "Failed to send ether to company");

        invoice.tokensSold += _tokensBought;

        Investment memory investment = Investment({
            invoiceId: _id,
            tokensOwned: _tokensBought,
            claimed: false
        });

        investments[msg.sender].push(investment);

        if (invoiceTokenOwnership[_id][msg.sender] == 0) {
            invoice.investorsCount++;
        }

        invoiceTokenOwnership[_id][msg.sender] += _tokensBought;

        if (invoice.tokensSold == invoice.totalTokens) {
            invoice.status = InvoiceStatus.FullyFunded;
        }
    }

    function finalizeInvoice(uint256 _invoiceId) public {
        require(_invoiceId < nextInvoiceId, "Invalid invoice ID");

        Invoice storage invoice = invoices[_invoiceId];

        require(
            block.timestamp > invoice.fundingDeadline,
            "Funding period is still active"
        );
        require(
            invoice.status == InvoiceStatus.Open,
            "Invoice already finalized"
        );

        if (invoice.tokensSold == 0) {
            invoice.status = InvoiceStatus.Expired;
        } else {
            invoice.status = InvoiceStatus.PartiallyFunded;
        }
    }

    function repayInvoice(uint256 invoiceId) public payable onlyCompanyOwner {
        Invoice storage invoice = invoices[invoiceId];

        require(
            invoice.status == InvoiceStatus.FullyFunded ||
                (invoice.status == InvoiceStatus.PartiallyFunded &&
                    block.timestamp > invoice.fundingDeadline),
            "Invoice is not ready for repayment"
        );
        require(invoice.companyOwner == msg.sender, "Not the invoice owner");

        uint256 fundedAmount = (invoice.tokensSold * invoice.amount) /
            invoice.totalTokens;

        uint256 companyPrincipal = (80 * fundedAmount) / 100;

        uint256 investorReturn = (fundedAmount *
            getReturnRate(invoice.timeToPayment)) / 10_000;

        uint256 platformFee = (fundedAmount * PLATFORM_FEE_BPS) / 10_000;

        uint256 amountToBePaid = companyPrincipal +
            investorReturn +
            platformFee;

        require(msg.value == amountToBePaid, "Incorrect repayment amount");

        totalPlatformFees += platformFee;

        invoice.status = InvoiceStatus.Repaid;
    }

    function claimPayment() public onlyInvestor {
        uint256 totalPayment;

        for (uint256 i = 0; i < investments[msg.sender].length; i++) {
            Investment storage investment = investments[msg.sender][i];

            if (investment.claimed) {
                continue;
            }

            Invoice storage invoice = invoices[investment.invoiceId];

            if (invoice.status != InvoiceStatus.Repaid) {
                continue;
            }

            uint256 tokensBought = investment.tokensOwned;
            uint256 perTokenAmount = invoice.amount / invoice.totalTokens;

            uint256 principal = tokensBought * perTokenAmount;
            uint256 investorReturn = (principal *
                getReturnRate(invoice.timeToPayment)) / 10_000;

            uint256 amountReceivable = principal + investorReturn;

            totalPayment += amountReceivable;

            investment.claimed = true;

            invoice.investorsClaimed++;

            if (invoice.investorsCount == invoice.investorsClaimed) {
                invoice.status = InvoiceStatus.Closed;
            }
        }

        require(totalPayment > 0, "Nothing to claim");

        (bool sent, ) = msg.sender.call{value: totalPayment}("");
        require(sent, "Payment failed");
    }

    function getReturnRate(
        TimeToPayment _timeToPayment
    ) private pure returns (uint256) {
        uint256 returnRateBps;

        if (_timeToPayment == TimeToPayment.Thirty) {
            returnRateBps = RETURN_RATE; // 150 = 1.5%
        } else if (_timeToPayment == TimeToPayment.Sixty) {
            returnRateBps = RETURN_RATE * 2; // 300 = 3%
        } else {
            returnRateBps = RETURN_RATE * 3; // 450 = 4.5%
        }

        return returnRateBps;
    }

    function changeOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "Invalid owner");
        owner = _owner;
    }

    function viewReserveBalance() public view onlyOwner returns (uint256) {
        return reserveBalance;
    }

    function viewTotalPlatformFees() public view onlyOwner returns (uint256) {
        return totalPlatformFees;
    }

    function withdrawPlatformFees() public onlyOwner {
        uint256 amount = totalPlatformFees;

        require(amount > 0, "No platform fees");

        totalPlatformFees = 0;

        (bool sent, ) = owner.call{value: amount}("");
        require(sent, "Withdrawal failed");
    }
}
