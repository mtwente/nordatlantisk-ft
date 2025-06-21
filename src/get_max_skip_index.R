# Definition -----

get_max_skip_index <- function(x) {
  if (x == 0) return(0)
  return(((x - 1) %/% 100) * 100)
}