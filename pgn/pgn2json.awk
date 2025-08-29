BEGIN {
  FS="\""
}

$1 ~ /^\[UTCDate /     { date = $2 }
$1 ~ /^\[White /       { white = $2 }
$1 ~ /^\[Black /       { black = $2 }
$1 ~ /^\[Result /      { result = $2 }

$0 == "" && date != "" && white != "" && black != "" && result != "" {
  printf "{\"date\":\"%s\",\"white\":\"%s\",\"black\":\"%s\",\"result\":\"%s\"}\n", date, black, white, result
  date=white=black=result=""  # reset for next game
}
