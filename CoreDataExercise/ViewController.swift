//
//  ViewController.swift
//  CoreDataExercise
//
//  Created by student on 3/9/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var typeRecordTF: UITextField!
    @IBOutlet weak var displayRecordLabel: UILabel!
    
    var dataManager: NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        dataManager = appDelegate.persistentContainer.viewContext
        displayRecordLabel.text?.removeAll()
        fetchData()
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        
        do {
            let result = try dataManager.fetch(fetchRequest)
            
            listArray = result as! [NSManagedObject]
            
            for item in listArray {
                let product = item.value(forKey: "about") as! String
                
                displayRecordLabel.text! += product
            }
        }
        catch {
            print("Error retrieving the data")
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        let deleteItem = typeRecordTF.text!
        
        for item in listArray {
            if item.value(forKey: "about") as! String == deleteItem {
                dataManager.delete(item)
            }
            
            do {
                try self.dataManager.save()
            }
            catch {
                print("Error deleting the data")
            }
            displayRecordLabel.text?.removeAll()
            typeRecordTF.text?.removeAll()
            fetchData()
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: dataManager)
        
        newEntity.setValue(typeRecordTF.text!, forKey: "about")
        
        do {
            try self.dataManager.save()
            listArray.append(newEntity)
        }
        catch {
            print("Error saving the data")
        }
        displayRecordLabel.text?.removeAll()
        typeRecordTF.text?.removeAll()
        fetchData()
    }
}
