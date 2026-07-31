const Navbar = () => {
  const tabs = [
    { name: "Home", route: "/" },
    { name: "About", route: "/about" },
    { name: "Services", route: "/services" },
    { name: "Contact", route: "/contact" },
  ];

  return (
    <div className="flex justify-between items-center">
      <a
        className="flex gap-2 justify-center items-center cursor-pointer"
        href="/"
      >
        <div>Logo</div>
        <div className="text-[32px] font-semibold">Invoxa</div>
      </a>

      <div>
        <ul className="flex justify-center items-center gap-16">
          {tabs.map(({ name, route }) => (
            <li
              key={route}
              className="
                relative
                cursor-pointer
                text-[18px]
                font-medium
                after:absolute
                after:left-0
                after:-bottom-1
                after:h-[2px]
                after:w-full
                after:bg-black
                after:origin-left
                after:scale-x-0
                after:transition-transform
                after:duration-300
                hover:after:scale-x-100
              "
            >
              <a href={route}>{name}</a>
            </li>
          ))}
        </ul>
      </div>

      <div>
        <a
          href="/signup"
          className="bg-[#003237] text-white py-4 px-6 rounded-full cursor-pointer"
        >
          Sign Up
        </a>
      </div>
    </div>
  );
};

export default Navbar;
