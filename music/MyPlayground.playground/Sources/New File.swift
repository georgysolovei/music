import Foundation

import RxSwift

public func example(_ rxOperator:String, action: ()->()) {
    
    print("\n---------- Example of", rxOperator, "----------")
    
    action()
    
}



public enum MyError: Error {
    
    case anError
    
}



public func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    
    print(label, event.element ?? event.error ?? event)
    
}
