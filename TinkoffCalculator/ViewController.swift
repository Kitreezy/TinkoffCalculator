//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Artem Rodionov on 21.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return
        }
        print("Button pressed: \(buttonText)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }


}

