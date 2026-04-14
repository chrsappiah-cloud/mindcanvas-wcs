import ImageGenerator from "../components/ImageGenerator";
import ImageGallery from "../components/ImageGallery";

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-white py-8 px-2">
      <h1 className="text-3xl font-bold text-center text-blue-900 mb-6">World-Class Scholars Image Generator</h1>
      <ImageGenerator />
      <ImageGallery />
    </main>
  );
}
