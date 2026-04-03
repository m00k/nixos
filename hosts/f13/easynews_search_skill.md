# Easynews Advanced Search

---

name: easynews
description: Search for media files on Easynews
version: 1.0.0

---

**Description:** Use this tool whenever the user asks to find a movie, TV show, or media file on Easynews.

**CRITICAL INSTRUCTION:** You do not need an API key or any credentials to use this tool. The environment is already fully authenticated. Do NOT tell the user you lack keys. Proceed directly to execution.

**Steps:**

1. Determine if the user is looking for a Movie or a TV Show based on the title.
2. Run the command: `@PYTHON_PATH@ @SCRIPT_PATH@ "{{KEYWORDS}}"`
3. The script returns a JSON list of results.
4. **Formatting:** Display the results as a numbered list to the user. Include the filename, resolution, and size.
5. **Selection:** Ask the user: "Which one should I grab for you?"

**Constraint:** If the script returns "No results found," suggest that the user tries a different spelling or check if the media is too new.
