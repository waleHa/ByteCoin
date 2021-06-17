

import Foundation

protocol BitcoinManagerDelegate {
    func didUpdatePrice1(price1: String, currency: String)
    func didFailWithError1(error: Error)
}

protocol EthereumManagerDelegate {
    func didUpdatePrice2(price2: String, currency: String)
    func didFailWithError2(error: Error)
}

struct CoinManager {
    
    var bitcoinDelegate: BitcoinManagerDelegate?
    var ethereumDelegate: EthereumManagerDelegate?

    let baseURL1 = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let baseURL2 = "https://rest.coinapi.io/v1/exchangerate/ETH"
    
    let apiKey:String = Key.myKey
    
    let currencyArray = ["AUD", "USD","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","BRL","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString1 = "\(baseURL1)/\(currency)?apikey=\(apiKey)"
        let urlString2 = "\(baseURL2)/\(currency)?apikey=\(apiKey)"
        
        print(urlString1)
        print(urlString2)
        if let url1 = URL(string: urlString1){
            let session = URLSession(configuration: .default)
                        let task = session.dataTask(with: url1) { (data1, response, error) in
                            if error != nil {
                                self.bitcoinDelegate?.didFailWithError1(error: error!)
                                print("Error2")
                                return
                            }
                            if let safeData1 = data1{
                                if let bitcoinPrice = self.parseJSON(safeData1) {
                                    let price1String = String(format: "%.2f", bitcoinPrice)
                                    print(price1String)
                                    self.bitcoinDelegate?.didUpdatePrice1(price1: price1String, currency: currency)
                                }
                            }
                        }
                        task.resume()
                    }
                if let url2 = URL(string: urlString2){
                    let session = URLSession(configuration: .default)
                                let task = session.dataTask(with: url2) { (data2, response, error) in
                                    if error != nil {
                                        self.bitcoinDelegate?.didFailWithError1(error: error!)
                                        print("Error2")
                                        return
                                    }
                                    if let safeData2 = data2{
                                        if let bitcoinPrice = self.parseJSON(safeData2) {
                                            let price2String = String(format: "%.2f", bitcoinPrice)
                                            print(price2String)
                                            self.ethereumDelegate?.didUpdatePrice2(price2: price2String, currency: currency)
                                        }
                                    }
                                }
                                task.resume()
                            }
         
    }
    
    func parseJSON(_ data: Data,_ number:Int=1) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            if number == 1{
            bitcoinDelegate?.didFailWithError1(error: error)
            }
            else{
                ethereumDelegate?.didFailWithError2(error: error)
            }
            return nil
        }
    }
    
}
