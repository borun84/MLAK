#' @title oblicza wskazaną statystykę dla wskazanego wektora danych
#' @description
#' \itemize{
#'   \item sprawdza czy x jest wektorem
#'   \item wywołuje na x funkcję giodo()
#'   \item wywołuje na x na.omit()
#'   \item jeśli wektor x jest pusty przyjmuje '-' jako wynik
#'   \item jeśli wektor x nie jest pusty, wywołuje na x funkcję f i 
#'     zaokrągla wynik zgodnie z parametrem dokl
#'   \item ew. wyrównuje długość wyniku do długości wywołania call
#' }
#' @param x wektor wartości lub ramka danych wartości
#' @param f funkcja do wykonania na x
#' @param call wywołanie, do którego długości wyrównywany jest wynik
#' @param wyrownaj czy wyrównywać długość wyniku (TRUE w wypadku osadzania w tabelach)
#' @param dokl liczba cyfr po przecinku, do których zaokrąglony zostanie wynik
#' @return zależnie od funkcji f
#' @export
statWektor = function(x, f, call, wyrownaj = T, dokl = 2){
  stopifnot(
    is.vector(x),
    is.numeric(x) | is.character(x) | is.logical(x)
  )
  x = giodo(x)
  x = na.exclude(x)
  if(length(x) == 0){
    wynik = '-'
  }else{
    wynik = f(x)
  }
  
  if(wyrownaj){
    dl = 4 + nchar(deparse(call))
    if(max(nchar(wynik)) > dl){
      warning('Wyrównanie długości nie było możliwe')
    }
    format = ifelse(
      is.character(wynik),
      paste0('% ', dl, 's'),
      paste0('% ', dl, '.', dokl, 'f')
    )
    return(sprintf(format, wynik)) 
  }
  return(wynik)  
}