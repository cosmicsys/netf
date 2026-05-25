"use client";

import { MediaItem } from "@/lib/mock-data";
import { Play, Plus, ChevronDown, ThumbsUp, Check } from "lucide-react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { useMyList } from "@/hooks/use-my-list";

interface MovieCardProps {
  movie: MediaItem;
}

export default function MovieCard({ movie }: MovieCardProps) {
  const [isHovered, setIsHovered] = useState(false);
  const { isInList, toggleMyList } = useMyList();

  return (
    <div
      className="relative h-[28vw] min-w-[45vw] cursor-pointer md:h-[12vw] md:min-w-[20vw]"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img
        src={movie.backdrop_path}
        alt={movie.title}
        className="h-full w-full rounded-md object-cover transition duration-300"
      />

      <AnimatePresence>
        {isHovered && (
          <motion.div
            initial={{ opacity: 0, scale: 0.8, y: -20 }}
            animate={{ opacity: 1, scale: 1.1, y: -40 }}
            exit={{ opacity: 0, scale: 0.8, y: -20 }}
            className="glass absolute inset-x-0 top-0 z-50 w-full rounded-md shadow-2xl"
          >
            <img
              src={movie.backdrop_path}
              alt={movie.title}
              className="h-[15vw] w-full rounded-t-md object-cover"
            />
            <div className="p-3 space-y-3">
              <div className="flex items-center gap-2">
                <Link
                  href={`/watch/${movie.type}/${movie.id}`}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-white transition hover:bg-zinc-200"
                >
                  <Play className="h-4 w-4 fill-black text-black" />
                </Link>
                <button 
                  onClick={() => toggleMyList(movie)}
                  className="flex h-8 w-8 items-center justify-center rounded-full border-2 border-zinc-500 transition hover:border-white"
                >
                  {isInList(movie.id) ? <Check className="h-4 w-4" /> : <Plus className="h-4 w-4" />}
                </button>
                <button className="flex h-8 w-8 items-center justify-center rounded-full border-2 border-zinc-500 transition hover:border-white">
                  <ThumbsUp className="h-4 w-4" />
                </button>
                <button className="ml-auto flex h-8 w-8 items-center justify-center rounded-full border-2 border-zinc-500 transition hover:border-white">
                  <ChevronDown className="h-4 w-4" />
                </button>
              </div>

              <div className="flex items-center gap-2 text-[10px] font-bold md:text-xs">
                <span className="text-green-400">{(movie.vote_average * 10).toFixed(0)}% Match</span>
                <span className="border border-zinc-500 px-1 text-zinc-400">
                  {movie.type === "movie" ? "Movie" : "TV"}
                </span>
                <span className="text-zinc-400">{movie.release_date.split("-")[0]}</span>
              </div>

              <div className="flex flex-wrap gap-1">
                {movie.genres.map((genre) => (
                  <span key={genre} className="text-[10px] text-zinc-300">
                    • {genre}
                  </span>
                ))}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
