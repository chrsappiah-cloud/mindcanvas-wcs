import { NextRequest, NextResponse } from 'next/server';
export async function POST(req: NextRequest) {
  const { prompt, provider = 'openai', output_format = 'jpeg' } = await req.json();
  if (!prompt) {
    return NextResponse.json({ error: 'Prompt is required' }, { status: 400 });
  }

  try {
    if (provider === 'openai') {
      const apiKey = process.env.OPENAI_API_KEY;
      if (!apiKey) {
        return NextResponse.json({ error: 'OpenAI API key not set' }, { status: 500 });
      }
      const response = await fetch('https://api.openai.com/v1/images/generations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
          prompt,
          n: 1,
          size: '1024x1024',
          response_format: 'url',
        }),
      });
      const data = await response.json();
      if (!response.ok) {
        return NextResponse.json({ error: data.error?.message || 'OpenAI error' }, { status: 500 });
      }
      return NextResponse.json({ imageUrl: data.data[0].url });
    } else if (provider === 'stablediffusion') {
      const apiKey = process.env.STABILITY_API_KEY;
      if (!apiKey) {
        return NextResponse.json({ error: 'Stability API key not set' }, { status: 500 });
      }
      // Prepare form data
      const formData = new FormData();
      formData.append('prompt', prompt);
      formData.append('output_format', output_format);

      const response = await fetch('https://api.stability.ai/v2beta/stable-image/generate/sd3', {
        method: 'POST',
        headers: {
          'authorization': `Bearer ${apiKey}`,
          'accept': 'application/json',
        },
        body: formData as any,
      });
      const data = await response.json();
      if (!response.ok) {
        return NextResponse.json({ error: data.error?.message || 'Stability AI error' }, { status: 500 });
      }
      // The image is returned as base64 in data.artifacts[0].base64
      if (data.artifacts && data.artifacts[0]?.base64) {
        return NextResponse.json({ imageBase64: data.artifacts[0].base64, format: output_format });
      } else {
        return NextResponse.json({ error: 'No image returned from Stability AI' }, { status: 500 });
      }
    } else if (provider === 'honeygen') {
      // TODO: Replace with real HoneyGen API integration
      return NextResponse.json({ imageUrl: 'https://placehold.co/600x600?text=HoneyGen+Image' });
    } else if (provider === 'invideo') {
      // TODO: Replace with real Invideo AI API integration
      return NextResponse.json({ imageUrl: 'https://placehold.co/600x600?text=Invideo+AI+Image' });
    } else if (provider === 'worldgallery') {
      // TODO: Replace with real World Gallery API integration
      return NextResponse.json({ imageUrl: 'https://placehold.co/600x600?text=World+Gallery+Image' });
    } else {
      return NextResponse.json({ error: 'Unknown provider' }, { status: 400 });
    }
  } catch (err) {
    return NextResponse.json({ error: 'Failed to generate image' }, { status: 500 });
  }
}
