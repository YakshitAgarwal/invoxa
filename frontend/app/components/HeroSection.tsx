import Card from "./Card";
import {
  FileText,
  Wallet,
  Landmark,
  BadgeCheck,
  ShieldCheck,
  Coins,
} from "lucide-react";

const HeroSection = () => {
  return (
    <div>
      <div className="flex flex-col justify-center items-center gap-4">
        <div className="flex flex-col items-center justify-center text-[44px] font-semibold leading-[1.15]">
          <h1>Everything You Need</h1>
          <h1>to Finance Invoices</h1>
        </div>
        <div className="text-[20px]">
          Empower your business with instant liquidity while enabling investors
          to fund verified invoices securely.
        </div>
      </div>
      <div className="mt-14 grid grid-cols-3 gap-10">
        <Card
          icon={FileText}
          heading="Invoice Tokenization"
          detail="Convert unpaid invoices into secure on-chain assets that are ready for funding."
        />
        <Card
          icon={Wallet}
          heading="Instant Liquidity"
          detail="Receive working capital within hours instead of waiting weeks for invoice payments."
        />
        <Card
          icon={ShieldCheck}
          heading="Verified Businesses"
          detail="Every invoice is verified before it reaches the marketplace, reducing fraud and increasing trust."
        />
        <Card
          icon={Landmark}
          heading="Investor Marketplace"
          detail="Browse and invest in verified invoices to earn returns backed by real-world assets."
        />
        <Card
          icon={Coins}
          heading="Transparent Payments"
          detail="Track funding, repayments, and invoice status in real time on the blockchain."
        />
        <Card
          icon={BadgeCheck}
          heading="Smart Contract Security"
          detail="Automated settlement and transparent ownership powered by audited smart contracts."
        />
      </div>
    </div>
  );
};

export default HeroSection;
