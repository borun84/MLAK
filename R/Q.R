#' @title wskazany kwantyl
#' @description
#' Istnieje możliwość obliczenia wartości wielu kwantyli jednocześnie - 
#' wystarczy jako q przekazać wektor. W takim wypadku zwrócony zostanie wektor
#' odpowiednich kwantyli.
#' @param x wektor wartości
#' @param q numer kwantyla (może być wektorem)
#' @param n liczba kwantyli
#' @param wyrownaj czy wyrównywać długość wyniku (TRUE w wypadku osadzania w tabelach)
#' @param dokl liczba cyfr po przecinku, do których zaokrąglony zostanie wynik
#' @return NULL
#' @export
Q = function(x, q, n, wyrownaj = T, dokl = 2){
  stopifnot(
    is.numeric(x),
    is.numeric(q),
    is.numeric(n),
    length(n) == 1,
    all(n >= q),
    n >= 1
  )
  
  f = function(x){
    tmp = quantile(x, seq(0, 1, length.out = n + 1))
    return(tmp[q + 1])
  }
  return(statWektor(x, f, sys.call(), wyrownaj, dokl))
}