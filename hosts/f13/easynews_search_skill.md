# Easynews Advanced Search

**Description:** Use this to find high-quality movies or TV shows on Easynews using Solr JSON API.

**Steps:**

1. Determine if the user is looking for a Movie or a TV Show based on the title.
2. Run: `python3 @SCRIPT_PATH@ "{{KEYWORDS}}"`
3. The script returns a JSON list of results.
4. **Formatting:** Display the results as a numbered list to the user. Include the filename, resolution, and size.
5. **Selection:** Ask the user: "Which one should I grab for you?"

**Constraint:** If the script returns "No results found," suggest that the user tries a different spelling or check if the media is too new.
