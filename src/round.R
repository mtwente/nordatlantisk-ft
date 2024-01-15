# Definition -----

round_to_hundred <- function(x) {
  if (x <= 100) {
    return(0)
  } else {
    return(floor(x / 100) * 100)
  }
}