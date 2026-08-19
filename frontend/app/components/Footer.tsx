import {
  DiscordIcon,
  Linkedin02Icon,
  NewTwitterIcon,
} from "@hugeicons/core-free-icons";
import { HugeiconsIcon } from "@hugeicons/react";

const Footer = () => {
  return (
    <div>
      <div className="flex justify-between items-start">
        <div>
          <a href="/" className="text-[32px] font-semibold">
            Invoxa
          </a>
          <div className="text-gray-400 text-[18px]">
            <p>Invoxa connects businesses seeking liquidity</p>
            <p>with investors funding verified invoices. Fast,</p>
            <p>transparent, and powered by blockchain.</p>
          </div>
        </div>
        <div className="flex justify-start items-start gap-16">
          <div>
            <div className="text-[24px]">Company</div>
            <ul className="text-gray-400 text-[18px] mt-4">
              <li className="my-2">About us</li>
              <li className="my-2">How It Works</li>
              <li className="my-2">Contact</li>
              <li className="my-2">FAQ</li>
            </ul>
          </div>
          <div>
            <div className="text-[24px]">Businesses</div>
            <ul className="text-gray-400 text-[18px] mt-4">
              <li className="my-2">Submit an Invoice</li>
              <li className="my-2">Invoice Financing</li>
              <li className="my-2">Funding Process</li>
              <li className="my-2">Business Dashboard</li>
            </ul>
          </div>
          <div>
            <div className="text-[24px]">Investors</div>
            <ul className="text-gray-400 text-[18px] mt-4">
              <li className="my-2">Marketplace</li>
              <li className="my-2">How Investing Works</li>
              <li className="my-2">Portfolio</li>
              <li className="my-2">Risk & Returns</li>
            </ul>
          </div>
          <div>
            <div className="text-[24px]">Get In Touch</div>
            <ul className="text-gray-400 text-[18px] mt-4">
              <li className="my-2">hello@invoxa.com</li>
            </ul>
            <div className="flex items-center justify-center gap-4 mt-4">
              <HugeiconsIcon icon={Linkedin02Icon} />
              <HugeiconsIcon icon={NewTwitterIcon} />
              <HugeiconsIcon icon={DiscordIcon} />
            </div>
          </div>
        </div>
      </div>
      <hr className="text-gray-400 my-10" />
      <div className="text-gray-400 text-[18px] flex justify-between items-center">
        <div>
          <span>&copy; 2026 Invoxa. All rights reserved.</span>
        </div>
        <div className="flex justify-center items-center gap-4">
          <div>Terms & Conditions</div>
          <div>Privacy Policy</div>
          <div>Risk Disclosure</div>
        </div>
      </div>
    </div>
  );
};

export default Footer;
