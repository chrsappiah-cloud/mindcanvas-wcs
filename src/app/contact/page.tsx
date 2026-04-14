
import { promises as fs } from 'fs';
import path from 'path';
import dynamic from 'next/dynamic';


const ContactForm = dynamic(() => import("../../components/ContactForm"), { ssr: false });

export default async function ContactPage() {
  const filePath = path.join(process.cwd(), 'content/en/contact.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));

  return (
    <main className="max-w-3xl mx-auto py-12 px-4">
      <h1 className="text-4xl font-bold mb-2">{data.hero.headline}</h1>
      <p className="text-lg mb-8">{data.hero.subheading}</p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-2">{data.intro.heading}</h2>
        <p>{data.intro.body}</p>
      </section>

      <section>
        <h3 className="text-xl font-semibold mb-2">Enquiry Categories</h3>
        <ul className="list-disc pl-6 mb-2">
          {data.enquiryCategories.map((item: string, i: number) => (
            <li key={i}>{item}</li>
          ))}
        </ul>
      </section>

      <ContactForm />
    </main>
  );
}
