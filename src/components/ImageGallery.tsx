"use client";


import { useEffect, useState } from "react";

const PROVIDER_INFO: Record<string, { label: string; badge: string; color: string }> = {
  openai: { label: "OpenAI DALL·E", badge: "OAI", color: "bg-blue-600" },
  honeygen: { label: "HoneyGen", badge: "HNY", color: "bg-yellow-500 text-black" },
  invideo: { label: "Invideo AI", badge: "IVD", color: "bg-purple-600" },
  worldgallery: { label: "World Gallery", badge: "WGA", color: "bg-green-600" },
  stablediffusion: { label: "Stable Diffusion", badge: "SD", color: "bg-gray-700" },
};


export default function ImageGallery() {
  const [images, setImages] = useState<{ prompt: string; imageUrl: string; provider?: string; format?: string; created: number }[]>([]);
  const [loading, setLoading] = useState(true);
  const [providerFilter, setProviderFilter] = useState<string | null>(null);
  const [formatFilter, setFormatFilter] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/images")
      .then(res => res.json())
      .then(setImages)
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="mt-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {Array.from({ length: 6 }).map((_, i) => (
          <div key={i} className="bg-linear-to-br from-blue-50 to-white rounded-2xl shadow-lg border border-blue-100 p-4 animate-pulse h-75" />
        ))}
      </div>
    );
  }
  if (!images.length) return <div className="text-center text-gray-400 mt-8">No images yet.</div>;

  // Unique providers and formats for filter pills
  const uniqueProviders = Array.from(new Set(images.map(img => img.provider).filter(Boolean)));
  const uniqueFormats = Array.from(new Set(images.map(img => img.format).filter(Boolean)));

  // Filtered images
  const filteredImages = images.filter(img => {
    if (providerFilter && img.provider !== providerFilter) return false;
    if (formatFilter && img.format !== formatFilter) return false;
    return true;
  });

  return (
    <div className="mt-8">
      {/* Filter bar */}
      <div className="sticky top-0 z-10 bg-white/80 backdrop-blur border-b border-blue-100 mb-6 py-3 px-2 rounded-t-2xl flex flex-wrap gap-2 items-center shadow-sm">
        <span className="font-semibold text-blue-900 mr-2">Filter:</span>
        {/* Provider filter pills */}
        {uniqueProviders.map(p => (
          <button
            key={p}
            className={`px-3 py-1 rounded-full text-xs font-bold border transition-colors ${providerFilter === p ? (PROVIDER_INFO[p]?.color || 'bg-blue-600 text-white') : 'bg-white text-blue-900 border-blue-200 hover:bg-blue-50'}`}
            onClick={() => setProviderFilter(providerFilter === p ? null : p)}
          >
            {PROVIDER_INFO[p]?.badge || p}
          </button>
        ))}
        {/* Format filter pills */}
        {uniqueFormats.map(f => (
          <button
            key={f}
            className={`px-3 py-1 rounded-full text-xs font-semibold border transition-colors ${formatFilter === f ? 'bg-blue-500 text-white' : 'bg-white text-blue-900 border-blue-200 hover:bg-blue-50'}`}
            onClick={() => setFormatFilter(formatFilter === f ? null : f)}
          >
            {f?.toUpperCase()}
          </button>
        ))}
        {(providerFilter || formatFilter) && (
          <button
            className="ml-2 px-3 py-1 rounded-full text-xs font-semibold bg-gray-200 text-gray-700 border border-gray-300 hover:bg-gray-300 transition-colors"
            onClick={() => { setProviderFilter(null); setFormatFilter(null); }}
          >
            Clear
          </button>
        )}
      </div>
      {/* Gallery grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {filteredImages.length === 0 ? (
          <div className="col-span-full text-center text-gray-400 py-12">No images match the selected filters.</div>
        ) : filteredImages.map((img, i) => (
          <div
            key={i}
            className="bg-linear-to-br from-white to-blue-50 rounded-2xl shadow-lg border border-blue-100 p-4 flex flex-col items-center transition-transform hover:scale-105 hover:shadow-xl cursor-pointer group relative"
          >
            <img
              src={img.imageUrl}
              alt={img.prompt}
              className="rounded mb-2 max-h-48 w-full object-cover group-hover:shadow-lg transition-shadow"
              style={{ aspectRatio: '1/1' }}
            />
            {/* Provider badge */}
            {img.provider && (
              <span
                className={`absolute top-3 left-3 px-2 py-1 rounded text-xs font-bold shadow ${PROVIDER_INFO[img.provider]?.color || 'bg-gray-500'}`}
                title={PROVIDER_INFO[img.provider]?.label}
              >
                {PROVIDER_INFO[img.provider]?.badge || img.provider}
              </span>
            )}
            {/* Format badge */}
            {img.provider === 'stablediffusion' && img.format && (
              <span className="absolute top-3 right-3 px-2 py-1 rounded text-xs font-semibold bg-white/80 text-gray-700 border border-gray-200 shadow">
                {img.format.toUpperCase()}
              </span>
            )}
            <div className="text-xs text-gray-700 text-center mt-1 px-1 line-clamp-2">{img.prompt}</div>
          </div>
        ))}
      </div>
    </div>
  );
}
