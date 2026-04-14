export default function Footer() {
  return (
    <footer className="w-full bg-gray-100 border-t border-gray-200 py-6 mt-12 text-center text-sm text-gray-600">
      <div className="mb-2">
        World Class Scholars connects education, creativity, and global community through inclusive learning experiences designed for a more human future.
      </div>
      <nav className="flex flex-wrap justify-center gap-4">
        {[
          "About",
          "Programs",
          "Concept Atlas",
          "Gallery",
          "Leadership",
          "Partnerships",
          "Resources",
          "Contact",
          "FAQ",
          "Privacy",
          "Terms",
          "Accessibility"
        ].map((label) => (
          <a key={label} href={`/${label.toLowerCase().replace(/ /g, "-")}`} className="hover:text-blue-700">
            {label}
          </a>
        ))}
      </nav>
    </footer>
  );
}
