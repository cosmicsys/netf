"use client";

import { useState, useEffect } from "react";
import { MediaItem } from "@/lib/mock-data";

export function useMyList() {
  const [myList, setMyList] = useState<MediaItem[]>([]);

  useEffect(() => {
    const stored = localStorage.getItem("myList");
    if (stored) {
      try {
        const parsed = JSON.parse(stored);
        setTimeout(() => setMyList(parsed), 0);
      } catch (e) {
        console.error("Failed to parse myList", e);
      }
    }
  }, []);

  const addToMyList = (movie: MediaItem) => {
    const updated = [...myList, movie];
    setMyList(updated);
    localStorage.setItem("myList", JSON.stringify(updated));
  };

  const removeFromMyList = (movieId: string) => {
    const updated = myList.filter((m) => m.id !== movieId);
    setMyList(updated);
    localStorage.setItem("myList", JSON.stringify(updated));
  };

  const isInList = (movieId: string) => {
    return myList.some((m) => m.id === movieId);
  };

  const toggleMyList = (movie: MediaItem) => {
    if (isInList(movie.id)) {
      removeFromMyList(movie.id);
    } else {
      addToMyList(movie);
    }
  };

  return { myList, addToMyList, removeFromMyList, isInList, toggleMyList };
} 
