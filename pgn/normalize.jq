{
    date,
    side: (
        if .white == "NorseRider" then "white"
        elif .black == "NorseRider" then "black"
        else halt_error(1)
        end
    ),
    white,
    black,
    result,
    outcome: ( 
      if .result == "1/2-1/2" then 0.5 
      elif .result == "1-0" then
        if .white == "NorseRider" then 1 else 0 end 
      elif .result == "0-1" then 
        if .black == "NorseRider" then 1 else 0 end 
      else halt_error(2)
      end
    )
}
