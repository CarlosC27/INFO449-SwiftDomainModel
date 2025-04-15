import Foundation

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount:Int
    var currency:String
    
    init(amount: Int, currency: String) {
        let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
        if validCurrencies.contains(currency){
            self.currency = currency
        }else{
            self.currency = "USD"
        }
        self.amount = amount
        
    }
    
    func convert(_ newCurrency: String) -> Money{
        var usdAmount: Double
        var finalAmount: Int
        
        switch currency{
        case "USD": usdAmount = Double(amount)
        case "GBP": usdAmount = Double(amount) * 2.0
        case "EUR": usdAmount = Double(amount) / 1.5
        case "CAN": usdAmount = Double(amount) / 1.25
        default: fatalError("Unsupported currency")
        }
        
        switch newCurrency{
        case "USD": finalAmount = Int(round(usdAmount))
        case "GBP": finalAmount = Int(round(usdAmount * 0.5))
        case "EUR": finalAmount = Int(round(usdAmount * 1.5))
        case "CAN": finalAmount = Int(round(usdAmount * 1.25))
        default: fatalError("Unsupported currency")
        }
        
        return Money(amount: finalAmount, currency: newCurrency)
        
    }
    
    func add(_ addMoney: Money) -> Money {
        let usdAmount1 = self.convert("USD").amount
        let usdAmount2 = addMoney.convert("USD").amount
        let total = usdAmount1 + usdAmount2
        return Money(amount: total, currency: "USD").convert(addMoney.currency)
    }
    
    func subtract(_ subtractMoney: Money) -> Money {
        let usdAmount1 = self.convert("USD").amount
        let usdAmount2 = subtractMoney.convert("USD").amount
        let diff = usdAmount1 - usdAmount2
        return Money(amount: diff, currency: "USD").convert(subtractMoney.currency)
    }

}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
        }
    
    func calculateIncome(_ hours: Int = 2000) -> Int {
        switch type {
        case .Hourly(let rate): return Int(rate * Double(hours))
        case .Salary(let salary): return Int(salary)
        }
    }

    func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate + amount)
        case .Salary(let salary):
            let increasedSalary = UInt(Double(salary) + amount)
            type = .Salary(increasedSalary)
        }
    }

    func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate * (1 + percent))
        case .Salary(let salary):
            let increasedSalary = UInt(Double(salary) * (1 + percent))
            type = .Salary(increasedSalary)
        }
    }
    
    
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName:String
    var lastName:String
    var age:Int
    private var _job: Job?
    var job: Job? {
        get {return _job}
        set {
            if age >= 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }
    private var _spouse: Person?
    var spouse:Person? {
        get {return _spouse}
        set {
            if age >= 16 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
    init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    func toString() -> String {
        return "[Person: firstName:\(String(describing: firstName)) lastName:\(String(describing: lastName)) age:\(String(describing: age)) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var familyMembers: [Person]
    init(spouse1: Person, spouse2: Person) {
        self.familyMembers = [spouse1, spouse2]
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    func haveChild(_ child: Person) -> Bool {
        if (familyMembers[0].age > 21 || familyMembers[1].age > 21)  {
            familyMembers.append(child)
            return true
        }
        return false
    }
    func householdIncome() -> Int {
        var totalIncome = 0
        for person in familyMembers {
            if let job = person.job {
                switch job.type {
                case .Hourly(let wage): totalIncome += Int(wage * 2000)
                case .Salary(let salary):totalIncome += Int(salary)
                }
            }
        }
        return totalIncome
    }
}
