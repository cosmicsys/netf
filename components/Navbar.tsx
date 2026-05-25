"use client";

import Link from "next/link";
import { Search, Bell, User, Menu } from "lucide-react";
import { useState, useEffect } from "react";
import { cn } from "@/lib/utils";
import { useRouter } from "next/navigation";

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const router = useRouter();

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      router.push(`/search?q=${encodeURIComponent(searchQuery)}`);
    }
  };

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 0) {
        setIsScrolled(true);
      } else {
        setIsScrolled(false);
      }
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <nav
      className={cn(
        "fixed top-0 z-50 flex w-full items-center justify-between px-4 py-4 transition-all duration-500 lg:px-12",
        isScrolled ? "glass bg-background/80" : "bg-gradient-to-b from-black/70 to-transparent"
      )}
    >
      <div className="flex items-center gap-4 lg:gap-10">
        <Link href="/" className="text-2xl font-bold tracking-tighter text-primary lg:text-3xl">
          VID<span className="text-secondary">STREAM</span>
        </Link>

        <div className="hidden items-center gap-6 text-sm font-medium lg:flex">
          <Link href="/" className="transition hover:text-primary">Home</Link>
          <Link href="/tv-shows" className="transition hover:text-primary">TV Shows</Link>
          <Link href="/movies" className="transition hover:text-primary">Movies</Link>
          <Link href="/new" className="transition hover:text-primary">New & Popular</Link>
          <Link href="/my-list" className="transition hover:text-primary">My List</Link>
        </div>
      </div>

      <div className="flex items-center gap-4 lg:gap-6">
        <form onSubmit={handleSearch} className="flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1.5 transition-all hover:bg-white/10">
          <Search className="h-4 w-4 text-zinc-400" />
          <input
            type="text"
            placeholder="Search..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="bg-transparent text-sm outline-none placeholder:text-zinc-500"
          />
        </form>
        <Bell className="hidden h-5 w-5 cursor-pointer text-zinc-400 transition hover:text-white sm:block" />
        <div className="h-8 w-8 cursor-pointer overflow-hidden rounded-full bg-primary/20 p-1">
            <User className="h-full w-full text-primary" />
        </div>
        <Menu className="h-6 w-6 cursor-pointer lg:hidden" />
      </div>
    </nav>
  );
}
