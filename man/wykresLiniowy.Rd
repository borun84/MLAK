% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wykresLiniowy.R
\name{wykresLiniowy}
\alias{wykresLiniowy}
\title{Wykres liniowy}
\usage{
wykresLiniowy(dane, tytul = "", tytulX = NULL, tytulY = NULL, nMin = 3,
  xNMax = 36, rozmiarTekstu = NULL, opcjeWykresu = NULL, rysuj = TRUE)
}
\arguments{
\item{dane}{ramka danych opisująca serie danych - patrz opis szczegółowy}

\item{tytul}{tytuł wykresu}

\item{tytulX}{tytuł osi X wykresu}

\item{tytulY}{tytuł osi Y wykresu}

\item{nMin}{minimalna liczebność wymagana do wyświetlenia punktu na wykresie}

\item{xNMax}{maksymalna liczba wyświetlanych etykiet osi X}

\item{rozmiarTekstu}{bazowy rozmiar tekstu}

\item{opcjeWykresu}{dodatkowe opcje wykresu (zostaną dodane do obiektu wykresu ggplot2)}

\item{rysuj}{czy funkcja ma narysować wykres czy tylko zwrócić wygenerowany obiekt wykresu}
}
\value{
[gg] obiekt wykresu pakietu ggplot2
}
\description{
Rysuje wykres liniowy z przekazanych danych.
}
\details{
Przekazane dane mają postać długą, z kolumnami: x, y, n oraz opcjonalnie seria.

Punkty o niedostatecznej liczebności zostaną zanonimizowane.
}
