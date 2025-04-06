BEGIN {
    buffer = ""
    matching = 0
}

$0 ~ /^\[/ {
    buffer = buffer $0 "\n"
}

$0 !~ /^\[/ {
    if (buffer) {
        matching = index(buffer, query)
    }
    if (matching) {
        print buffer $0
    }
    buffer = ""
}
