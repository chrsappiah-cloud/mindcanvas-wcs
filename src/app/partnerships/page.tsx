import { promises as fs } from 'fs';
import path from 'path';

export default async function PartnershipsPage() {
  const filePath = path.join(process.cwd(), 'content/en/partnerships.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-4xl font-bold mb-2">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.whyPartner.heading}</h2>
        <p>{data.whyPartner.body}</p>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-2">{data.partnerTypes.heading}</h2>
        <ul className="list-disc pl-6 mb-2">
          {data.partnerTypes.bullets.map((item: string, i: number) => (
            <li key={i}>{item}</li>
          ))}
        </ul>
        <button className="mt-4 px-4 py-2 bg-blue-700 text-white rounded">{data.partnerTypes.cta}</button>
      </section>
    </main>
  );
}
