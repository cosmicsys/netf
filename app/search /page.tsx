"use client";

import { useSearchParams } from "next/navigation";
import { mockData } from "@/lib/mock-data";
import MovieCard from "@/components/MovieCard";
import { Suspense } from "react";

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get("q") || "";

  const results = mockData.filter((movie) =>
    movie.title.toLowerCase().includes(query.toLowerCase()) ||
    movie.genres.some(g => g.toLowerCase().includes(query.toLowerCase()))
  );

  return (
    <div className="min-h-screen bg-background px-4 pt-32 md:px-12">
      <div className="mb-8">
        <h1 className="text-2xl text-zinc-400">
          Showing results for: <span className="font-bold text-white">&quot;{query}&quot;</span>
        </h1>
        <p className="mt-2 text-zinc-500">{results.length} titles found</p>
      </div>

      {results.length > 0 ? (
        <div className="grid grid-cols-2 gap-y-12 gap-x-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6">
          {results.map((movie) => (
            <div key={movie.id} className="h-auto">
               <MovieCard movie={movie} />
               <div className="mt-2 text-sm font-semibold">{movie.title}</div>
            </div>
          ))}
        </div>
      ) : (
        <div className="flex h-[40vh] flex-col items-center justify-center text-center">
          <p className="text-xl text-zinc-500">Your search did not have any matches.</p>
          <ul className="mt-4 list-inside list-disc text-sm text-zinc-600">
            <li>Try different keywords</li>
            <li>Looking for a movie or TV show?</li>
            <li>Try using a title or genre</li>
          </ul>
        </div>
      )}
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense fallback={<div className="pt-32 text-center">Loading...</div>}>
      <SearchResults />
    </Suspense>
  );
}
