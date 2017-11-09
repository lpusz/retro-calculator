//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Łukasz Pusz on 01.11.2017.
//  Copyright © 2017 Łukasz Pusz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var outputLabel: UILabel!
    
    private enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    private var btnSound: AVAudioPlayer!
    private var runningNumber = ""
    private var currentOperation = Operation.Empty
    private var leftVal = ""
    private var rightVal = ""
    private var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(operation: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(operation: Operation.Multiply)
    }
    
    @IBAction func onSubstractPressed(sender: UIButton) {
        processOperation(operation: Operation.Substract)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(operation: Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        currentOperation = Operation.Empty
        leftVal = ""
        rightVal = ""
        result = ""
        runningNumber = ""
        outputLabel.text = "0"
    }
    
    private func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    private func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftVal)! * Double(rightVal)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftVal)! / Double(rightVal)!)"
                } else if currentOperation == Operation.Substract {
                    result = "\(Double(leftVal)! - Double(rightVal)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftVal)! + Double(rightVal)!)"
                }
                
                leftVal = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        } else {
            leftVal = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
}

