# PGN Stats

## How to Use

1. First download your games in PGN format. The API can download at most 10,000 games regardless of the `max` parameter - see [API docs](https://lichess.org/api#tag/Games/operation/apiGamesUser) - so for instance download games as white and black separetely:
   ```
   curl 'https://lichess.org/games/export/NorseRider?perfType=blitz&color=black' -o NorseRiderBlitzBlack.pgn
   curl 'https://lichess.org/games/export/NorseRider?perfType=blitz&color=white' -o NorseRiderBlitzWhite.pgn   
   ```
2. Convert the PGN games to JSON
   ```
   cat NorseRiderBlitz*.pgn | awk -f pgn2json.awk  > NorseRiderBlitz.jsonl
   ```
3. Normalize and extract statistics from JSON
   ```
   jq -f normalize.jq NorseRiderBlitz.jsonl | jq -s -f stats.jq
   ```
