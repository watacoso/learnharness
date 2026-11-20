# Browser server (container)

Runs LearnHarness in browser-only mode (see [development.md](development.md)) as a container: the
Next.js standalone server without the Electron shell.

```bash
docker build -t learnharness .
docker run -p 3000:3000 -v lh-data:/data -e LH_ALLOWED_HOSTS=learn.example.com learnharness
```

| Variable | Default | |
|---|---|---|
| `LH_DATA_DIR` | `/data/data` | Chats, graph, settings |
| `LH_AUTH_FILE` | `/data/auth.json` | API keys; subscription credentials are written beside it |
| `LH_ALLOWED_HOSTS` | — | Host names the API accepts besides `localhost` and IPs |
| `CHROME_PATH` | `/usr/bin/chromium` | Headless browser for demo verification |

There is no login. Put it behind an access gate (VPN, auth proxy); never expose it publicly.

Not available in a browser: native file/folder pickers (paste server-side paths instead), the
auto-updater, and ChatGPT sign-in from another machine (its callback listens on the server's
`127.0.0.1`). API keys, custom OpenAI-compatible endpoints, and device-code sign-ins (Copilot, Grok)
work.

Image: `.github/workflows/publish-image.yml` → `ghcr.io/watacoso/learnharness`.
