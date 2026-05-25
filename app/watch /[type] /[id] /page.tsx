"use client";

import { useParams, useRouter } from "next/navigation";
import { mockData } from "@/lib/mock-data";
import { ChevronLeft, ThumbsUp, Plus } from "lucide-react";
import MovieRow from "@/components/MovieRow";

export default function WatchPage() {
  const { type, id } = useParams();
  const router = useRouter();

  const movie = mockData.find((m) => m.id === id);

  if (!movie) {
    return (
      <div className="flex h-screen items-center justify-center bg-background">
        <div className="h-12 w-12 animate-spin rounded-full border-4 border-primary border-t-transparent" />
      </div>
    );
  }

  const recommendations = mockData
    .filter((m) => m.id !== id && m.genres.some((g) => movie.genres.includes(g)))
    .slice(0, 6);

  const embedUrl = type === "movie" 
    ? `https://vidsrc.mov/embed/movie/${id}`
    : `https://vidsrc.mov/embed/tv/${id}/1/1`;

  return (
    <div className="min-h-screen bg-background pt-20">
      {/* Header Info */}
      <div className="px-4 py-4 md:px-12">
        <button
          onClick={() => router.back()}
          className="flex items-center gap-2 text-zinc-400 transition hover:text-white"
        >
          <ChevronLeft className="h-5 w-5" />
          Back to Browse
        </button>
      </div>

      {/* Video Player Container */}
      <div className="relative aspect-video w-full bg-black shadow-2xl lg:px-12">
        <iframe
          src={embedUrl}
          className="h-full w-full"
          allowFullScreen
        />
      </div>

      {/* Movie Details */}
      <div className="mt-8 px-4 md:px-12 lg:mt-12">
        <div className="grid grid-cols-1 gap-12 lg:grid-cols-3">
          <div className="col-span-2 space-y-6">
            <div className="flex flex-wrap items-center gap-4">
              <h1 className="text-3xl font-bold md:text-5xl">{movie.title}</h1>
              <div className="flex items-center gap-2">
                 <span className="text-green-400 font-bold">{(movie.vote_average * 10).toFixed(0)}% Match</span>
                 <span className="text-zinc-400">{movie.release_date.split("-")[0]}</span>
                 <span className="border border-zinc-600 px-2 text-xs text-zinc-400">4K</span>
              </div>
            </div>

            <p className="text-lg text-zinc-300 leading-relaxed">
              {movie.overview}
            </p>

            <div className="flex items-center gap-4">
              <button className="flex items-center gap-2 rounded-full bg-primary px-6 py-2 font-bold transition hover:bg-primary/90">
                <ThumbsUp className="h-5 w-5" />
                I Like This
              </button>
              <button className="flex h-10 w-10 items-center justify-center rounded-full border-2 border-zinc-700 transition hover:border-white">
                <Plus className="h-5 w-5" />
              </button>
            </div>
          </div>

          <div className="space-y-4 text-sm">
            <div>
              <span className="text-zinc-500">Genres: </span>
              <span className="text-zinc-300">{movie.genres.join(", ")}</span>
            </div>
            <div>
              <span className="text-zinc-500">Release Date: </span>
              <span className="text-zinc-300">{movie.release_date}</span>
            </div>
            <div>
              <span className="text-zinc-500">Rating: </span>
              <span className="text-zinc-300">{movie.vote_average} / 10</span>
            </div>
          </div>
        </div>
      </div>

      {/* Recommendations */}
      <div className="mt-16 pb-24">
        <MovieRow title="More Like This" movies={recommendations} />
      </div>
    </div>
  );
}
