#' Wykres kołowy ze zliczenia wartości zmiennej
#' @description
#' Rysuje wykres kołowy.
#' 
#' Odsetki oblicza jako częstości wystąpień poszczególnych wartości w 
#' przekazanym wektorze z pominięciem braków danych.
#' 
#' Właściwe etykiety wartości uzyskać można w dwojaki sposób - albo przekazując
#' do funkcji factor (wektor z przypisanymi etykietami wartości) albo używając
#' argumentu "etykiety". Argument "etykiety" powinien mieć postać:
#' \code{c('wartość1' = 'etykieta1', 'wartość2' = 'etykieta2', ...)}.
#' 
#' Jeśli argument "etykiety" zostanie użyty, ale nie będzie zawierał wszystkich
#' wartości występujących w danych, wartości te zostaną pominięte i nie wejdą
#' do podstawy procentowania!
#' 
#' W wypadku, gdy wektor danych nie będzie factorem i nie zostanie podany 
#' argument "etykiety", wtedy za etykiety zostaną przyjęte poszczególne 
#' wartości.
#' @param dane wektor danych
#' @param etykiety opcjonalny wektor z etykietami wartości
#' @param tytul tytuł wykresu
#' @param rozmiarTekstu bazowy rozmiar tekstu
#' @param opcjeWykresu dodatkowe opcje wykresu (zostaną dodane do obiektu wykresu ggplot2)
#' @param rysuj czy funkcja ma narysować wykres czy tylko zwrócić wygenerowany obiekt wykresu
#' @return [gg] obiekt wykresu pakietu ggplot2
#' @export
#' @import ggplot2
wykresKolowyZlicz = function(dane, etykiety = NULL, tytul = '', rozmiarTekstu = NULL, opcjeWykresu = NULL, rysuj = TRUE){
  stopifnot(
    is.vector(dane) | is.factor(dane),
    is.numeric(dane) | is.character(dane) | is.logical(dane) | is.factor(dane)
  )
  
  # logical -> factor
  if(is.logical(dane)){
    dane = factor(dane, levels = c(T, F), labels = c('TAK', 'NIE'))
  }
  
  # etykietowanie wartości
  if(is.character(etykiety)){
    wartosci = names(etykiety)
    if(is.null(wartosci)){
      wartosci = seq_along(etykiety)
    }
    dane = factor(dane, wartosci, etykiety)
  }
  
  dane = table(dane)
  tmp = names(dane)
  dane = stats::setNames(as.vector(dane), tmp)

  wykres = wykresKolowyNorm(dane, tytul = tytul, rozmiarTekstu = rozmiarTekstu, opcjeWykresu = opcjeWykresu, rysuj = FALSE)
  if(rysuj){
    suppressWarnings(print(wykres))
  }
  return(invisible(wykres))
}
