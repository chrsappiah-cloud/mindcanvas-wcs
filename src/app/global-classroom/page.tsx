import { promises as fs } from 'fs';
import path from 'path';
import GlobalClassroomClient from './GlobalClassroomClient';

export default async function GlobalClassroomPage() {
  const filePath = path.join(process.cwd(), 'content/en/global-classroom.json');
  const data = JSON.parse(await fs.readFile(filePath, 'utf-8'));
  return <GlobalClassroomClient data={data} />;
}
