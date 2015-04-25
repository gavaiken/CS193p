import Foundation

class CalculatorBrain : Printable {
  private enum Op : Printable {
    case Operand(Double)
    case UnaryOperation(String, Double->Double)
    case BinaryOperation(String, (Double,Double)->Double)

    var description : String {
      get {
        switch(self) {
        case Operand(let value):
          return value.description
        case UnaryOperation(let symbol, _):
          return symbol
        case BinaryOperation(let symbol, _):
          return symbol
        }
      }
    }
  }

  private var opStack = [Op]()
  private var knownOps = [String:Op]()

  init() {
    knownOps["+"] = Op.BinaryOperation("+", +)
    knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
    knownOps["x"] = Op.BinaryOperation("x", *)
    knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
    knownOps["√"] = Op.UnaryOperation("√", sqrt)
    knownOps["cos"] = Op.UnaryOperation("cos", cos)
    knownOps["sin"] = Op.UnaryOperation("sin", sin)
  }

  func pushOperandValue(value: Double) -> Double? {
    opStack.append(Op.Operand(value));
    return evaluate()
  }

  func performOperation(symbol: String) -> Double? {
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    } else {
      assert(false, "Unknown operation: \(symbol)")
    }
    return evaluate()
  }

  func clear() {
    opStack = [Op]()
  }

  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack)
    println("\(opStack) = \(result) with \(remainder) left over")
    return result
  }

  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    if !ops.isEmpty {
      // Get a mutable copy of the stack.
      var remainingOps = ops
      let op = remainingOps.removeLast()

      // Take action depending on the type of operand/operator.
      switch op {
      case .Operand(let value):
        return (value, remainingOps)
      case .UnaryOperation(_, let operation):
        // Evaluate the argument to pass.
        let eval = evaluate(remainingOps)
        if let res = eval.result {
          let calculatedValue = operation(res)
          return (calculatedValue, eval.remainingOps)
        }
      case .BinaryOperation(_, let operation):
        let leftEval = evaluate(remainingOps)
        if let left = leftEval.result {
          let rightEval = evaluate(leftEval.remainingOps)
          if let right = rightEval.result {
            let res = operation(left, right)
            return (res, rightEval.remainingOps)
          }
        }
      }
    }
    return (nil, ops);
  }

  var description : String {
    return "\(opStack)"
  }
}
