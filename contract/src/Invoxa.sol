//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Invoxa {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Invoice {
        uint64 invoiceAmount;
        uint64 paymentPeriod;
        uint64 numberOfInvestors;
        string invoice;
    }

    struct Company {
        string companyName;
        string description;
        string proofOfId;
        uint64 foundingYear;
    }

    Invoice[] invoices;
    Company[] companies;

    mapping(string => Invoice) public invoiceMap;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function registerCompany(
        string memory _companyName,
        string memory _description,
        string memory _proofOfId,
        uint64 _foundingYear
    ) public {
        Company memory company = Company({
            companyName: _companyName,
            description: _description,
            proofOfId: _proofOfId,
            foundingYear: _foundingYear
        });

        companies.push(company);
    }

    function registerInvoice(
        uint64 _invoiceAmount,
        uint64 _paymentPeriod,
        uint64 _numberOfInvestors,
        string memory _invoice
    ) public {
        Invoice memory invoice = Invoice({
            invoiceAmount: _invoiceAmount,
            paymentPeriod: _paymentPeriod,
            numberOfInvestors: _numberOfInvestors,
            invoice: _invoice
        });

        invoices.push(invoice);
    }

    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
}
