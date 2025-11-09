# nginx-homepage — Portfolio

This repository contains a simple, static portfolio homepage (HTML/CSS/JS) intended to be served by Nginx or opened locally in a browser.

Files added/changed:
- `index.html` — single-page portfolio UI (hero, about, projects, skills, contact)
- `styles.css` — styles for layout and responsive behavior
- `script.js` — small client-side behaviors (nav toggle, smooth scroll, form handler)
- `Dockerfile`, `nginx.conf` — (kept) for serving the site via Docker + Nginx

How to view locally

1. Open `index.html` directly in your browser (double-click or use "Open File").

Serve with Docker (optional)

If you want to run the same site using the included Dockerfile/Nginx config, build and run the image (Windows `cmd.exe`):

```
docker build -t nginx-homepage .
docker run -p 8080:80 nginx-homepage
```

Then open http://localhost:8080 in your browser.

Notes
- Placeholder images are used in `index.html` (via placeholder.com). Replace with your own images.
- This is a static site. To collect contact form submissions you should wire the form to a backend or 3rd-party service.

