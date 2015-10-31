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
            Add an event handler using the addAction:name:controlEvents: method added by λ.swift.
            */
            button.addAction(controlEvents: .TouchUpInside) {
                self.greeting.text = "Hello \(name)"
            }
        }
    }
}