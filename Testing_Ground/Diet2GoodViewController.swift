import UIKit

class Diet2GoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Okay to Eat"
    let items = [
        "Milk alternatives like almond, soy, coconut, oat, cashew, and rice",
        "Yogurt made from milk alternatives",
        "Ice cream made from milk alternatives",
        "Dairy-free cheese made from nuts",
        "Plant-based butter",
        "Dairy-free sour cream",
        "Foods labeled “Vegan”, “Plant Based” or “Dairy Free”",
        "Rice *check ingredients on boxed rice mixes",
        "Rice crackers and rice cakes",
        "Potato chips",
        "Popcorn",
        "Corn tortillas",
        "Gluten-free oats",
        "Gluten-free pasta made from rice, chickpea, and lentil",
        "Gluten-free bread",
        "Gluten-free wraps made from almond, chickpea, cassava",
        "Gluten-free flours like oat, almond, coconut, and gluten-free all-purpose flour",
        "Foods labeled “Gluten Free” or “Grain Free”"
    ]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set up automatic row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0 // Allow unlimited lines
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
}
