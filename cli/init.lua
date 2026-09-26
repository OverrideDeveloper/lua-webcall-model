local webcall = require("../webcall")

local prompt = "webcall> "

local function print_help()
    print("lua-webcall-model interactive CLI")
    print("")
    print("Commands:")
    print("  get <url>                 GET a URL")
    print("  post <url> <body>         POST a string body")
    print("  request <method> <url>    Make a request with no body")
    print("  help                      Show this help")
    print("  quit                      Exit")
    print("")
end

local function print_response(response, err)
    if err then
        print("error: " .. tostring(err))
    end

    if not response then
        return
    end

    print("HTTP " .. tostring(response.status) .. " " .. response.method .. " " .. response.url)
    print("body: " .. tostring(#response.body) .. " bytes")
    print(response.body)
end

local function run_request(options)
    webcall.request(options, print_response)
end

local function handle(line)
    line = line:match("^%s*(.-)%s*$")

    if line == "" then
        io.write(prompt)
        return
    end

    local command, rest = line:match("^(%S+)%s*(.*)$")
    command = command:lower()

    if command == "quit" or command == "exit" then
        print("Farewell, webcaller.")
        os.exit(0)
    elseif command == "help" then
        print_help()
    elseif command == "get" then
        if rest == "" then
            print("usage: get <url>")
        else
            webcall.get(rest, print_response)
        end
    elseif command == "post" then
        local url, body = rest:match("^(%S+)%s+(.+)$")
        if not url then
            print("usage: post <url> <body>")
        else
            webcall.post(url, body, print_response)
        end
    elseif command == "request" then
        local method, url = rest:match("^(%S+)%s+(%S+)$")
        if not method then
            print("usage: request <method> <url>")
        else
            run_request({
                method = method:upper(),
                url = url,
            })
        end
    else
        print("unknown command: " .. command .. " (try 'help')")
    end

    io.write(prompt)
end

print("lua-webcall-model interactive CLI")
print("Type 'help' for commands or 'quit' to exit.")
io.write(prompt)

process.stdin:on("data", function(chunk)
    for line in tostring(chunk):gmatch("[^\r\n]+") do
        handle(line)
    end
end)

process.stdin:on("end", function()
    os.exit(0)
end)
