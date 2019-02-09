# Project Title: YinsPredictor2_0

This package has a predictive function developed and generate predictive results signaling tomorrow's stock price given a stock ticker.

## Information

Information:
- Package: YinsStockPredictoR
- Type: Package
- Title: Stock Behavior Given a Ticker
- Version: 0.1.0
- Author: Yiqiao Yin
- Maintainer: Yiqiao Yin <eagle0504@gmail.com>
- Description: This package advises a trading/investment decision given a stock ticker.
- License: GPL-1
- imports: quantmod,stats,xts
- Encoding: UTF-8
- LazyData: true

The package originate from source [SAURAV KAUSHIK, MARCH 22, 2017](https://www.analyticsvidhya.com/blog/2017/03/create-packages-r-cran-github/).
It is updated with a buy/sell signal table. 
- The theorem of how to construct these signals come from Yin's Research, click [here](https://yinscapital.com/research/).
- The app with this function built in is [here](https://y-yin.shinyapps.io/CENTRAL-INTELLIGENCE-PLATFORM/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Basic working knowledge of using *R* and *RSTudio*.

### Installing

The installation of this package is simple. We recommend to use *devtools* to install from Github.

```
# Install Packge using devtools
devtools::install_github("yiqiao-yin/YinsPredictor2_0")
```

## Example

An example usage of this package can refer to the following.

```
# For example
Sys.time(); stock_predict('AAPL',past.n.days = 5)

# Output
[1] "2019-02-09 10:52:35 EST"
$`TS.Result`
[1] "Tomorrow this stock goes up with probability: 0.28"

$Buy.Sell.Signal.Table
           ClosePriceofAAPL BuySignal SellSignal
2019-02-01           166.52         0    0.00000
2019-02-04           171.25         0   80.21978
2019-02-05           174.18         0  160.43955
2019-02-06           174.24         0    0.00000
2019-02-07           170.94         0    0.00000
2019-02-08           170.41         0    0.00000
```

Output is a list with two objects: 
- The first object has a comment with a quantity calculated from backend of the package.
- The second object is a table resulting from a more complex comptutation from the packge.

## Built With

* [Yiqiao Yin's Research](https://yinscapital.com/research/): We conduct resaerch at Yin's Capital and we develop packages for trading algorithms.

## Contributing

Yiqiao Yin (myself) is the sole owner and manager for this package.
