"use client";

import { useMyList } from "@/hooks/use-my-list";
import MovieCard from "@/components/MovieCard";

export default function MyListPage() {
  const { myList } = useMyList();

  return (
    <div className="min-h-screen bg-background px-4 pt-32 md:px-12 pb-24">
      <h1 className="mb-8 text-4xl font-bold">My List</h1>

      {myList.length > 0 ? (
        <div className="grid grid-cols-2 gap-y-12 gap-x-4 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6">
          {myList.map((movie) => (
            <div key={movie.id} className="h-auto">
               <MovieCard movie={movie} />
               <div className="mt-2 text-sm font-semibold">{movie.title}</div>
            </div>
          ))}
        </div>
      ) : (
        <div className="flex h-[50vh] flex-col items-center justify-center text-center">
          <p className="text-xl text-zinc-500">You haven&apos;t added any titles to your list yet.</p>
        </div>
      )}
    </div>
  );
} 
