import UIKit

class Diet2BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Not Okay to Eat"
    let items = [
                    "FOODS THAT MAY CONTAIN DAIRY:",
                    "Baked goods",
                    "Butter",
                    "Buttermilk",
                    "Casein",
                    "Cheese",
                    "Chocolate",
                    "Condensed milk",
                    "Cottage cheese",
                    "Cream",
                    "Cream cheese",
                    "Curd",
                    "Custard",
                    "Evaporated milk",
                    "Ghee",
                    "Goat’s milk",
                    "Gravy",
                    "Half & half",
                    "Ice cream",
                    "Lactose",
                    "Margarine",
                    "Milk",
                    "Milk powder",
                    "Pastries",
                    "Pudding",
                    "Salad dressing",
                    "Sheep’s milk",
                    "Sour cream",
                    "Whey",
                    "Yogurt",
                    "FOODS THAT MAY CONTAIN GLUTEN:",
                    "Bread and bread products",
                                "Bagels",
                                "Baked goods",
                                "Barley",
                                "Battered and fried foods",
                                "Bran",
                                "Bulgur",
                                "Cereal",
                                "Couscous",
                                "Crackers",
                                "Durum",
                                "Einkorn",
                                "English muffins",
                                "Farina",
                                "Farro",
                                "Flour",
                                "Flour tortillas",
                                "Gravy or sauces containing a roux",
                                "Licorice",
                                "Naan",
                                "Oats",
                                "Pasta",
                                "Pancakes",
                                "Pastries",
                                "Pita",
                                "Rye",
                                "Sauces",
                                "Semolina",
                                "Spelt",
                                "Soy sauce",
                                "Triticale",
                                "Waffles",
                                "Wheat"
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
