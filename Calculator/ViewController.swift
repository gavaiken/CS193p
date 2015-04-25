import Darwin
import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var history: UILabel!

  var userIsTypingNumber: Bool = false
  let brain = CalculatorBrain()

  @IBAction func clearState(sender: UIButton) {
    println("clear")
    display.text = "0"
    history.text = ""
    userIsTypingNumber = false
    brain.clear()
  }

  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!;
    println("digit = \(digit)")
    if (userIsTypingNumber) {
      display.text = display.text! + digit;
    } else {
      userIsTypingNumber = true;
      display.text = digit;
    }
  }

  @IBAction func appendPoint(sender: UIButton) {
    println("decimal point")
    let decimalPoint = "."
    if (userIsTypingNumber) {
      display.text = display.text! + decimalPoint;
    } else {
      userIsTypingNumber = true;
      display.text = "0" + decimalPoint;
    }
  }

  @IBAction func pushPi(sender: UIButton) {
    println("push π")
    if (userIsTypingNumber) {
      enter()
    }
    display.text = M_PI.description
    enter()
  }

  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!;
    // If they were typing a number then we can push the operand.
    if (userIsTypingNumber) {
      enter()
    }
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
      } else {
        displayValue = 0
      }
    }
    history.text = brain.description
  }

  @IBAction func enter() {
    userIsTypingNumber = false;
    if let result = brain.pushOperandValue(displayValue) {
      displayValue = result
    } else {
      displayValue = 0
    }
    history.text = brain.description
  }

  var displayValue: Double {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      display.text = "\(newValue)"
      userIsTypingNumber = false
    }
  }
}

