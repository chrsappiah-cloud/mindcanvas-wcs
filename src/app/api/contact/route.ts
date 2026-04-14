import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  if (req.method !== 'POST') {
    return NextResponse.json({ error: 'Method not allowed' }, { status: 405 });
  }
  let data;
  try {
    data = await req.json();
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });
  }
  // Basic validation
  if (!data.name || !data.email || !data.message) {
    return NextResponse.json({ error: 'Missing required fields' }, { status: 400 });
  }
  // Simple honeypot for spam bots
  if (data._gotcha) {
    return NextResponse.json({ success: true });
  }
  // TODO: Send email or save to DB
  return NextResponse.json({ success: true });
}
