"use client";

import ImageGenerator from "../../components/ImageGenerator";
import ImageGallery from "../../components/ImageGallery";

export default function FutureCareStudioClient({ data }: { data: any }) {
  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-4xl font-bold mb-2">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.whyItMatters.heading}</h2>
        <p>{data.whyItMatters.body}</p>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-2">{data.whatThisWorkIncludes.heading}</h2>
        <ul className="list-disc pl-6 mb-2">
          {data.whatThisWorkIncludes.bullets.map((item: string, i: number) => (
            <li key={i}>{item}</li>
          ))}
        </ul>
        <button className="mt-4 px-4 py-2 bg-blue-700 text-white rounded">{data.whatThisWorkIncludes.cta}</button>
      </section>

      <section className="mt-12">
        <h2 className="text-2xl font-semibold mb-4">Try AI Image Generation</h2>
        <ImageGenerator />
        <h3 className="text-xl font-semibold mt-8 mb-2">Recent Generated Images</h3>
        <ImageGallery />
      </section>
    </main>
  );
}
