#' player
#'
#' This function scrap the information of KBO players.
#' @param name Name of player.
#' @param birth Birthday of the player if there are players with the same name.
#' @param year Year of season.
#' @keywords baseball
#' @export
#' @import rvest
#' @import tibble
#' @import lubridate
#' @import dplyr
#' @import tidyr
#' @import xml2
#' @import janitor
#' @examples
#' player(name = "안치홍", year = "2019")
#' player(name = "박찬호", birth = "1995-06-05", year = "2019")

player <- function(name = "안치홍", birth = "", year = "2019") {
  url <- paste0("http://www.statiz.co.kr/player.php?opt=3&name=", name, "&birth=", birth, "&year=", year)

  Sys.sleep(sample(1:10)[3]/8) # I'm sorry Statiz..

  stat <- url %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table(fill = TRUE)

  stat <- stat[[3]]
  stat <- janitor::clean_names(stat)
  stat <- dplyr::filter(stat, 상대 != "상대") %>% as.tibble()
  colnames(stat)[1] <- "date"
  stat$date <- paste0(year, "-", stat$date) %>% lubridate::ymd()

  stat[, -c(1:6)] <- stat[, -c(1:6)] %>%
    unlist() %>%
    as.character() %>%
    as.numeric()

  stat <- separate(stat, 결과, c("결과", "점수"), sep = " ")

  stat <- stat %>%
    arrange(desc(date))

  return(stat)
}
