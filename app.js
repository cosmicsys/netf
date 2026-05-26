const VIDSRC_BASE = "https://vidsrc.fyi";
const VIDSRC_API = "https://vidsrc.fyi/vapi";

// DOM Elements
const navbar = document.getElementById('navbar');
const playerModal = document.getElementById('playerModal');
const vidsrcIframe = document.getElementById('vidsrc-iframe');
const tvControls = document.getElementById('tv-controls');
const seasonInput = document.getElementById('seasonInput');
const episodeInput = document.getElementById('episodeInput');
const searchInput = document.getElementById('searchInput');

let currentPlayerId = "";
let currentPlayerType = "movie";

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

async function fetchCategory(type, containerId, subType = 'new') {
    const container = document.getElementById(containerId) || document.getElementById('new-releases');
    container.innerHTML = '<p style="padding: 20px;">Loading...</p>';

    try {
        const response = await fetch(`${VIDSRC_API}/${type}/${subType}`);
        const data = await response.json();

        if (data && data.result) {
            renderMovies(data.result, containerId, type);
        } else {
            container.innerHTML = '<p style="padding: 20px;">No content found.</p>';
        }
    } catch (error) {
        console.error("Error fetching data:", error);
        container.innerHTML = '<p style="padding: 20px;">Error loading content.</p>';
    }
}

function renderMovies(movies, containerId, type) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';

    movies.forEach(item => {
        const id = item.imdb_id || item.tmdb_id;
        if (!id) return;

        const card = document.createElement('div');
        card.className = 'movie-card';
        
        // Using a placeholder image since VidSrc API doesn't provide posters directly in the 'new' feed usually
        // We'll try to use a placeholder or a common poster service if possible
        const posterUrl = `https://images.unsplash.com/photo-1594908900066-3f47337549d8?q=80&w=2070&auto=format&fit=crop`;
        
        card.innerHTML = `
            <img src="${posterUrl}" alt="${id}">
            <div class="movie-info-overlay">
                <p>ID: ${id}</p>
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
