import Navbar from "./Navbar";
import Footer from "./Footer";
import LandingPage from "./LandingPage";
import HeroSection from "./HeroSection";
import CTASection from "./CTASection";

const HomePage = () => {
  return (
    <div>
      <div className="py-8 px-34 text-black min-h-screen">
        <div>
          <Navbar />
        </div>
        <div className="mt-20">
          <LandingPage />
        </div>
      </div>
      <div className="text-white bg-[#003237] min-h-screen py-12 px-34">
        <HeroSection />
      </div>
      <div>
        <CTASection />
      </div>
      <div className="text-white bg-black py-16 px-34">
        <Footer />
      </div>
    </div>
  );
};

export default HomePage;
