import { promises as fs } from 'fs';
import path from 'path';

export default async function ProgramsPage() {
  const filePath = path.join(process.cwd(), 'content/en/programs.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <span className="text-sm text-blue-700 font-semibold uppercase tracking-wide">{data.hero.eyebrow}</span>
      <h1 className="text-4xl font-bold mt-2 mb-4">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section>
        <h2 className="text-2xl font-semibold mb-2">{data.intro.heading}</h2>
        <p>{data.intro.body}</p>
      </section>
    </main>
  );
}
