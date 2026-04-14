"use client";
import { MediaUpload, RealtimeDemo } from "@memorylab/ui";
import { useState } from "react";

export default function GalleryClient({ media, notifications, userRole, userId }: any) {
  // Moderation actions
  async function moderate(mediaId: string, action: string) {
    await fetch("/api/gallery-media", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ action, mediaId }),
    });
  }
  // Comment action
  async function addComment(mediaId: string, comment: string) {
    await fetch("/api/gallery-media", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ mediaId, comment }),
    });
  }
  // UI state for modal and filters
  const [modalMedia, setModalMedia] = useState<any>(null);
  const [sort, setSort] = useState("desc");
  const [filterUploader, setFilterUploader] = useState("");
  const [commentInputs, setCommentInputs] = useState<{ [mediaId: string]: string }>({});

  // Sort and filter media
  let displayMedia = media.filter((m: any) => m.approved);
  if (filterUploader) {
    displayMedia = displayMedia.filter((m: any) => (m.uploader?.name || m.uploader?.email || "").toLowerCase().includes(filterUploader.toLowerCase()));
  }
  displayMedia = [...displayMedia].sort((a: any, b: any) => sort === "desc" ? new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime() : new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());

  return (
    <main className="min-h-screen p-8 flex flex-col items-center">
      <h1 className="text-2xl font-bold mb-4">Gallery</h1>
      <p className="text-gray-700 mb-8">Curated approved artworks and stories.</p>
      {notifications.length > 0 && (
        <div className="mb-4 w-full max-w-xl">
          <h2 className="font-bold text-green-700">Notifications</h2>
          <ul className="list-disc ml-6 text-green-700">
            {notifications.map((n: any) => (
              <li key={n.id}>{n.message}</li>
            ))}
          </ul>
        </div>
      )}
      {/* Filter and sort controls */}
      <div className="flex gap-4 mb-4 w-full max-w-xl">
        <input
          className="border rounded px-2 py-1 text-sm flex-1"
          placeholder="Filter by uploader..."
          value={filterUploader}
          onChange={e => setFilterUploader(e.target.value)}
        />
        <select className="border rounded px-2 py-1 text-sm" value={sort} onChange={e => setSort(e.target.value)}>
          <option value="desc">Newest</option>
          <option value="asc">Oldest</option>
        </select>
      </div>
      <div className="w-full max-w-4xl flex flex-col gap-12 items-center">
        {userRole === "staff" && <MediaUpload />}
        <RealtimeDemo />
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 mt-8 w-full">
          {displayMedia.map((m: any) => (
            <div
              key={m.id}
              className="relative group bg-gradient-to-br from-white to-blue-50 border border-gray-100 rounded-2xl shadow-xl hover:shadow-2xl transition-all duration-300 flex flex-col items-center p-4 overflow-hidden"
            >
              {/* Avatar */}
              <div className="absolute left-4 top-4 w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold text-lg shadow-lg border-2 border-white">
                {(m.uploader?.name || m.uploader?.email || "U").slice(0,2).toUpperCase()}
              </div>
              <img
                src={m.url}
                alt="gallery"
                className="w-56 h-56 object-cover rounded-xl mb-3 cursor-pointer border-4 border-white group-hover:scale-105 group-hover:border-blue-400 transition-all duration-300 shadow-md"
                onClick={() => setModalMedia(m)}
              />
              <span className="text-xs text-gray-500 mb-1">Uploaded {new Date(m.createdAt).toLocaleString()}</span>
              {m.uploader && (
                <span className="text-xs text-blue-700 font-semibold mb-2">By: {m.uploader.name || m.uploader.email}</span>
              )}
              {/* Comments */}
              <div className="mt-2 w-full bg-blue-50 rounded-lg p-2">
                <h4 className="font-semibold text-xs mb-1 text-blue-900">Comments</h4>
                <div className="flex flex-col gap-1">
                  {m.comments.map((c: any) => (
                    <div key={c.id} className="text-xs text-gray-800 bg-white rounded px-2 py-1 flex items-center gap-2">
                      <span className="font-bold text-blue-700">{c.user?.name || c.user?.email || "U"}:</span>
                      <span>{c.text}</span>
                      <span className="text-gray-400 text-[10px]">{new Date(c.createdAt).toLocaleString()}</span>
                    </div>
                  ))}
                </div>
                {/* Add comment */}
                <form
                  className="flex gap-2 mt-2"
                  onSubmit={e => {
                    e.preventDefault();
                    addComment(m.id, commentInputs[m.id] || "");
                    setCommentInputs(inputs => ({ ...inputs, [m.id]: "" }));
                  }}
                >
                  <input
                    className="border rounded px-2 py-1 text-xs flex-1"
                    placeholder="Add a comment..."
                    value={commentInputs[m.id] || ""}
                    onChange={e => setCommentInputs(inputs => ({ ...inputs, [m.id]: e.target.value }))}
                  />
                  <button type="submit" className="bg-blue-600 text-white px-2 py-1 rounded text-xs">Comment</button>
                </form>
              </div>
              {/* Moderation actions */}
              {userRole === "admin" && (
                <div className="flex gap-2 mt-2">
                  <button onClick={() => moderate(m.id, "hide")} className="text-xs bg-yellow-200 px-2 py-1 rounded">Hide</button>
                  <button onClick={() => moderate(m.id, "delete")} className="text-xs bg-red-200 px-2 py-1 rounded">Delete</button>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
      {/* Modal for media preview */}
      {modalMedia && (
        <div className="fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50" onClick={() => setModalMedia(null)}>
          <div className="bg-white rounded-xl shadow-2xl p-6 max-w-lg w-full relative" onClick={e => e.stopPropagation()}>
            <img src={modalMedia.url} alt="modal" className="w-full h-96 object-contain rounded mb-4" />
            <button className="absolute top-2 right-2 text-gray-600 hover:text-red-500 text-xl font-bold" onClick={() => setModalMedia(null)}>&times;</button>
            <div className="text-xs text-gray-700 mt-2">Uploaded {new Date(modalMedia.createdAt).toLocaleString()}</div>
            {modalMedia.uploader && (
              <div className="text-xs text-blue-700 font-semibold">By: {modalMedia.uploader.name || modalMedia.uploader.email}</div>
            )}
          </div>
        </div>
      )}
    </main>
  );
}
