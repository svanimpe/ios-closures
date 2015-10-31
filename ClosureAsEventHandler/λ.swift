import UIKit

/*
Utility class that allows closures to be used in the target-action pattern.
*/
class λ: NSObject
{
    /*
    This optional name is needed only when you want to remove this particular action (and no
    others) from the control.
    */
    private let name: String?
    
    /*
    The actual code to be executed.
    */
    private let code: Void -> Void
    
    /*
    Since adding a target-action to a control does not retain the target object, we need a way
    for the λ object to retain itself. This closure will reference self, thereby retaining it.
    An implicitly wrapped optional is used here because the closure can only be initialized
    in phase two of two-phase initialization, when self is available.
    */
    private var keepAlive: (Void -> Void)?
    
    init(name: String? = nil, code: Void -> Void) {
        self.name = name
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
    
    /*
    Break the reference cycle between the λ object and its keepAlive closure so the λ object
    can be released from memory.
    */
    func remove() {
        keepAlive = nil
    }
}

/*
Extensions to UIControl that allow λ objects to be used in a user-friendly way.
Even without these extensions, λ objects can be used in the target-action pattern as follows:
control.addTarget(λ { your code }, action: "action", forControlEvents: .SomeEvent)
*/
public extension UIControl
{
    /*
    Add an action closure to a control. This will create a λ object using the given name and
    action closure, and add it to the control's dispatch table using addTarget:action:forControlEvents:.
    This method will retain the created λ object.
    */
    public func addAction(name: String? = nil, controlEvents: UIControlEvents, action: Void -> Void) {
        addTarget(λ(name: name, code: action), action: "action", forControlEvents: controlEvents)
    }
    
    /*
    Remove the action closure with the given name from the control's dispatch table. If no name is
    specified, all unnamed action closures for the given control events will be removed.
    This method will release the removed λ objects from memory.
    */
    public func removeAction(name: String? = nil, controlEvents: UIControlEvents) {
        for target in allTargets() {
            if let target = target as? λ where target.name == name {
                removeTarget(target, action: "action", forControlEvents: .TouchUpInside)
                target.remove()
            }
        }
    }
}