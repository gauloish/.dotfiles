set -U fish_greeting ""

keymaps

starship init fish | source

set -x JAVA_HOME (readlink -f /usr/bin/java | sed "s:/bin/java::")
