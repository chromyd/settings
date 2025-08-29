# PGN Stats

## How to Use

1. First download your games in PGN format. Due to paging it may be necessary to download games as white and black separetely - see [API docs](https://lichess.org/api#tag/Games/operation/apiGamesUser)
   ```
   curl 'https://lichess.org/games/export/NorseRider?perfType=blitz&color=black' -o NorseRiderBlitzBlack.pgn
   curl 'https://lichess.org/games/export/NorseRider?perfType=blitz&color=white' -o NorseRiderBlitzWhite.pgn   
   ```
2. Convert the PGN games to JSON
   ```
   awk -f pgn2json.awk NorseRiderBlitz.pgn > NorseRiderBlitz.jsonl
   ```
3. Normalize and extract statistics from JSON
   ```
   jq -f normalize.jq NorseRiderBlitz.jsonl | jq -s -f stats.jq
   ```
