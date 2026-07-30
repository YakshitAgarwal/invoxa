import Navbar from "./Navbar";
import {
  FileText,
  Wallet,
  WavesHorizontal,
  Receipt,
  Landmark,
  Sparkles,
} from "lucide-react";

const HomePage = () => {
  return (
    <div>
      <div className="py-8 px-34 text-black">
        <div>
          <Navbar />
        </div>
        <div className="mt-20">
          <div className="flex justify-evenly items-center">
            <div className="relative">
              <div className="absolute top-36 left-10">
                <div className="bg-[#d0ffc6] p-3 rounded-full inline-flex items-center justify-center">
                  <FileText size={24} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-10 left-4">
                <div className="bg-[#d0ffc6] p-3 rounded-full inline-flex items-center justify-center">
                  <Sparkles size={24} className="text-[#003237]" />
                </div>
              </div>
              <div className="absolute top-[-40px] right-12">
                <div className="border border-[#003237] p-3 rounded-full inline-flex items-center justify-center">
                  <Landmark size={24} className="text-[#003237]" />
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
            <button className="text-[#d0ffc6] bg-[#003237] py-3 px-6 rounded-full cursor-pointer">
              Get Started
            </button>
            <button className="text-[#003237] border-1 border-black bg-white py-3 px-6 rounded-full cursor-pointer">
              Learn more
            </button>
          </div>
          <div className="mt-8 flex justify-center items-end gap-10">
            <div className="border border-black rounded-2xl w-70 h-90"></div>
            <div className="border border-black rounded-2xl w-50 h-65"></div>
            <div className="border border-black rounded-2xl w-70 h-50"></div>
            <div className="border border-black rounded-2xl w-50 h-65"></div>
            <div className="border border-black rounded-2xl w-70 h-90"></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
