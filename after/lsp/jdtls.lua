-- openjdk (jdtls needs Java 25+) is keg-only (not on PATH), so point jdtls at it explicitly.
local java_home = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

return {
    cmd_env = {
        JAVA_HOME = java_home,
        PATH = java_home .. "/bin:" .. vim.env.PATH,
    },
}
