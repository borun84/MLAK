#' Wykres - histogram
#' @description
#' Rysuje histogram z przekazanych danych.
#' @param dane wektor danych
#' @param n liczba przedziałów
#' @param tytul tytuł wykresu
#' @param tytulX tytuł osi X wykresu
#' @param tytulY tytuł osi Y wykresu
#' @param rozmiarTekstu bazowy rozmiar tekstu
#' @param opcjeWykresu dodatkowe opcje wykresu (zostaną dodane do obiektu
#'   wykresu ggplot2)
#' @param rownePrzedzialy czy przedziały na osi X powinny być równe (TRUE) czy
#'   wyznaczane przez kwantyle (FALSE)
#' @param rysuj czy funkcja ma narysować wykres czy tylko zwrócić wygenerowany
#'   obiekt wykresu
#' @param pomijajEtykiety wartość, na podstawie której funkcja decyduje, które
#'   etykiety będą na siebie nachodzić i należy je pomijać; nie ma żadnej
#'   intuicyjnej interpretacji, wiadomo jedynie, że im ona mniejsza, tym
#'   szybciej etykiety będą pomijane; odpowiedią wartość należy dobrać
#'   eksperymentalnie
#' @return [gg] obiekt wykresu pakietu ggplot2
#' @export
#' @import ggplot2
wykresHistogram = function(dane, n = 9, tytul = '', tytulX = NULL, tytulY = NULL, rozmiarTekstu = NULL, opcjeWykresu = NULL, rownePrzedzialy = FALSE, rysuj = TRUE, pomijajEtykiety = 500){
  stopifnot(
    is.vector(dane) | is.factor(dane),
    is.numeric(dane) | is.character(dane) | is.logical(dane) | is.factor(dane)
  )
  nGiodo = 3
  
  dane[is.nan(dane) | is.infinite(dane)] = NA
  dane = stats::na.exclude(dane)
  
  if(length(dane) == 0){
    return(wykresPusty(tytul = tytul, tytulX = tytulX, tytulY = tytulY, rysuj = rysuj))
  }
  
  if(is.numeric(dane)){
    if(rownePrzedzialy){
      breaks = seq(min(dane), max(dane), length.out = n + 1)
    }else{
      n = min(n, length(unique(dane)))
      breaks = stats::quantile(dane, seq(0, 1, length.out = n + 1))
      while(length(breaks) != length(unique(breaks))){
        n = n - 1
        breaks = stats::quantile(dane, seq(0, 1, length.out = n + 1))
      }
      # straszliwe ręczne generowanie wysokości słupków
      szer = cbind(breaks[-1], breaks[-length(breaks)])
      szer = 1 / (szer[, 1] - szer[, 2])
      szer = szer / sum(szer)
      breaksTmp = breaks + 10^-6
      breaksTmp[1] = breaks[1]
      if(length(breaksTmp) == 1){
        return(wykresPusty(tytul = tytul, tytulX = tytulX, tytulY = tytulY, rysuj = rysuj))
#        breaksTmp[2] = breaksTmp[1] + 10^-6
#        coś jeszcze zrobić z szerokościami
      }
      grupy = cut(dane, breaksTmp, labels = names(szer), right = FALSE)
      nMin = min(table(grupy))
      if(nMin < nGiodo){
        return(wykresPusty(tytul = tytul, tytulX = tytulX, tytulY = tytulY, rysuj = rysuj))
      }
      wagi = szer[grupy]
      wys = stats::aggregate(wagi, list(names(wagi)), function(x){x[1] * length(x)})
      wys$x = round(1000 * wys$x)
      srednie = rowMeans(cbind(breaks[-1], breaks[-length(breaks)]))
      wys$grupa = srednie[wys[, 1]] - 1 #!!!
      dane = as.numeric(unlist(by(wys, wys$grupa, function(x){
        return(rep(x$grupa[1], x$x[1]))
      })))
    }
    
    wykres = ggplot(data = data.frame(d = dane)) + aes(x = get('d')) +
      suppressWarnings( # różna szerokość słupków generuje "position_stack requires constant width: output may be incorrect"
        geom_histogram(
          breaks = breaks,
          colour = '#999999',
          fill = '#FFFFFF'
        )
      )
  }else{
    nMin = min(table(dane))
    if(nMin < nGiodo){
      return(wykresPusty(tytul = tytul, tytulX = tytulX, tytulY = tytulY, rysuj = rysuj))
    }
    wykres = ggplot(data = data.frame(d = dane)) + aes(x = get('d')) +
      geom_bar(
        colour = '#000000',
        fill = '#FFFFFF',
        stat = 'count'
      )
  }
  
  wykres = wykresDefaultTheme(wykres, tytul = tytul, tytulX = tytulX, tytulY = tytulY, rozmiarTekstu = rozmiarTekstu) + 
    theme(
      axis.line = element_line(colour = '#000000', linetype = 'solid'), 
      axis.line.x = element_blank(),
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)
    )
  
  if(rownePrzedzialy == FALSE){
    wykres = wykres + theme(axis.line.y = element_blank(), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())
  }
  
  # skala osi X dla danych ciągłych
  if(is.numeric(dane)){
    # unikanie nachodzących na siebie etykiet
    odstepMin = (breaks[length(breaks)] - breaks[1]) * ifelse(is.null(rozmiarTekstu), 10, rozmiarTekstu) / pomijajEtykiety
    etykiety = round(breaks)
    pop = 1
    for(i in 1 + seq_along(breaks[-1])){
      if(breaks[i] - breaks[pop] < odstepMin){
        etykiety[i] = ''
      }else{
        pop = pop + 1
        while(etykiety[pop] == ''){
          pop = pop + 1
        }
      }
    }
    
    wykres = wykres + scale_x_continuous(breaks = breaks, labels = etykiety)
  }
  
  if(!is.null(opcjeWykresu)){
    wykres = wykres + opcjeWykresu
  }
  
  if(rysuj){
    suppressWarnings(print(wykres))
  }
  return(invisible(wykres))
}
