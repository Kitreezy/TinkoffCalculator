//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Artem Rodionov on 21.02.2024.
//


import UIKit
import Foundation

enum CalculationError: Error {
    case divideByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.divideByZero
            }
            
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" && buttonText != "," {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
        
        
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard 
            let buttonText = sender.titleLabel?.text,
            let buttonOperation = Operation(rawValue: buttonText)
            else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberForamatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        
        resetLabelText()
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberForamatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            label.text = numberForamatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }
    
    @IBOutlet weak var label: UILabel!
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    lazy var numberForamatter: NumberFormatter = {
       let numberForrmatter = NumberFormatter()
        
        numberForrmatter.usesGroupingSeparator = false
        numberForrmatter.locale = Locale(identifier: "ru_RU")
        numberForrmatter.numberStyle = .decimal
        
        return numberForrmatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        resetLabelText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentReuslt = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard 
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
                else { break }
            
            currentReuslt = try operation.calculate(currentReuslt, number)
        }
        
        return currentReuslt
    }

    func resetLabelText() {
        label.text = "0"
    }

}

