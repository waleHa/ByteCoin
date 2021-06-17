

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var bitcoinCurrencyLabel: UILabel!
    @IBOutlet weak var ethereumLabel: UILabel!
    @IBOutlet weak var ethereumCurrencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.bitcoinDelegate = self
        coinManager.ethereumDelegate = self

        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: BitcoinManagerDelegate {
    
    func didUpdatePrice1(price1: String, currency: String) {
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price1
//            self.ethereumLabel.text = price2
            self.bitcoinCurrencyLabel.text = currency
//            self.ethereumCurrencyLabel.text = currency
        }
    }
    
    func didFailWithError1(error: Error) {
        print(error)
    }
}

extension ViewController: EthereumManagerDelegate {
    
    func didUpdatePrice2(price2: String, currency: String) {
        
        DispatchQueue.main.async {
//            self.bitcoinLabel.text = price2
            self.ethereumLabel.text = price2
//            self.bitcoinCurrencyLabel.text = currency
            self.ethereumCurrencyLabel.text = currency
        }
    }
    
    func didFailWithError2(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return coinManager.currencyArray.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return coinManager.currencyArray[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedCurrency = coinManager.currencyArray[row]
          coinManager.getCoinPrice(for: selectedCurrency)
      }
}

