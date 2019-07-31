.onAttach <- function(...) {
  withr::with_preserve_seed({
    # if (!interactive() || stats::runif(1) > 0.1) return()

    tips <- c(
      "I LOVE KBO!",
      "KBO, Korea Baseball Organization"
    )

    tip <- sample(tips, 1)
    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
  })
}
