document.addEventListener("DOMContentLoaded", () => {
    const searchBox = document.getElementById("search-box");
    const searchButton = document.getElementById("search-button");
  
    let timeout = null;
  
    function performSearch() {
      const query = searchBox.value;
  
      if (query) {
        fetch("/searches", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ query: query })
        }).then(() => {
          fetchTopSearches();
        }).catch(error => console.error('Error:', error));
      }
    }
  
    function fetchTopSearches() {
      fetch('/top_searches')
        .then(response => response.json())
        .then(data => {
          const topSearchesList = document.getElementById('top-searches-list');
          topSearchesList.innerHTML = '';
          for (const [query, count] of Object.entries(data)) {
            const li = document.createElement('li');
            li.textContent = `${query} (${count})`;
            topSearchesList.appendChild(li);
          }
        }).catch(error => console.error('Error:', error));
    }
  
    searchBox.addEventListener("input", () => {
      clearTimeout(timeout);
  
      timeout = setTimeout(() => {
        performSearch();
      }, 300);
    });
  
    searchButton.addEventListener("click", () => {
      performSearch();
    });
  
    // Initial fetch of top searches
    fetchTopSearches();
  
    // Periodically fetch top searches
    setInterval(fetchTopSearches, 5000); // Adjust the interval as needed
  });
  