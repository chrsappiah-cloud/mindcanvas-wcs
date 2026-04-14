import { promises as fs } from 'fs';
import path from 'path';
import FutureCareStudioClient from './FutureCareStudioClient';

export default async function FutureCareStudioPage() {
  const filePath = path.join(process.cwd(), 'content/en/future-care-studio.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));
  return <FutureCareStudioClient data={data} />;
}
