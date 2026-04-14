import Link from "next/link";

const navLinks = [
  { href: "/", label: "Home" },
  { href: "/about", label: "About" },
  { href: "/programs", label: "Programs" },
  { href: "/global-classroom", label: "Global Classroom" },
  { href: "/digital-arts-lab", label: "Digital Arts Lab" },
  { href: "/future-care-studio", label: "Future Care Studio" },
  { href: "/innovation-studio", label: "Innovation Studio" },
  { href: "/pattern-library", label: "Pattern Library" },
  { href: "/concept-atlas", label: "Concept Atlas" },
  { href: "/gallery", label: "Gallery" },
  { href: "/leadership", label: "Leadership" },
  { href: "/partnerships", label: "Partnerships" },
  { href: "/resources", label: "Resources" },
  { href: "/contact", label: "Contact" },
  { href: "/faq", label: "FAQ" }
];

export default function Navbar() {
  return (
    <nav className="w-full bg-white border-b border-gray-200 py-3 px-4 flex items-center justify-center sticky top-0 z-50">
      <ul className="flex flex-wrap gap-4 text-sm font-medium">
        {navLinks.map((link) => (
          <li key={link.href}>
            <Link href={link.href} className="hover:text-blue-700 transition-colors">
              {link.label}
            </Link>
          </li>
        ))}
      </ul>
    </nav>
  );
}
