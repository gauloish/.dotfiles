set -U fish_greeting ""

starship init fish | source

set -g fish_key_bindings fish_default_key_bindings

set -x JAVA_HOME (readlink -f /usr/bin/java | sed "s:/bin/java::")
