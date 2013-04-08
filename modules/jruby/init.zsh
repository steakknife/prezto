if (( ! $+commands[jruby] )); then
    return 1
fi

# Set JRUBY_NAILGUN to 0 before to disable
export JRUBY_NAILGUN=${JRUBY_NAILGUN:-1}

if [ "$JRUBY_NAILGUN" = "1" ]; then
    # For rbenv/rvm to work properly
    pushd "$(dirname $0)"/sandbox >/dev/null

    # Start the nailgun server for faster JRuby performance
    export JRUBY_NAILGUN_SERVER_OPTS="${JRUBY_NAILGUN_SERVER_OPTS:---server --headless -J-Xmx1024m}"
    ps aux | grep -v grep | grep -qs 'com/martiansoftware/nailgun/NGServer' || jruby --ng-server $JRUBY_NAILGUN_SERVER_OPTS >/dev/null &

    # Leave the sandbox
    popd >/dev/null
fi

# Setup client options if they do not already exist
export JRUBY_OPTS="${JRUBY_OPTS:---headless --client}"

# Set JRUBY_NAILGUN to 0 before to disable
if [ "$JRUBY_NAILGUN" = "1" ]; then
    export JRUBY_OPTS="$JRUBY_OPTS --ng"
fi

