export interface MediaItem {
  id: string; // IMDB or TMDB ID
  tmdb_id?: string;
  imdb_id?: string;
  type: "movie" | "tv";
  title: string;
  overview: string;
  poster_path: string;
  backdrop_path: string;
  vote_average: number;
  release_date: string;
  genres: string[];
}

export const mockData: MediaItem[] = [
  {
    id: "tt17048514",
    tmdb_id: "927085",
    imdb_id: "tt17048514",
    type: "movie",
    title: "Interstellar",
    overview: "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.",
    poster_path: "https://image.tmdb.org/t/p/w500/gEU2QniE6EwfVnz6z2YwUjU6o0u.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/rAiDLKRaqS87P68WfLpB3Z59C39.jpg",
    vote_average: 8.4,
    release_date: "2014-11-05",
    genres: ["Adventure", "Drama", "Sci-Fi"]
  },
  {
    id: "tt0133093",
    tmdb_id: "603",
    imdb_id: "tt0133093",
    type: "movie",
    title: "The Matrix",
    overview: "Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.",
    poster_path: "https://image.tmdb.org/t/p/w500/f89U3Y9S7zV2G2eB5S9UI86X3zJ.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/550.jpg", // Placeholder
    vote_average: 8.7,
    release_date: "1999-03-31",
    genres: ["Action", "Sci-Fi"]
  },
  {
    id: "tt0944947",
    tmdb_id: "1399",
    imdb_id: "tt0944947",
    type: "tv",
    title: "Game of Thrones",
    overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north.",
    poster_path: "https://image.tmdb.org/t/p/w500/7WsyChvRStv9OidaxPqyAF7Q7qc.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/2OMB0ynYNEvBBSsU5nS70Z67fDy.jpg",
    vote_average: 8.4,
    release_date: "2011-04-17",
    genres: ["Sci-Fi & Fantasy", "Drama", "Action & Adventure"]
  },
  {
    id: "tt0816692",
    tmdb_id: "157336",
    imdb_id: "tt0816692",
    type: "movie",
    title: "The Dark Knight",
    overview: "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets.",
    poster_path: "https://image.tmdb.org/t/p/w500/qJ2tW69uS7p3mP6SAyUMK1s5pXq.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/nMKdUUtnkb1p9TAdv90O9096pPre.jpg",
    vote_average: 9.0,
    release_date: "2008-07-16",
    genres: ["Drama", "Action", "Crime", "Thriller"]
  },
  {
    id: "tt1877830",
    tmdb_id: "119450",
    imdb_id: "tt1877830",
    type: "movie",
    title: "The Batman",
    overview: "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler.",
    poster_path: "https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onun.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/5P8BM4qMvXygs9vOqCkrDfypOn4.jpg",
    vote_average: 7.7,
    release_date: "2022-03-01",
    genres: ["Crime", "Mystery", "Thriller"]
  },
  {
    id: "tt0903747",
    tmdb_id: "1396",
    imdb_id: "tt0903747",
    type: "tv",
    title: "Breaking Bad",
    overview: "Walter White, a chemistry teacher, discovers that he has cancer and decides to get into the meth-making business to repay his medical debts. His priorities begin to change when he partners with Jesse.",
    poster_path: "https://image.tmdb.org/t/p/w500/ztkUQvBZ19vT6pSww3JjCllN9yD.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/9fa9pGv9sqp9p9p9p9p9p9p9p9p.jpg",
    vote_average: 8.9,
    release_date: "2008-01-20",
    genres: ["Drama", "Crime"]
  },
  {
    id: "tt1475582",
    tmdb_id: "447332",
    imdb_id: "tt1475582",
    type: "movie",
    title: "A Quiet Place",
    overview: "A family is forced to live in silence while hiding from creatures that hunt by sound.",
    poster_path: "https://image.tmdb.org/t/p/w500/n3191h961p36m6B6Setq9S6nNDM.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/6ovEA6Zp6fUcnYv9S8yLw6p6fS8.jpg",
    vote_average: 7.4,
    release_date: "2018-04-03",
    genres: ["Horror", "Sci-Fi", "Drama"]
  },
  {
    id: "tt0468569",
    tmdb_id: "155",
    imdb_id: "tt0468569",
    type: "movie",
    title: "The Dark Knight",
    overview: "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
    poster_path: "https://image.tmdb.org/t/p/w500/qJ2tW69uS7p3mP6SAyUMK1s5pXq.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/o73U2uWp3ABG7S6879pSJh1qCLr.jpg",
    vote_average: 8.5,
    release_date: "2008-07-16",
    genres: ["Drama", "Action", "Crime", "Thriller"]
  },
  {
    id: "tt0110912",
    tmdb_id: "680",
    imdb_id: "tt0110912",
    type: "movie",
    title: "Pulp Fiction",
    overview: "A burger-loving hitman, his philosophical partner, a drug-addled gangster's moll and a washed-up boxer converge in this sprawling, comedic crime caper. Their adventures unfurl in three stories that weave in and out of each other.",
    poster_path: "https://image.tmdb.org/t/p/w500/d5iIl9h9FvS68UsH07sIslpC6ZJ.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/suaYU5vU36mBkhLp9N6uC3XpDga.jpg",
    vote_average: 8.9,
    release_date: "1994-09-10",
    genres: ["Crime", "Thriller"]
  },
  {
    id: "tt0111161",
    tmdb_id: "278",
    imdb_id: "tt0111161",
    type: "movie",
    title: "The Shawshank Redemption",
    overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden.",
    poster_path: "https://image.tmdb.org/t/p/w500/q6y0GoS0v5YvSUnpS9pW9S6fST5.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/iNh3191h961p36m6B6Setq9S6nNDM.jpg",
    vote_average: 9.3,
    release_date: "1994-09-23",
    genres: ["Drama", "Crime"]
  },
  {
    id: "tt1375666",
    tmdb_id: "27205",
    imdb_id: "tt1375666",
    type: "movie",
    title: "Inception",
    overview: "Cobb, a skilled thief who steals valuable secrets from deep within the subconscious during the dream state, is offered a chance at redemption if he can successfully perform an inception: planting an idea rather than stealing one.",
    poster_path: "https://image.tmdb.org/t/p/w500/9gk7Fn9sVAsS9696G1o3oP0mP0m.jpg",
    backdrop_path: "https://image.tmdb.org/t/p/original/s3TBrjDWh6S6Zjs46NI6CwwvIHG.jpg",
    vote_average: 8.4,
    release_date: "2010-07-15",
    genres: ["Action", "Sci-Fi", "Adventure"]
  }
];

export const categories = [
  { title: "Trending Now", items: mockData.slice(0, 4) },
  { title: "Action Hits", items: mockData.filter(m => m.genres.includes("Action")) },
  { title: "Sci-Fi Favorites", items: mockData.filter(m => m.genres.includes("Sci-Fi")) },
  { title: "Crime Dramas", items: mockData.filter(m => m.genres.includes("Crime")) },
];
