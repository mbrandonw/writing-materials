
enum Nat {
  case Zero
  case Succ(@autoclosure() -> Nat)
}

extension Nat : Printable {
  var description: String {
    get { return self.toInt().description }
  }
}

extension Nat : IntegerLiteralConvertible {
  init(integerLiteral value: IntegerLiteralType) {
    self = Nat.fromInt(value)
  }

  func toInt () -> Int {
    return self.toInt(0)
  }

  static func fromInt (n: Int) -> Nat {
    return Nat.fromInt(n, accum: .Zero)
  }

  private func toInt(n: Int) -> Int {
    switch self {
    case .Zero: return n
    case let .Succ(succ):
      return succ().toInt(n+1)
    }
  }

  private static func fromInt (n: Int, accum: Nat) -> Nat {
    if n == 0 {
      return accum
    }
    return Nat.fromInt(n-1, accum: .Succ(accum))
  }
}

func + (a: Nat, b: Nat) -> Nat {
  switch (a, b) {
  case let (_, .Zero):
    return a
  case let (.Zero, _):
    return b
  case let (.Succ(pred), _):
    return pred() + .Succ(b)
  }
}

func * (a: Nat, b: Nat) -> Nat {
  switch (a, b) {
  case (_, .Zero), (.Zero, _):
    return .Zero
  case let (.Succ(pred), _):
    return b + pred() * b
  }
}

func ^ (a: Nat, b: Nat) -> Nat {
  switch (a, b) {
  case (_, .Zero):
    return .Succ(.Zero)
  case (.Zero, _):
    return .Zero
  case let (_, .Succ(pred)):
    return a * (a ^ pred())
  default:
    // The compiler is forcing me to put
    // this default case even though all
    // of the cases are covered :/
    return .Zero
  }
}

extension Nat : Equatable {}
func == (a: Nat, b: Nat) -> Bool {
  switch (a, b) {
  case (.Zero, .Zero):
    return true
  case (.Zero, .Succ), (.Succ, .Zero):
    return false
  case let (.Succ(preda), .Succ(predb)):
    return preda() == predb()
  }
}

// Create a few values in Nat
let zero = Nat.Zero
let one: Nat = .Succ(.Zero)
let two: Nat = .Succ(one)
let three: Nat = .Succ(two)
let four: Nat = .Succ(three)
let five: Nat = .Succ(.Succ(.Succ(.Succ(.Succ(.Zero)))))

// Play around with arithmetic
(one + one).description
(four + three).description
((four + three) * two).description
(three ^ four).description

// Play around with equality
one == one
two == one
(one + three) == (two + two)

// Play around with literal integer conversion
let oneHundred: Nat = 100
(oneHundred + oneHundred).description

"done"
