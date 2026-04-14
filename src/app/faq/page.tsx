import { promises as fs } from 'fs';
import path from 'path';

export default async function FAQPage() {
  const filePath = path.join(process.cwd(), 'content/en/faq.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-4xl font-bold mb-8">Frequently Asked Questions</h1>
      <ul className="space-y-6">
        {data.questions.map((item: any, i: number) => (
          <li key={i}>
            <h2 className="text-xl font-semibold mb-1">Q: {item.q}</h2>
            <p className="ml-4">A: {item.a}</p>
          </li>
        ))}
      </ul>
    </main>
  );
}
