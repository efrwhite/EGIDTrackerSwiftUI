import UIKit

class Diet4BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Not Okay to Eat"
    let items = [
        "Dairy: Milk, Butter, Cream, Buttermilk, Half & half, Yogurt, Cheese, Ice cream, Sour cream, Cottage cheese, Chocolates and candy, “Whey” listed in ingredients, “Casein” listed in ingredients",
        "Gluten: Flour, Bread and bread products, Baked goods like muffins, biscuits, cakes, cookies, Pasta, Couscous, Oats *due to cross-contamination with wheat, Soy sauce, Gravy and other sauces containing a roux, Breaded/battered fried foods, Foods containing wheat, rye, or barley",
        "Egg: Eggs and egg products, Baked goods containing egg or with egg washes, Pancakes and waffles, Battered fried foods, Mayonnaise, Meatloaf and meatballs, Marshmallow, Some ice creams, Some salad dressings",
        "Soy: Tofu and tempeh, Edamame, Soy milk and products made from soymilk (yogurt, ice cream, etc.), Soy sauce, Teriyaki sauce, Many processed/packaged foods"
    ]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
