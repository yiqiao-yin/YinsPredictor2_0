#' @title Predicts Stock Price Movement for Given Stock Symbol
#' @description This package predicts whether the stock price at tommorow's market close would be higher or lower compared to today's closing place.
#' @param symbol
#' @return NULL
#' @examples  stock_predict('AAPL')
#' @export stock_predict
#'
#' # Define function
stock_predict <- function(
  # TS Prediction
  symbol,
  # Buy Symbols
  # r_day_plot=.8; end_day_plot=1; c=-1.96; height=1; past.n.days=3; test.new.price=0
  r_day_plot=.8, end_day_plot=1, c.buy=-1.96, c.sell=+1.96, height=1, past.n.days=3, test.new.price=0)
{

  ## TS Prediction
  # To ignore the warnings during usage
  options(warn=-1)
  options("getSymbols.warning4.0"=FALSE)
  # Importing price data for the given symbol
  data<-data.frame(xts::as.xts(get(quantmod::getSymbols(symbol))))

  # Assighning the column names
  colnames(data) <- c("data.Open","data.High","data.Low","data.Close","data.Volume","data.Adjusted")

  # Creating lag and lead features of price column.
  data <- xts::xts(data,order.by=as.Date(rownames(data)))
  data <- as.data.frame(merge(data, lm1=stats::lag(data[,'data.Adjusted'],c(-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
                                                                            20,30,40,50,60,100,150,200,250,300))))

  # Extracting features from Date
  data$Date<-as.Date(rownames(data))
  data$Day_of_month<-as.integer(format(as.Date(data$Date),"%d"))
  data$Month_of_year<-as.integer(format(as.Date(data$Date),"%m"))
  data$Year<-as.integer(format(as.Date(data$Date),"%y"))
  data$Day_of_week<-as.factor(weekdays(data$Date))

  # Naming variables for reference
  today <- 'data.Adjusted'
  tommorow <- 'data.Adjusted.5'

  # Creating outcome
  data$up_down <- as.factor(ifelse(data[,tommorow] > data[,today], 1, 0))

  # Creating train and test sets
  train<-data[stats::complete.cases(data),]
  test<-data[nrow(data),]

  # Training model
  model<-stats::glm(up_down~data.Open+data.High+data.Low+data.Close+
                      data.Volume+data.Adjusted+data.Adjusted.1+
                      data.Adjusted.2+data.Adjusted.3+data.Adjusted.4+
                      #data.Adjusted.5+data.Adjusted.6+data.Adjusted.7+
                      #data.Adjusted.8+data.Adjusted.9+data.Adjusted.10+
                      #data.Adjusted.11+data.Adjusted.12+data.Adjusted.13+
                      #data.Adjusted.14+data.Adjusted.15+data.Adjusted.16+
                      #data.Adjusted.17+data.Adjusted.18+data.Adjusted.19+
                      #data.Adjusted.20+data.Adjusted.21+data.Adjusted.22+
                      #data.Adjusted.23+data.Adjusted.24+data.Adjusted.25+
                      Day_of_month+Month_of_year+Year+Day_of_week,
                    family=binomial(link='logit'),data=train)

  # Making Predictions
  pred<-as.numeric(stats::predict(model,test[,
                                             c(
                                               'data.Open','data.High','data.Low','data.Close','data.Volume','data.Adjusted',
                                               'data.Adjusted.1','data.Adjusted.2','data.Adjusted.3','data.Adjusted.4',
                                               #"data.Adjusted.5" ,"data.Adjusted.6","data.Adjusted.7",
                                               #"data.Adjusted.8","data.Adjusted.9","data.Adjusted.10",
                                               #"data.Adjusted.11","data.Adjusted.12","data.Adjusted.13",
                                               #"data.Adjusted.14","data.Adjusted.15","data.Adjusted.16",
                                               #"data.Adjusted.17","data.Adjusted.18","data.Adjusted.19",
                                               #"data.Adjusted.20","data.Adjusted.21","data.Adjusted.22",
                                               #"data.Adjusted.23","data.Adjusted.24","data.Adjusted.25",
                                               'Day_of_month','Month_of_year','Year','Day_of_week')
                                             ],type = 'response'))

  ## Buy Signal
  x <- data.frame(xts::as.xts(get(quantmod::getSymbols(symbol))))
  if (test.new.price == 0) {
    x = x
  } else {
    intra.day.test <- matrix(c(0,0,0,test.new.price,0,0), nrow = 1)
    rownames(intra.day.test) <- as.character(Sys.Date())
    x = data.frame(rbind(x, intra.day.test))
  }
  Close<-x[,4] # Define Close as adjusted closing price
  # A new function needs redefine data from above:
  # Create SMA for multiple periods
  SMA10<-TTR::SMA(Close,n=10)
  SMA20<-TTR::SMA(Close,n=20)
  SMA30<-TTR::SMA(Close,n=30)
  SMA50<-TTR::SMA(Close,n=50)
  SMA200<-TTR::SMA(Close,n=200)
  SMA250<-TTR::SMA(Close,n=250)

  # Create RSI for multiple periods
  RSI10 <- (TTR::RSI(Close,n=10)-50)*height
  RSI20 <- (TTR::RSI(Close,n=20)-50)*height
  RSI30 <- (TTR::RSI(Close,n=30)-50)*height
  RSI50 <- (TTR::RSI(Close,n=50)-50)*height
  RSI200 <- (TTR::RSI(Close,n=200)-50)*height
  RSI250 <- (TTR::RSI(Close,n=250)-50)*height

  # Create computable dataset: Close/SMA_i-1
  ratio_10<-(Close/SMA10-1)
  ratio_20<-(Close/SMA20-1)
  ratio_30<-(Close/SMA30-1)
  ratio_50<-(Close/SMA50-1)
  ratio_200<-(Close/SMA200-1)
  ratio_250<-(Close/SMA250-1)
  all_data_ratio <- cbind.data.frame(
    ratio_10,
    ratio_20,
    ratio_30,
    ratio_50,
    ratio_200,
    ratio_250
  )
  # Here we want to create signal for each column
  # Then we add them all together
  all_data_ratio[is.na(all_data_ratio)] <- 0 # Get rid of NAs
  sd(all_data_ratio[,1])
  sd(all_data_ratio[,2])
  sd(all_data_ratio[,3])
  sd(all_data_ratio[,4])
  sd(all_data_ratio[,5])
  sd(all_data_ratio[,6])
  m<-height*mean(Close)

  # Buy Signal
  coef<-c.buy
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] <= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] <= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] <= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] <= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] <= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] <= coef*sd(all_data_ratio[,6]),
    m, "0")
  all_data_ratio$Signal <- (
    as.numeric(all_data_ratio[,7])
    + as.numeric(all_data_ratio[,8])
    + as.numeric(all_data_ratio[,9])
    + as.numeric(all_data_ratio[,10])
    + as.numeric(all_data_ratio[,11])
    + as.numeric(all_data_ratio[,12])
  )
  all_data_signal <- cbind.data.frame(Close, all_data_ratio$Signal); all_data_buy_signal <- all_data_signal

  # Sell Signal
  coef<-c.sell
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] >= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] >= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] >= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] >= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] >= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] >= coef*sd(all_data_ratio[,6]),
    m, "0")
  all_data_ratio$Signal <- (
    as.numeric(all_data_ratio[,7])
    + as.numeric(all_data_ratio[,8])
    + as.numeric(all_data_ratio[,9])
    + as.numeric(all_data_ratio[,10])
    + as.numeric(all_data_ratio[,11])
    + as.numeric(all_data_ratio[,12])
  )
  all_data_signal <- cbind.data.frame(Close, all_data_ratio$Signal); all_data_sell_signal <- all_data_signal

  # Consolidate
  # Here let us put buy sell signal table together
  final_table <- cbind.data.frame(
    Date = rownames(x),
    Buy_Sginal = all_data_buy_signal,
    Sell_Signal = all_data_sell_signal
  )
  reduced_table <- data.frame(final_table[(nrow(final_table)-past.n.days):nrow(final_table),-4]);
  colnames(reduced_table) <- c("Date", paste0("ClosePriceof",symbol), "BuySignal", "SellSignal");
  rownames(reduced_table) <- reduced_table$Date

  # Printing results
  return(list(
    TS.Result = (paste0("Tomorrow this stock goes up with probability: ", round(pred, 2))),
    Buy.Sell.Signal.Table = reduced_table[, -1]
  ))
} # End of function
