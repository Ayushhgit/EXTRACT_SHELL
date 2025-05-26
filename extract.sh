#!/bin/bash

URL="https://www.amfiindia.com/spages/NAVAll.txt"

TMP_FILE="nav_raw.txt"
TSV_OUTPUT="nav_data.tsv"
JSON_OUTPUT="nav_data.json"
curl -s "$URL" -o "$TMP_FILE"# Filter and extract lines that match data pattern (skip headers)
grep -E "^[0-9]{6};" "$TMP_FILE" | \
awk -F ';' '{
    # $4 = Scheme Name
    # $5 = NAV
    if (NF >= 5 && $5 != "N.A.") {
        printf "%s\t%s\n", $4, $5
    }
}' > "$TSV_OUTPUT"

awk -F '\t' 'BEGIN {
    print "["
}
{
    gsub(/"/, "\\\"", $1); gsub(/"/, "\\\"", $2)
    printf "  {\"scheme_name\": \"%s\", \"nav\": \"%s\"}", $1, $2
    if (NR != 0 && !eof) print ","
}
END {
    print "\n]"
}' "$TSV_OUTPUT" > "$JSON_OUTPUT"

echo "Extraction complete."
echo "→ TSV saved to $TSV_OUTPUT"
echo "→ JSON saved to $JSON_OUTPUT"
