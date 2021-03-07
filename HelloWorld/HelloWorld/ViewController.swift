//
//  ViewController.swift
//  HelloWorld
//
//  Created by Isabella Tassone on 3/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "You've got it! Welcome to My First App", message: "Hello World :)", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    @IBAction func showMessage1(sender: UIButton) {
        let alertController = UIAlertController(title: "Not this one", message: "Try again!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    @IBAction func showMessage2(sender: UIButton) {
        let alertController = UIAlertController(title: "Wrong button!", message: "Try again!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    @IBAction func showMessage3(sender: UIButton) {
        let alertController = UIAlertController(title: "Sadly, no.", message: "Try again!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    @IBAction func showMessage4(sender: UIButton) {
        let alertController = UIAlertController(title: "Oof, nice try but no", message: "Try again!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }



