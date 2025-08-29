sort_by(.date)
    | group_by(.date)
    | map({
        date: .[0].date,
        count: length,
        sum: (map(.outcome) | add),
        avg: (map(.outcome) | add / length)
    })
    | @csv
