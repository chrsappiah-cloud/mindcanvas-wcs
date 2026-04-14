"use client";

import { useState } from "react";

const PROVIDER_INFO: Record<string, { label: string; badge: string; color: string }> = {
  openai: { label: "OpenAI DALL·E", badge: "OAI", color: "bg-blue-600" },
  honeygen: { label: "HoneyGen", badge: "HNY", color: "bg-yellow-500 text-black" },
  invideo: { label: "Invideo AI", badge: "IVD", color: "bg-purple-600" },
  worldgallery: { label: "World Gallery", badge: "WGA", color: "bg-green-600" },
  stablediffusion: { label: "Stable Diffusion", badge: "SD", color: "bg-gray-700" },
};
import Button from "./Button";


export default function ImageGenerator() {
  const [prompt, setPrompt] = useState("");
  const [provider, setProvider] = useState("openai");
  const [format, setFormat] = useState("jpeg");
  const [imageUrl, setImageUrl] = useState<string | null>(null);
  const [imageBase64, setImageBase64] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastRequest, setLastRequest] = useState<{ prompt: string; provider: string; format: string } | null>(null);

  async function handleGenerate(e?: React.FormEvent) {
    if (e) e.preventDefault();
    setLoading(true);
    setError(null);
    setImageUrl(null);
    setImageBase64(null);
    setLastRequest({ prompt, provider, format });
    try {
      const res = await fetch("/api/generate-image", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt, provider, output_format: format }),
      });
      const data = await res.json();
      if (res.ok) {
        if (provider === "stablediffusion" && data.imageBase64) {
          setImageBase64(data.imageBase64);
        } else if (data.imageUrl) {
          setImageUrl(data.imageUrl);
          // Save to backend
          await fetch("/api/images", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ prompt, imageUrl: data.imageUrl, provider, format }),
          });
        } else {
          setError("No image returned from provider");
        }
      } else {
        setError(data.error || `Failed to generate image (${res.status})`);
      }
    } catch (err: any) {
      setError("Network error. Please check your connection and try again.");
    }
    setLoading(false);
  }

  return (
    <div className="max-w-xl mx-auto mt-8 bg-linear-to-br from-blue-50 to-white p-6 rounded-2xl shadow-lg border border-blue-100">
      <form onSubmit={handleGenerate} className="space-y-4">
        <div>
          <label className="block mb-1 font-semibold text-blue-900">Describe your image</label>
          <input
            type="text"
            className="w-full border border-blue-200 rounded px-3 py-2 focus:ring-2 focus:ring-blue-300 focus:outline-none"
            value={prompt}
            onChange={e => setPrompt(e.target.value)}
            required
            placeholder="e.g. A futuristic classroom with students from around the world"
            disabled={loading}
          />
        </div>
        <div>
          <label className="block mb-1 font-semibold text-blue-900">Image Provider</label>
          <select
            className="w-full border border-blue-200 rounded px-3 py-2 focus:ring-2 focus:ring-blue-300 focus:outline-none"
            value={provider}
            onChange={e => setProvider(e.target.value)}
            disabled={loading}
          >
            <option value="openai">OpenAI DALL·E</option>
            <option value="honeygen">HoneyGen</option>
            <option value="invideo">Invideo AI</option>
            <option value="worldgallery">World Gallery</option>
          </select>
        </div>
        {provider === "stablediffusion" && (
          <div className="mt-2">
            <label className="block mb-1 font-semibold text-blue-900">Image Format</label>
            <select
              className="w-full border border-blue-200 rounded px-3 py-2 focus:ring-2 focus:ring-blue-300 focus:outline-none"
              value={format}
              onChange={e => setFormat(e.target.value)}
              disabled={loading}
            >
              <option value="jpeg">JPEG</option>
              <option value="png">PNG</option>
              <option value="webp">WebP</option>
            </select>
          </div>
        )}
        <Button type="submit" disabled={loading || !prompt}>{loading ? "Generating..." : "Generate Image"}</Button>
      </form>
      {error && (
        <div className="text-red-600 mt-4 text-center">
          <div>{error}</div>
          {lastRequest && (
            <button
              className="mt-2 px-3 py-1 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors text-xs"
              onClick={() => {
                setPrompt(lastRequest.prompt);
                setProvider(lastRequest.provider);
                setFormat(lastRequest.format);
                handleGenerate();
              }}
            >
              Retry
            </button>
          )}
        </div>
      )}
      <div className="mt-6 text-center min-h-105 flex items-center justify-center">
        {loading && (
          <div className="w-100 h-100 bg-linear-to-br from-blue-100 to-blue-200 animate-pulse rounded shadow flex items-center justify-center">
            <span className="text-blue-400 font-semibold">Generating image...</span>
          </div>
        )}
        {!loading && (imageBase64 || imageUrl) && (
          <div className="relative inline-block">
            {imageBase64 ? (
              <img
                src={`data:image/${format};base64,${imageBase64}`}
                alt="Generated"
                className="mx-auto rounded shadow max-w-full max-h-100"
              />
            ) : (
              <img src={imageUrl!} alt="Generated" className="mx-auto rounded shadow max-w-full max-h-100" />
            )}
            {/* Provider badge */}
            <span
              className={`absolute top-2 left-2 px-2 py-1 rounded text-xs font-bold shadow ${PROVIDER_INFO[provider]?.color || 'bg-gray-500'}`}
              title={PROVIDER_INFO[provider]?.label}
            >
              {PROVIDER_INFO[provider]?.badge || provider}
            </span>
            {/* Format badge (for SD) */}
            {provider === 'stablediffusion' && (
              <span className="absolute top-2 right-2 px-2 py-1 rounded text-xs font-semibold bg-white/80 text-gray-700 border border-gray-200 shadow">
                {format.toUpperCase()}
              </span>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
