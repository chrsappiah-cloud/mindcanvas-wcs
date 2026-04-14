import { promises as fs } from 'fs';
import path from 'path';

export default async function AboutPage() {
  const filePath = path.join(process.cwd(), 'content/en/about.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <span className="text-sm text-blue-700 font-semibold uppercase tracking-wide">{data.hero.eyebrow}</span>
      <h1 className="text-4xl font-bold mt-2 mb-4">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.originStory.heading}</h2>
        <p>{data.originStory.body}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.howItWorks.heading}</h2>
        <p>{data.howItWorks.body}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.values.heading}</h2>
        <ul className="list-disc pl-6">
          {data.values.blocks.map((block: any, i: number) => (
            <li key={i} className="mb-2">
              <strong>{block.title}:</strong> {block.desc}
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-2">{data.whyNow.heading}</h2>
        <p>{data.whyNow.body}</p>
      </section>
    </main>
  );
}
