import Hero from "@/components/Hero";
import MovieRow from "@/components/MovieRow";
import { mockData, categories } from "@/lib/mock-data";

export default function Home() {
  const featured = mockData[0]; // Interstellar

  return (
    <div className="relative pb-24 lg:pb-48">
      <Hero movie={featured} />
      
      <section className="relative -mt-32 space-y-12 md:-mt-48 lg:space-y-24">
        {categories.map((category) => (
          <MovieRow 
            key={category.title} 
            title={category.title} 
            movies={category.items} 
          />
        ))}
      </section>
    </div>
  );
}
