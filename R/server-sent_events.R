# library(curl)
# # note: this works, but still blocks the process, so utility is limited.
# # R versions of promises/futures work by multithreading, but curl handles cannot be passed
# # between threads. An alternative would be to do the whole download on a thread
# # and communicate intermediate states, but that's a) not easily supported, and b)
# # may lead us back into a synchronous flow anyway. Either way, the rabbithole is
# # too deep.
#
#
# log_server_sent_events <- function(handle, url) {
#   con <- curl(url, open = "r", handle = handle)
#   done <- FALSE
#
#   while(!done) {
#     line <- readLines(con, n = 1)
#
#     if(length(line) <= 0 || line == "data: [DONE]" ) {
#       done <- TRUE
#       next
#     }
#
#     if (stringr::str_detect(line, "data: ")) {
#       data <- jsonlite::fromJSON(stringr::str_remove(line, "data: "), simplifyDataFrame = FALSE)
#       cat(data$choices[[1]]$delta$content)
#     }
#   }
#
#   cat("\n\n")
#   close(con)
# }
#
#
# # req comes from chatgpt_completion
#
# post_data <- req$body$data %>% jsonlite::toJSON(auto_unbox = TRUE)
# h <- new_handle() %>%
#   handle_setheaders(
#     "Authorization" = "Bearer <REDACTED>",
#     "Content-Type" = "application/json") %>%
#   handle_setopt(
#     customrequest = "POST",
#     postfields = post_data
#   )
# log_server_sent_events(h, "https://api.openai.com/v1/chat/completions")
