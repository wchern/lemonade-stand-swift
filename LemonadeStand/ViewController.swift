//
//  ViewController.swift
//  LemonadeStand
//
//  Created by William Chern on 6/24/2015.
//  Last Modified by William Chern on 6/30/2015.
//
//  Copyright (c) 2015 William Chern. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // IBOutlet Connections
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lemonCountLabel: UILabel!
    @IBOutlet weak var iceCubeCountLabel: UILabel!
    
    @IBOutlet weak var lemonsPurchasedLabel: UILabel!
    @IBOutlet weak var iceCubesPurchasedLabel: UILabel!
    
    @IBOutlet weak var lemonMixLabel: UILabel!
    @IBOutlet weak var iceCubeMixLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var startDayButton: UIButton!
    
    // Variables
    var balance = 10
    var lemonCount = 1
    var iceCubeCount = 1
    
    var lemonsPurchased = 0
    var iceCubesPurchased = 0
    
    var lemonsMixed = 0
    var iceCubesMixed = 0
    
    var lemonadeAcidityRatio:Double = 0.00
    
    var customersWhoPurchasedLemonade = 0
    
    var randomNumberOfCustomers = 0
    
    var weather = 1
    
    //    var dayCounter = 1
    
    // kConstants for tastePreference
    var kTasteZero:Double = 0.0
    var kTasteOne = 0.1
    var kTasteTwo = 0.2
    var kTasteThree = 0.3
    var kTasteFour = 0.4
    var kTasteFive = 0.5
    var kTasteSix = 0.6
    var kTasteSeven = 0.7
    var kTasteEight = 0.8
    var kTasteNine = 0.9
    
    // Constant Prices
    let priceOfALemon = 2
    let priceOfAnIceCube = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateStatusView()
        setNextDayWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBAction BUTTONS PRESSED
    
    // START DAY
    @IBAction func startDayButtonPressed(sender: UIButton) {
        if lemonsMixed == 0 && iceCubesMixed == 0 {
            showAlertWithText("Mix", message: "Please add lemons and ice cubes to the mix!")
        }
        else if lemonsMixed == 0 {
            showAlertWithText("Mix", message: "Please add lemons to the mix!")
        }
        else if iceCubesMixed == 0 {
            showAlertWithText("Mix", message: "Please add ice cubes to the mix!")
        }
        else {
            startNewDay()
            resetDay()
            setNextDayWeather()
        }
        updateAllViews()
    }
    
    // RESET GAME
    @IBAction func resetGameButtonPressed(sender: UIButton) {
        print("")
        print("Game Reset.")
        
        balance = 10
        lemonCount = 1
        iceCubeCount = 1
        
        weatherImageView.image = UIImage(named: "Mild")
        
        resetDay()
        setNextDayWeather()
        
        showAlertWithText("Reset", message: "The game has been reset.")
        
        updateAllViews()
    }
    
    // ADD PURCHASED LEMON
    @IBAction func addLemonPurchasedButtonPressed(sender: UIButton) {
        if (balance - priceOfALemon) < 0 {
            showAlertWithText("Purchase", message: "You do not have enough money.")
        }
        else {
            lemonsPurchased++
            
            lemonCount++
            
            balance -= priceOfALemon
        }
        updateAllViews()
    }
    
    // SUBTRACT PURCHASED LEMON
    @IBAction func subtractLemonPurchasedButtonPressed(sender: UIButton) {
        if checkForLemonTheft() {
            showAlertWithText("Negative Purchase", message: "You cannot purchase negative lemons!")
        }
        else {
            if lemonsPurchased > 0 {
                lemonsPurchased--
                lemonCount--
                balance += priceOfALemon
            }
            else {
                showAlertWithText("Negative Purchase", message: "You cannot purchase negative lemons!")
            }
        }
        updateAllViews()
    }
    
    // ADD PURCHASED ICE CUBE
    @IBAction func addIceCubePurchasedButtonPressed(sender: UIButton) {
        if (balance - priceOfAnIceCube) < 0 {
            showAlertWithText("Purchase", message: "You do not have enough money!")
        }
        else {
            iceCubesPurchased++
            
            iceCubeCount++
            
            balance -= priceOfAnIceCube
        }
        updateAllViews()
    }
    
    // SUBTRACT PURCHASED ICE CUBE
    @IBAction func subtractIceCubePurchasedButtonPressed(sender: UIButton) {
        if checkForIceCubeTheft() {
            showAlertWithText("Negative Purchase", message: "You cannot purchase negative ice cubes!")
        }
        else {
            if iceCubesPurchased > 0 {
                iceCubesPurchased--
                iceCubeCount--
                balance += priceOfAnIceCube
            }
            else {
                showAlertWithText("Negative Purchase", message: "You cannot purchase negative ice cubes!")
            }
        }
        updateAllViews()
    }
    
    @IBAction func addLemonToMixButtonPressed(sender: UIButton) {
        if lemonCount == 0 {
            showAlertWithText("Inventory", message: "You do not have enough lemons!")
        }
        else {
            lemonsMixed++
            lemonCount--
        }
        updateAllViews()
    }
    
    @IBAction func subtractLemonFromMixButtonPressed(sender: UIButton) {
        if lemonsMixed > 0 {
            lemonsMixed--
            lemonCount++
        }
        else {
            showAlertWithText("Mix", message: "You cannot mix negative lemons!")
        }
        updateAllViews()
    }
    
    @IBAction func addIceCubeToMixButtonPressed(sender: UIButton) {
        if iceCubeCount == 0 {
            showAlertWithText("Inventory", message: "You do not have enough ice cubes!")
        }
        else {
            iceCubesMixed++
            iceCubeCount--
        }
        updateAllViews()
    }
    
    @IBAction func subtractIceCubeFromMixButtonPressed(sender: UIButton) {
        if iceCubesMixed > 0 {
            iceCubesMixed--
            iceCubeCount++
        }
        else {
            showAlertWithText("Mix", message: "You cannot mix negative ice cubes!")
        }
        updateAllViews()
    }
    
    func updateAllViews () {
        updatePurchaseLabels()
        updateMixLabels()
        updateStatusView()
    }
    
    func updateStatusView () {
        self.balanceLabel.text = "$\(balance)"
        self.lemonCountLabel.text = "\(lemonCount)"
        self.iceCubeCountLabel.text = "\(iceCubeCount)"
    }
    
    func updatePurchaseLabels () {
        self.lemonsPurchasedLabel.text = "\(lemonsPurchased)"
        self.iceCubesPurchasedLabel.text = "\(iceCubesPurchased)"
    }
    
    func updateMixLabels () {
        self.lemonMixLabel.text = "\(lemonsMixed)"
        self.iceCubeMixLabel.text = "\(iceCubesMixed)"
    }
    
    func showAlertWithText (header:String = "Warning", message:String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkForLemonTheft () -> Bool {
        if lemonCount - 1 < 0 {
            return true
        }
        return false
    }
    
    func checkForIceCubeTheft () -> Bool {
        if iceCubeCount - 1 < 0 {
            return true
        }
        return false
    }
    
    func startNewDay () {
        lemonadeAcidityRatio = Double(lemonsMixed) / Double(iceCubesMixed)
        print("Lemonade Acidity Ratio: \(lemonadeAcidityRatio)")
        
        randomNumberOfCustomers = Int(arc4random_uniform(UInt32(20)))
        var customers:[Customer] = []
        
        switch weather {
        case 0:
            weatherImageView.image = UIImage(named: "Cold")
            randomNumberOfCustomers -= 3
        case 1:
            weatherImageView.image = UIImage(named: "Mild")
        case 2:
            weatherImageView.image = UIImage(named: "Warm")
            randomNumberOfCustomers += 5
        default:
            weatherImageView.image = UIImage(named: "Mild")
        }
        
        print("Potential Customers: \(randomNumberOfCustomers)")
        
        if randomNumberOfCustomers > 0 {
            for var i = 0; i < randomNumberOfCustomers; i++ {
                let randomTasteNumber = Int(arc4random_uniform(UInt32(10)))
                var generatedCustomer = Customer()
                
                switch randomTasteNumber {
                case 0:
                    generatedCustomer.tastePreference = kTasteZero
                case 1:
                    generatedCustomer.tastePreference = kTasteOne
                case 2:
                    generatedCustomer.tastePreference = kTasteTwo
                case 3:
                    generatedCustomer.tastePreference = kTasteThree
                case 4:
                    generatedCustomer.tastePreference = kTasteFour
                case 5:
                    generatedCustomer.tastePreference = kTasteFive
                case 6:
                    generatedCustomer.tastePreference = kTasteSix
                case 7:
                    generatedCustomer.tastePreference = kTasteSeven
                case 8:
                    generatedCustomer.tastePreference = kTasteEight
                case 9:
                    generatedCustomer.tastePreference = kTasteNine
                default:
                    generatedCustomer.tastePreference = kTasteOne
                }
                
                print("\(generatedCustomer.tastePreference)")
                customers.append(generatedCustomer)
            }
            
            for customer in customers {
                if customer.tastePreference < kTasteFour && lemonadeAcidityRatio > 1.0 {
                    balance++
                    print("Paid $1!")
                    customersWhoPurchasedLemonade++
                }
                else if customer.tastePreference >= kTasteFour && customer.tastePreference <= kTasteSix && lemonadeAcidityRatio == 1.0 {
                    balance++
                    print("Paid $1!")
                    customersWhoPurchasedLemonade++
                }
                else if customer.tastePreference > kTasteSix && lemonadeAcidityRatio < 1 {
                    balance++
                    print("Paid $1!")
                    customersWhoPurchasedLemonade++
                }
                else {
                    print("No match, no revenue.")
                }
            }
            
            print("Paying Customers: \(customersWhoPurchasedLemonade)")
        }
        else {
            print("No customers today.")
        }
        
        showAlertWithText("Daily Summary", message: "Paying Customers: \(customersWhoPurchasedLemonade)")
    }
    
    func setNextDayWeather() {
        print("")
        
        let randomWeather = Int(arc4random_uniform(UInt32(3)))
        switch randomWeather {
        case 0:
            weatherImageView.image = UIImage(named: "Cold")
            weather = 0
            randomNumberOfCustomers -= 3
            print("Weather: Cold")
        case 1:
            weatherImageView.image = UIImage(named: "Mild")
            weather = 1
            print("Weather: Mild")
        case 2:
            weatherImageView.image = UIImage(named: "Warm")
            weather = 2
            randomNumberOfCustomers += 5
            print("Weather: Warm")
        default:
            weatherImageView.image = UIImage(named: "Mild")
            weather = 1
            print("Weather: Mild")
        }
    }
    
    func resetDay () {
        lemonsPurchased = 0
        iceCubesPurchased = 0
        
        lemonsMixed = 0
        iceCubesMixed = 0
        
        customersWhoPurchasedLemonade = 0
    }
}
