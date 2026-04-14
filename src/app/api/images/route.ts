import { NextRequest, NextResponse } from 'next/server';
import { promises as fs } from 'fs';
import path from 'path';

const DATA_FILE = path.join(process.cwd(), 'content', 'shared', 'generated-images.json');

async function readImages() {
  try {
    const data = await fs.readFile(DATA_FILE, 'utf-8');
    return JSON.parse(data);
  } catch {
    return [];
  }
}

async function saveImages(images: any[]) {
  await fs.writeFile(DATA_FILE, JSON.stringify(images, null, 2), 'utf-8');
}


export async function GET() {
  const images = await readImages();
  return NextResponse.json(images);
}

export async function POST(req: NextRequest) {
  const { prompt, imageUrl, provider, format } = await req.json();
  if (!prompt || !imageUrl) {
    return NextResponse.json({ error: 'Missing prompt or imageUrl' }, { status: 400 });
  }
  const images = await readImages();
  images.unshift({ prompt, imageUrl, provider: provider || null, format: format || null, created: Date.now() });
  if (images.length > 50) images.length = 50; // Keep only latest 50
  await saveImages(images);
  return NextResponse.json({ success: true });
}
