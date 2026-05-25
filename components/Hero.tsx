"use client";

import { Play, Info, Plus, Check } from "lucide-react";
import { MediaItem } from "@/lib/mock-data";
import Link from "next/link";
import { motion } from "framer-motion";
import { useMyList } from "@/hooks/use-my-list";

interface HeroProps {
  movie: MediaItem;
}

export default function Hero({ movie }: HeroProps) {
  const { isInList, toggleMyList } = useMyList();

  return (
    <div className="relative h-[85vh] w-full lg:h-[95vh]">
      {/* Background Image */}
      <div className="absolute inset-0">
        <img
          src={movie.backdrop_path}
          alt={movie.title}
          className="h-full w-full object-cover"
        />
        <div className="hero-gradient absolute inset-0" />
        <div className="side-gradient absolute inset-0 hidden lg:block" />
      </div>

      {/* Content */}
      <div className="relative flex h-full flex-col justify-center px-4 md:px-12 lg:w-1/2">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="space-y-4"
        >
          <div className="flex items-center gap-2">
            <span className="rounded-sm bg-primary/20 px-2 py-0.5 text-xs font-bold text-primary border border-primary/30">
              TOP 10
            </span>
            <span className="text-sm font-semibold text-zinc-300">
              #1 in Movies Today
            </span>
          </div>

          <h1 className="text-4xl font-extrabold tracking-tight md:text-6xl lg:text-7xl">
            {movie.title}
          </h1>

          <p className="max-w-xl text-sm text-zinc-300 line-clamp-3 md:text-lg">
            {movie.overview}
          </p>

          <div className="flex flex-wrap items-center gap-3 pt-4">
            <Link
              href={`/watch/${movie.type}/${movie.id}`}
              className="flex items-center gap-2 rounded-md bg-white px-6 py-2.5 text-sm font-bold text-black transition hover:bg-white/90 md:px-8 md:text-base"
            >
              <Play className="h-5 w-5 fill-current" />
              Play Now
            </Link>
            <button 
              onClick={() => toggleMyList(movie)}
              className="flex items-center gap-2 rounded-md bg-zinc-500/30 px-6 py-2.5 text-sm font-bold backdrop-blur-md transition hover:bg-zinc-500/40 md:px-8 md:text-base"
            >
              {isInList(movie.id) ? <Check className="h-5 w-5" /> : <Plus className="h-5 w-5" />}
              My List
            </button>
            <button className="flex items-center gap-2 rounded-md bg-zinc-500/30 px-4 py-2.5 text-sm font-bold backdrop-blur-md transition hover:bg-zinc-500/40 md:text-base">
              <Info className="h-5 w-5" />
            </button>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
