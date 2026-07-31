import Navbar from "../components/Navbar";

const About = () => {
  return (
    <div className="py-8 px-34 text-black min-h-screen bg-[#f3f9f7]">
      <div>
        <Navbar />
      </div>
      <div className="flex flex-col gap-2 justify-center items-center mt-20">
        <h1 className="text-[44px] font-semibold underline">About</h1>
        <p>
          Lorem, ipsum dolor sit amet consectetur adipisicing elit. Labore
          tenetur dolorem, perspiciatis nihil mollitia, fuga explicabo ad
          dolores, illo non quae reiciendis asperiores quibusdam ullam culpa
          voluptas ex harum unde?
        </p>
      </div>
    </div>
  );
};

export default About;
