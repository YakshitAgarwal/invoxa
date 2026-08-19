import { CircleCheckBig } from "lucide-react";

const CTASection = () => {
  const points = [
    {
      heading: "Transparent Financing",
      description: "Track funding, repayments, and invoice status on-chain.",
    },
    {
      heading: "Earn From Real-World Assets",
      description:
        "Investors can fund invoices and earn returns backed by business receivables.",
    },
    {
      heading: "Verified Invoices",
      description:
        "Invoices are verified before being made available for funding.",
    },
  ];

  return (
    <div>
      <div className="text-black bg-white py-24 px-34 flex justify-center items-center gap-20">
        <div>Image</div>
        <div>
          <div className="font-semibold text-[42px]">
            Turn Outstanding Invoices Into Working Capital
          </div>
          <div className="text-gray-500 text-[18px] my-4">
            Get access to cash faster while investors earn returns by funding
            verified business invoices.
          </div>
          <div className="flex flex-col gap-6">
            {points.map(({ heading, description }) => (
              <div className="flex gap-4 items-start" key={heading}>
                <div className="mt-1">
                  <CircleCheckBig />
                </div>
                <div className="flex flex-col gap-1">
                  <div className="font-semibold text-[24px]">{heading}</div>
                  <div className="text-gray-500 text-[18px]">{description}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <div className="text-white bg-[#003237] py-24 px-34 flex flex-col justify-center items-center gap-8">
        <div className="font-semibold text-[42px]">
          Put Your Receivables to Work
        </div>
        <div className="flex flex-col justify-center items-center mb-6 text-[18px] text-gray-300">
          <p>
            Unlock liquidity for your business or invest in verified invoices
          </p>
          <p>through a transparent on-chain marketplace.</p>
        </div>
        <div>
          <a
            href="/signup"
            className="text-[#003237] bg-[#d0ffc6] py-4 px-6 rounded-full cursor-pointer font-semibold"
          >
            Get Started
          </a>
        </div>
      </div>
    </div>
  );
};

export default CTASection;
