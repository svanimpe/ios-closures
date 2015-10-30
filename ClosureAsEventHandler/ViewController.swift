import UIKit

class ViewController: UIViewController
{
    let names = ["Alice", "Bob", "Charlie", "David"]
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var greeting: UITextField!
    
    override func viewDidLoad() {
        
        /*
        Clear the placeholder row from the storyboard and remove the placeholder greeting text.
        */
        for row in stack.arrangedSubviews {
            row.removeFromSuperview()
        }
        greeting.text = nil
        
        for name in names {
            
            /*
            Create a label and a button for every name, group them together in a horizontal stack,
            and add this stack to the main (vertical) stack.
            */
            let label = UILabel()
            label.text = name
            let button = UIButton(type: .System)
            button.setTitle("Greet", forState: .Normal)
            let row = UIStackView(arrangedSubviews: [label, button])
            row.distribution = .EqualSpacing
            stack.addArrangedSubview(row)
            
            /*
            And now for the interesting part:
            A λ object is used as the target object. Because the initializer of the λ class has a single closure as an attribute,
            we can use trailing closure syntax. The result is a clean syntax that has only one additional character, compared to
            a regular closure.
            Note that the action parameter is missing. When using the λ class, this action selector is always "action" so I extended
            UIControl to add an overload of addTarget where "action" is the default action selector.
            */
            button.addTarget(λ { self.greeting.text = "Hello, \(name)" }, forControlEvents: .TouchUpInside)
            
            /*
            Next, I extended UIControl again to add a new method that takes a regular closure as it's final parameter, again to allow
            for trailing closure syntax to be used. The method will wrap this closure with a λ object for us.
            */
            button.addActionForControlEvents(.TouchUpInside) {
                self.greeting.text = "Hello, \(name)"
            }
        }
    }
}