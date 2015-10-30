import UIKit

/*
Utility class that allows closures to be used as targets in the target-action pattern.
*/
class λ: NSObject
{
    /*
    The actual code to be executed.
    */
    private let code: Void -> Void
    
    /*
    Since adding a target to a control does not retain the target object, we need a way
    for the object to retain itself. This closure will reference self, thereby retaining it.
    An implicitly wrapped optional is used here because the closure can only be initialized
    in phase two of two-phase initialization, when self is available.
    */
    private var keepAlive: (Void -> Void)!
    
    init(code: Void -> Void) {
        self.code = code
        super.init()
        
        /*
        Now that self is available, keepAlive can be set to a closure that references self.
        By referencing self, this closure will keep the λ object in memory.
        */
        keepAlive = { self }
    }
    
    /*
    Execute the code closure. This will be the action method in the target-action pattern.
    */
    func action() {
        code()
    }
}

/*
Extensions to UIControl that allow λ objects to be used in a more user-friendly way.
Even without these extensions, λ objects can be used in the target-action pattern as follows:
control.addTarget(λ { your code }, action: "action", forControlEvents: .SomeEvent)
*/
public extension UIControl
{
    /*
    Removes the need to specify "action" as the action selector.
    */
    public func addTarget(target: AnyObject?, forControlEvents controlEvents: UIControlEvents) {
        addTarget(target, action: "action", forControlEvents: controlEvents)
    }
    
    /*
    Removes the need to use λ in front of the closure by automatically wrapping it with a
    λ object. Also allows trailing closure syntax.
    */
    public func addActionForControlEvents(controlEvents: UIControlEvents, action: Void -> Void) {
        addTarget(λ(code: action), forControlEvents: controlEvents)
    }
}