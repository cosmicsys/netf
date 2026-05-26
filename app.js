const VIDSRC_BASE = "https://vidsrc.fyi";
const VIDSRC_API = "https://vidsrc.fyi/vapi";
const TMDB_KEY = "8265b3e0965444b045e054173815048d";
const TMDB_BASE = "https://api.themoviedb.org/3";
const TMDB_IMG = "https://image.tmdb.org/t/p/w500";
const TMDB_BACKDROP = "https://image.tmdb.org/t/p/original";

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

// Initialization
async function init() {
    // Initial fetch to get IDs from VidSrc, then we'll enrich with TMDB
    await fetchAndEnrich('movie', 'new-releases', 'new');
    await fetchAndEnrich('movie', 'recently-added-movies', 'add');
    await fetchAndEnrich('tv', 'latest-tv', 'new');
    
    // Featured Hero - Trending Movie
    fetchTrendingHero();
}

async function fetchTrendingHero() {
    try {
        const res = await fetch(`${TMDB_BASE}/trending/movie/day?api_key=${TMDB_KEY}`);
        const data = await res.json();
        if (data.results && data.results[0]) {
            updateHeroUI(data.results[0]);
        }
    } catch (e) { console.error("Hero fetch error", e); }
}

function updateHeroUI(item) {
    const hero = document.getElementById('hero');
    const title = document.getElementById('heroTitle');
    const desc = document.getElementById('heroDescription');
    const playBtn = document.querySelector('.play-btn');
    
    hero.style.backgroundImage = `url(${TMDB_BACKDROP}${item.backdrop_path})`;
    title.innerText = item.title || item.name;
    desc.innerText = item.overview;
    playBtn.onclick = () => openPlayer(item.id, 'movie');
}

async function fetchAndEnrich(type, containerId, subType) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    try {
        const vRes = await fetch(`${VIDSRC_API}/${type}/${subType}`);
        const vData = await vRes.json();
        
        if (vData.result) {
            // Take first 10 for performance and enrich
            const items = vData.result.slice(0, 12);
            container.innerHTML = '';
            
            for (const item of items) {
                const id = item.imdb_id || item.tmdb_id;
                enrichAndAppend(id, type, container);
            }
        }
    } catch (e) { console.error(e); }
}

async function enrichAndAppend(id, type, container) {
    try {
        const res = await fetch(`${TMDB_BASE}/${type}/${id}?api_key=${TMDB_KEY}`);
        const data = await res.json();
        if (data.id) {
            const card = createMovieCard(data, type);
            container.appendChild(card);
        }
    } catch (e) {
        // Fallback for items not in TMDB or API failures
        const fallbackCard = createFallbackCard(id, type);
        container.appendChild(fallbackCard);
    }
}

function createMovieCard(item, type) {
    const card = document.createElement('div');
    card.className = 'movie-card';
    const title = item.title || item.name;
    const imgUrl = item.backdrop_path ? `${TMDB_IMG}${item.backdrop_path}` : `${TMDB_IMG}${item.poster_path}`;
    
    card.innerHTML = `
        <img src="${imgUrl}" alt="${title}" loading="lazy">
        <div class="movie-info-overlay">
            <div class="movie-title">${title}</div>
            <div class="movie-meta">
                <span>98% Match</span>
                <span class="quality">4K</span>
                <span>${new Date(item.release_date || item.first_air_date).getFullYear()}</span>
            </div>
        </div>
    `;
    card.onclick = () => openPlayer(item.id, type);
    return card;
}

function createFallbackCard(id, type) {
    const card = document.createElement('div');
    card.className = 'movie-card';
    card.innerHTML = `
        <div style="padding: 20px; text-align: center;">${id}</div>
        <div class="movie-info-overlay"><div class="movie-title">${type.toUpperCase()}</div></div>
    `;
    card.onclick = () => openPlayer(id, type);
    return card;
}

// Search Logic
async function handleSearch() {
    const query = searchInput.value.trim();
    if (!query) return;

    if (query.startsWith('tt')) {
        openPlayer(query, 'movie');
        return;
    }

    try {
        const res = await fetch(`${TMDB_BASE}/search/multi?api_key=${TMDB_KEY}&query=${encodeURIComponent(query)}`);
        const data = await res.json();
        if (data.results) {
            displaySearchResults(data.results, query);
        }
    } catch (e) { console.error(e); }
}

function displaySearchResults(results, query) {
    document.getElementById('search-query-title').innerText = `Results for: ${query}`;
    searchList.innerHTML = '';
    searchResults.style.display = 'block';
    heroSection.style.display = 'none';
    mainContent.style.display = 'none';

    results.forEach(item => {
        if (item.media_type !== 'movie' && item.media_type !== 'tv') return;
        const card = createMovieCard(item, item.media_type);
        searchList.appendChild(card);
    });
}

function closeSearch() {
    searchResults.style.display = 'none';
    heroSection.style.display = 'flex';
    mainContent.style.display = 'block';
    searchInput.value = '';
}

// Player
function openPlayer(id, type) {
    currentPlayerId = id;
    currentPlayerType = type;
    playerModal.style.display = 'block';
    document.body.style.overflow = 'hidden';
    
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
    document.body.style.overflow = 'auto';
}

// Event Listeners
window.addEventListener('scroll', () => {
    if (window.scrollY > 50) navbar.classList.add('scrolled');
    else navbar.classList.remove('scrolled');
});

searchInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") handleSearch();
});

window.onclick = (e) => {
    if (e.target == playerModal) closePlayer();
}

init();
