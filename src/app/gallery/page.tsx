import { promises as fs } from 'fs';
import path from 'path';
import dynamic from 'next/dynamic';

const ImageGenerator = dynamic(() => import('../../components/ImageGenerator'), { ssr: false });

export default async function GalleryPage() {
  const filePath = path.join(process.cwd(), 'content/en/gallery.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-4xl font-bold mb-2">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section>
        <h2 className="text-2xl font-semibold mb-2">{data.intro.heading}</h2>
        <p>{data.intro.body}</p>
        <button className="mt-4 px-4 py-2 bg-blue-700 text-white rounded">{data.intro.cta}</button>
      </section>

      <section className="mt-12">
        <h2 className="text-2xl font-semibold mb-4">Try AI Image Generation</h2>
        <ImageGenerator />
      </section>
    </main>
  );
}
