# CLI

The CLI is the deliberately boring front door for experimenting with lua-webcall-model without needing another Lua application.

From the repository root, run:

    luvit cli

Then:

    lua-webcall-model interactive CLI
    Type 'help' for commands or 'quit' to exit.
    webcall> get https://example.com

Available commands:

- get <url>
- post <url> <body>
- request <method> <url>
- help
- quit

The CLI is intentionally a thin consumer of webcall.lua. It is not part of the transport abstraction itself.
