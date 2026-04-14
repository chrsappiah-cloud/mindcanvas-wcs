"use client";
import dynamic from "next/dynamic";

const ImageGenerator = dynamic(() => import("./ImageGenerator"), { ssr: false });

export default function ImageGeneratorClient() {
  return <ImageGenerator />;
}
