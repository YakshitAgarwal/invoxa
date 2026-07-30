import { LucideIcon, ArrowUpRight } from "lucide-react";

interface CardProps {
  icon: LucideIcon;
  heading: string;
  detail: string;
}

const Card = ({ icon: Icon, heading, detail }: CardProps) => {
  return (
    <div className="bg-[#003f44] w-full h-80 p-10 text-white rounded-2xl flex flex-col justify-between">
      <div className="flex justify-between items-center">
        <Icon size={48} />

        <ArrowUpRight size={32} />
      </div>

      <div className="flex flex-col gap-2">
        <h2 className="text-[32px] font-semibold">{heading}</h2>
        <p className="text-gray-300 text-[18px]">{detail}</p>
      </div>
    </div>
  );
};

export default Card;
