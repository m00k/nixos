import requests
import os
import sys
import json

def search_easynews(query):
    user = os.getenv("EASY_USER")
    password = os.getenv("EASY_PASS")
    
    # Logic for size fallback (in bytes: 1GB = 1073741824)
    # Check if query looks like a TV show (contains S01, E01, or 'Season')
    is_tv = any(x in query.upper() for x in ["S0", "E0", "SEASON", "EPISODE"])
    
    if is_tv:
        thresholds = [3 * 1024**3, 1 * 1024**3, 300 * 1024**2]
    else:
        thresholds = [8 * 1024**3, 3 * 1024**3, 1 * 1024**3]

    base_url = "https://members.easynews.com/2.0/search/solr-search/"
    
    for min_size in thresholds:
        params = {
            "fly": "2",
            "gps": query,
            "pby": "100", # Results per page
            "s1": "dsize", # Sort by size
            "s1d": "-",    # Descending (biggest first)
            "b1t": min_size, # Minimum size in bytes
            "st": "adv",
            "sb": "1"
        }
        
        try:
            r = requests.get(base_url, params=params, auth=(user, password), timeout=15)
            r.raise_for_status()
            data = r.json()
            
            results = data.get("data", [])
            if not results:
                continue # Try next size threshold
            
            output = []
            for item in results[:5]: # Top 5
                # Using the JSON keys from your example
                fn = item.get("fn", "Unknown Filename")
                size_str = item.get("4", "Unknown Size")
                res = item.get("fullres", "Unknown Res")
                v_codec = item.get("vcodec", "Unknown")
                # Construct the direct download link
                # sig and sid are required for direct download via the API
                dl_url = f"https://members.easynews.com/dl/{item.get('id')}/{item.get('hash')}"
                
                output.append({
                    "label": f"{fn} [{res}] [{v_codec}] - {size_str}",
                    "url": dl_url
                })
            return output
            
        except Exception as e:
            return f"Search Error: {str(e)}"
            
    return "No results found even after lowering size requirements."

if __name__ == "__main__":
    search_query = sys.argv[1]
    final_results = search_easynews(search_query)
    if isinstance(final_results, list):
        print(json.dumps(final_results))
    else:
        print(final_results)