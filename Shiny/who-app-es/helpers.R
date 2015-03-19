# Load data. Weigth and Height
# World Head Organization
# The WHO Child Growth Standards
# http://www.who.int/childgrowth/en/

weianthro <- read.table("data/weianthro.txt",header=T,sep="",skip=0)
lenanthro <-read.table("data/lenanthro.txt",header=T,sep="",skip=0)

# Demystifying LMS
# http://medind.nic.in/ibv/t14/i1/ibvt14i1p37.pdf

fpercentil <- function (lambda, mu, sigma, y) {
  Zlms <- (1 / (sigma * lambda)) * (((y /mu) ** lambda) -1)
  round (pnorm (Zlms), 3)
}

fvalue <- function (lambda, mu, sigma, perc) {
  Zp <- qnorm (perc)
  y <- mu * ((1 + (lambda * sigma * Zp)) ** (1 / lambda))
  round (y,3)
}

# Apply previous function to weight and height dataframes

weight.percentil <- function (sex, age, value) {
  reg <- weianthro[weianthro$sex == sex & weianthro$age == age, ]
  fpercentil (reg$l, reg$m, reg$s, value)
}
  
weight.value <- function (sex, age, perc) {
  reg <- weianthro[weianthro$sex == sex & weianthro$age == age, ]
  fvalue (reg$l, reg$m, reg$s, perc)
}

height.percentil <- function (sex, age, value) {
  reg <- lenanthro[lenanthro$sex == sex & lenanthro$age == age, ]
  fpercentil (reg$l, reg$m, reg$s, value)
}

height.value <- function (sex, age, perc) {
  reg <- lenanthro[lenanthro$sex == sex & lenanthro$age == age, ]
  fvalue (reg$l, reg$m, reg$s, perc)
}


# Calculate some values asociated to main percentiles

aux.percentile <- c(0.05, seq (0.1, 0.9, 0.1), 0.95)
aux.colNames <- paste ("p", aux.percentile * 100, sep = '')

aux.function1 <- function (i) {
  mapply (fvalue, weianthro$l, weianthro$m, weianthro$s, i)
}

aux.function2 <- function (i) {
  mapply (fvalue, lenanthro$l, lenanthro$m, lenanthro$s, i)
}

aux <- sapply (aux.percentile, aux.function1)
aux <- as.data.frame (aux)
colnames (aux) <- aux.colNames
weianthro <- cbind.data.frame (weianthro, aux)

aux <- sapply (aux.percentile, aux.function2)
aux <- as.data.frame (aux)
colnames (aux) <- aux.colNames
lenanthro <- cbind.data.frame (lenanthro, aux)

rm (aux.percentile)
rm (aux.colNames)
rm(aux.function1)
rm(aux.function2)
rm(aux)