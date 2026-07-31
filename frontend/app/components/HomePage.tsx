import Navbar from "./Navbar";
import Card from "./Card";
import {
  FileText,
  Wallet,
  WavesHorizontal,
  Receipt,
  Landmark,
  Sparkles,
  DollarSign,
  BadgeCheck,
  ShieldCheck,
  Coins,
} from "lucide-react";

const HomePage = () => {
  return (
    <div>
      <div className="py-8 px-34 text-black min-h-screen">
        <div>
          <Navbar />
        </div>
        <div className="mt-20">
          <div className="flex justify-evenly items-center">
            <div className="relative">
              <div className="absolute top-40 left-10">
                <div className="bg-[#d0ffc6] p-3 rounded-full inline-flex items-center justify-center">
                  <FileText size={24} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-20 right-18">
                <div className="bg-[#003237] p-3 rounded-full inline-flex items-center justify-center">
                  <Sparkles size={24} className="text-white" />
                </div>
              </div>
              <div className="absolute top-[-100px] right-2">
                <div className="bg-[#d0ffc6] p-3 rounded-full inline-flex items-center justify-center">
                  <Landmark size={28} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-[-40px] left-20">
                <div className="border border-[#003237] p-3 rounded-full inline-flex items-center justify-center">
                  <DollarSign size={24} className="text-[#003237]" />
                </div>
              </div>
            </div>
            <div>
              <div className="flex flex-col justify-center items-center text-[64px] font-semibold leading-[1.25]">
                <h1 className="[word-spacing:8px]">Unlock Instant Cash Flow</h1>
                <h1 className="[word-spacing:8px]">with Invoice Factoring</h1>
              </div>
              <div className="flex flex-col justify-center items-center text-[22px] py-8">
                <h1>
                  Connecting businesses with global investors through tokenized
                  invoices
                </h1>
                <h1>and transparent blockchain-powered financing.</h1>
              </div>
            </div>
            <div className="relative">
              <div className="absolute top-16 left-30">
                <div className="bg-[#d0ffc6] p-3 rounded-full inline-flex items-center justify-center">
                  <Wallet size={28} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-36 right-10">
                <div className="p-3 border-[#003237] border rounded-full inline-flex items-center justify-center">
                  <WavesHorizontal size={24} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-[-80px]">
                <div className="p-3 bg-[#003237] rounded-full inline-flex items-center justify-center">
                  <Receipt size={30} className="text-white" />
                </div>
              </div>
            </div>
          </div>
          <div className="flex justify-center items-center gap-12 mt-6">
            <a
              href="/signup"
              className="text-[#d0ffc6] bg-[#003237] py-3 px-6 rounded-full cursor-pointer"
            >
              Get Started
            </a>
            <a
              href="/about"
              className="text-[#003237] border-1 border-black bg-white py-3 px-6 rounded-full cursor-pointer"
            >
              Learn more
            </a>
          </div>
          <div className="mt-8 flex justify-center items-end gap-10">
            <div className="rounded-2xl w-82 h-90 bg-white"></div>
            <div className="rounded-2xl w-61 h-65 bg-[#003237]"></div>
            <div className="rounded-2xl w-82 h-50 bg-white"></div>
            <div className="rounded-2xl w-61 h-65 bg-[#d0ffc6]"></div>
            <div className="rounded-2xl w-82 h-90 bg-[#003237]"></div>
          </div>
        </div>
      </div>
      <div className="text-white bg-[#003237] min-h-screen py-12 px-34">
        <div className="flex flex-col justify-center items-center gap-4">
          <div className="flex flex-col items-center justify-center text-[44px] font-semibold leading-[1.15]">
            <h1>Everything You Need</h1>
            <h1>to Finance Invoices</h1>
          </div>
          <div className="text-[20px]">
            Empower your business with instant liquidity while enabling
            investors to fund verified invoices securely.
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
    </div>
  );
};

export default HomePage;
