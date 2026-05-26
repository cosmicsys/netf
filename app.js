const VIDSRC_BASE = "https://vidsrc.fyi";
const VIDSRC_API = "https://vidsrc.fyi/vapi";

// TMDB API Config (Using a common public key for demo purposes, or user can replace)
const TMDB_KEY = "8265b3e0965444b045e054173815048d";
const TMDB_BASE = "https://api.themoviedb.org/3";
const TMDB_IMG = "https://image.tmdb.org/t/p/w500";

// DOM Elements
const navbar = document.getElementById('navbar');
const playerModal = document.getElementById('playerModal');
const vidsrcIframe = document.getElementById('vidsrc-iframe');
const tvControls = document.getElementById('tv-controls');
const seasonInput = document.getElementById('seasonInput');
const episodeInput = document.getElementById('episodeInput');
const searchInput = document.getElementById('searchInput');
const searchResults = document.getElementById('search-results');
const searchList = document.getElementById('search-list');
const mainContent = document.getElementById('content-rows');
const heroSection = document.getElementById('hero');

let currentPlayerId = "";
let currentPlayerType = "movie";

// Search on Enter key
searchInput.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    event.preventDefault();
    handleSearch();
  }
});

// Scroll Effect for Navbar
window.addEventListener('scroll', () => {
    if (window.scrollY > 100) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// Initialization
async function init() {
    await fetchCategory('movie', 'new-releases');
    await fetchCategory('movie', 'recently-added-movies', 'add');
    await fetchCategory('tv', 'latest-tv', 'new');
}

async function handleSearch() {
    const query = searchInput.value.trim();
    if (!query) return;

    if (query.startsWith('tt')) {
        openPlayer(query, 'movie');
        return;
    }

    // Search by Name using TMDB
    try {
        const response = await fetch(`${TMDB_BASE}/search/multi?api_key=${TMDB_KEY}&query=${encodeURIComponent(query)}`);
        const data = await response.json();
        
        if (data.results && data.results.length > 0) {
            displaySearchResults(data.results, query);
        } else {
            alert("No results found for: " + query);
        }
    } catch (error) {
        console.error("Search error:", error);
        alert("Error searching for movie.");
    }
}

function displaySearchResults(results, query) {
    document.getElementById('search-query-title').innerText = `Search Results for: ${query}`;
    searchList.innerHTML = '';
    searchResults.style.display = 'block';
    heroSection.style.display = 'none';
    mainContent.style.display = 'none';

    results.forEach(item => {
        if (item.media_type !== 'movie' && item.media_type !== 'tv') return;
        
        const card = document.createElement('div');
        card.className = 'movie-card';
        card.style.minWidth = '180px';
        card.style.margin = '10px';
        
        const posterUrl = item.poster_path ? `${TMDB_IMG}${item.poster_path}` : `https://picsum.photos/seed/${item.id}/200/115`;
        const title = item.title || item.name;
        
        card.innerHTML = `
            <img src="${posterUrl}" alt="${title}">
            <div class="movie-info-overlay">
                <p>${title}</p>
                <p>${item.media_type.toUpperCase()}</p>
            </div>
        `;
        
        card.onclick = () => openPlayer(item.id, item.media_type);
        searchList.appendChild(card);
    });
}

function closeSearch() {
    searchResults.style.display = 'none';
    heroSection.style.display = 'flex';
    mainContent.style.display = 'block';
    searchInput.value = '';
}

async function fetchCategory(type, containerId, subType = 'new') {
    const container = document.getElementById(containerId) || document.getElementById('new-releases');
    container.innerHTML = '<p style="padding: 20px;">Loading...</p>';

    try {
        const response = await fetch(`${VIDSRC_API}/${type}/${subType}`);
        const data = await response.json();

        if (data && data.result) {
            renderMovies(data.result, containerId, type);
            if (containerId === 'new-releases' && data.result[0]) {
                updateHero(data.result[0], type);
            }
        } else {
            container.innerHTML = '<p style="padding: 20px;">No content found.</p>';
        }
    } catch (error) {
        console.error("Error fetching data:", error);
        container.innerHTML = '<p style="padding: 20px;">Error loading content.</p>';
    }
}

function updateHero(item, type) {
    const heroTitle = document.getElementById('heroTitle');
    const heroDescription = document.getElementById('heroDescription');
    const id = item.imdb_id || item.tmdb_id;
    
    heroTitle.innerText = `Featured ${type === 'movie' ? 'Movie' : 'Show'}: ${id}`;
    heroDescription.innerText = `Stream the latest ${type} in ${item.quality || 'HD'} quality directly on NETF using VidSrc infrastructure.`;
    
    const playBtn = document.querySelector('.play-btn');
    playBtn.onclick = () => openPlayer(id, type);
}

function renderMovies(movies, containerId, type) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';

    movies.forEach(item => {
        const id = item.imdb_id || item.tmdb_id;
        if (!id) return;

        const card = document.createElement('div');
        card.className = 'movie-card';
        
        // Using a varied placeholder image
        const posterUrl = `https://picsum.photos/seed/${id}/200/115`;
        
        card.innerHTML = `
            <img src="${posterUrl}" alt="${id}">
            <div class="movie-info-overlay">
                <p>${type.toUpperCase()}: ${id}</p>
                <p>Quality: ${item.quality || 'HD'}</p>
            </div>
        `;
        
        card.onclick = () => openPlayer(id, type);
        container.appendChild(card);
    });
}

function openPlayer(id, type) {
    currentPlayerId = id;
    currentPlayerType = type;
    playerModal.style.display = 'block';
    
    if (type === 'tv') {
        tvControls.style.display = 'flex';
        updateTVPlayer();
    } else {
        tvControls.style.display = 'none';
        vidsrcIframe.src = `${VIDSRC_BASE}/embed/movie/${id}`;
    }
}

function updateTVPlayer() {
    const s = seasonInput.value || 1;
    const e = episodeInput.value || 1;
    vidsrcIframe.src = `${VIDSRC_BASE}/embed/tv/${currentPlayerId}/${s}/${e}`;
}

function closePlayer() {
    playerModal.style.display = 'none';
    vidsrcIframe.src = "";
}

function handleSearch() {
    const query = searchInput.value.trim();
    if (!query) return;

    if (query.startsWith('tt') || !isNaN(query)) {
        // Direct ID search
        openPlayer(query, 'movie'); // Default to movie for search
    } else {
        alert("Please enter a valid IMDB ID (e.g., tt17048514) or TMDB ID.");
    }
}

function showHome() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target == playerModal) {
        closePlayer();
    }
}

init();
