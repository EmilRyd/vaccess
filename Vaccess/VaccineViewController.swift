//
//  VaccineViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-11.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//
import os.log
import UIKit

class VaccineViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var vaccintypTextruta: UITextField!
    @IBOutlet weak var dosEtikett: UILabel!
    @IBOutlet weak var dosTextruta: UITextField!
    @IBOutlet weak var startdatumTextruta: UITextField!
    @IBOutlet weak var slutdatumTextruta: UITextField!
    @IBOutlet weak var slutdatumEtikett: UILabel!
    @IBOutlet weak var sparaKnapp: UIBarButtonItem!
    @IBOutlet weak var nästaDosDatumEtikett: UILabel!
    @IBOutlet weak var nästaDosDatumTextruta: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var nextDoseDatePicker = UIDatePicker()
    var dosePicker = UIPickerView()
    let datumsFormat = DateFormatter()
    var startdatum = Date()
    var slutdatum = Date()
    var endDateWasManuallyChosen = false
    var vaccination: Vaccination?
    var valdRad: Int!
    let vacciner = Vaccine.allValues
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Fixa layoute
        slutdatumTextruta.isEnabled = true
        dosEtikett.isHidden = true
        dosTextruta.isHidden = true
        nästaDosDatumEtikett.isHidden = true
        nästaDosDatumTextruta.isHidden = true
        
        
        // Skapa vaccin-pickern
        let vaccinVäljare = UIPickerView()
        
        vaccinVäljare.delegate = self
        
        vaccintypTextruta.inputView = vaccinVäljare
        
        // Skapa dos-pickern
        
        dosePicker.delegate = self
        
        dosTextruta.inputView = dosePicker

        // Skapa datum-pickern
        startDatePicker.datePickerMode = .date
        
        // Se till att textrutan påverkas när datumet ändras av användaren
        startDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        
        // Gör det möjligt för användaren att stänga av väljaren
        let tryckGest = UITapGestureRecognizer(target: self, action: #selector(VaccineViewController.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tryckGest)
        
        // Sätt datumVäljare som input till textrutan
        startdatumTextruta.inputView = startDatePicker
        
        // Do any additional setup after loading the view.
        
        // Skapa datum-pickern
        endDatePicker.datePickerMode = .date
        
        // Se till att textrutan påverkas när datumet ändras av användaren
        endDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        
        // Sätt datumVäljare som input till textrutan
        slutdatumTextruta.inputView = endDatePicker
        
        
        
        // Skapa datum-pickern
        nextDoseDatePicker.datePickerMode = .date
        
        // Se till att textrutan påverkas när datumet ändras av användaren
        nextDoseDatePicker.addTarget(self, action: #selector(VaccineViewController.dateChanged(datumVäljare:)), for: .valueChanged)
        
        // Sätt datumVäljare som input till textrutan
        nästaDosDatumTextruta.inputView = nextDoseDatePicker
        
        // Make sure the saveButton is disabled in the beginning
        updateSaveButtonState()
        
        // Fix delegacy
        vaccintypTextruta.delegate = self
        startdatumTextruta.delegate = self
        
        // Set up views if editing an existing Vaccination.
        if let vaccination = vaccination {
            if vaccination.vaccine.getTotalAmountOfDoses() == 1 {
            slutdatumTextruta.isHidden = false
            slutdatumEtikett.isHidden = false
            navigationItem.title = vaccination.vaccine.rawValue
            vaccintypTextruta.text   = vaccination.vaccine.rawValue
            
            datumsFormat.dateFormat = "dd/MM - yyyy"
            startdatumTextruta.text = datumsFormat.string(from: vaccination.startDate)
            let endDate = vaccination.getEndDate(amountOfDosesTaken: nil)
            if endDate == nil {
                switch vaccination.vaccine.protection(amountOfDosesTaken: nil) {
                case .unknown:
                    slutdatumTextruta.text = "Skyddstiden inte bestämd ännu. Fråga din läkare och fyll i själv."
                case .lifeLong:
                    slutdatumTextruta.text = "Du är skyddad för resten av livet!"
                default:
                    fatalError("Unknown Protecttion value.")
            }
            }
            else {
                slutdatumTextruta.text = datumsFormat.string(from: endDate!)
            }
            updateSaveButtonState()

        }
            else {
                navigationItem.title = vaccination.vaccine.rawValue
                vaccintypTextruta.text   = vaccination.vaccine.rawValue
                slutdatumEtikett.isHidden = true
                slutdatumTextruta.isHidden = true
                dosEtikett.isHidden = false
                dosTextruta.isHidden = false
                dosTextruta.text = String(vaccination.amountOfDosesTaken!)
                nästaDosDatumTextruta.isHidden = false
                nästaDosDatumEtikett.isHidden = false
                datumsFormat.dateFormat = "dd/MM - yyyy"
                startdatumTextruta.text = datumsFormat.string(from: vaccination.startDate)
                datumsFormat.dateFormat = "dd/MM - yyyy"
                startdatumTextruta.text = datumsFormat.string(from: vaccination.startDate)
                let endDate = vaccination.getEndDate(amountOfDosesTaken: vaccination.amountOfDosesTaken)
                if endDate == nil {
                    switch vaccination.vaccine.protection(amountOfDosesTaken: vaccination.amountOfDosesTaken) {
                    case .unknown:
                        nästaDosDatumTextruta.text = "Skyddstiden inte bestämd ännu. Fråga din läkare och fyll i själv."
                    case .lifeLong:
                        nästaDosDatumTextruta.text = "Du är skyddad för resten av livet!"
                    default:
                        fatalError("Unknown Protecttion value.")
                }
                }
                else {
                    nästaDosDatumTextruta.text = datumsFormat.string(from: endDate!)
                }
                updateSaveButtonState()
            }
        }
    }
    
    //MARK: UIDatePicker and UIPickerView methods
    
    @objc func dateChanged (datumVäljare: UIDatePicker) {
        
        datumsFormat.dateFormat = "dd/MM - yyyy"
        
        if datumVäljare === startDatePicker {
            startdatum = datumVäljare.date
            startdatumTextruta.text = datumsFormat.string(from: startdatum)
            
            let checkVaccintypTextruta = vaccintypTextruta.text ?? ""
            if !checkVaccintypTextruta.isEmpty {
                vaccination = Vaccination(vaccine: Vaccine(rawValue: (vaccintypTextruta!.text!))!, startDate: startdatum, amountOfDosesTaken: nil)
                if vaccination?.vaccine.endDate(startDate: startdatum, amountOfDosesTaken: nil) != nil {
                    slutdatumTextruta.text = datumsFormat.string(from: (vaccination?.vaccine.endDate(startDate: startdatum, amountOfDosesTaken: nil)!)!)
                }
                else {
                    if dosTextruta.isHidden {
                        slutdatum(startdatum: startdatum)
                    }
                    else {
                        dosTextruta.text = nil
                        nästaDosDatumTextruta.text = nil
                    }
                }
            }
        }
        else if datumVäljare === endDatePicker {
            slutdatumTextruta.text = ""
            slutdatum = datumVäljare.date
            slutdatumTextruta.text = datumsFormat.string(from: datumVäljare.date)
            endDateWasManuallyChosen = true
        }
        
        else if datumVäljare === nextDoseDatePicker {
            nästaDosDatumTextruta.text = ""
            nästaDosDatumTextruta.text = datumsFormat.string(from: datumVäljare.date)
            endDateWasManuallyChosen = true
        }
    
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        view.endEditing(true)
        if valdRad != nil {
            if !vacciner[valdRad].takenOnce() {
                slutdatumEtikett.isHidden = true
                slutdatumTextruta.isHidden = true
                
                dosEtikett.isHidden = false
                dosTextruta.isHidden = false
            }
        }
        
       
    }
    
    // HEJ EMIL! 9/14. Imorgon kan du börja skriva in massa if och switchsatser för olika vaccin folk väljer. Om de väljer något som de ska ta igen, så sätt upp ett ungefärligt nästa-datum, men låt dde också få välja själva.
    
    //MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === dosePicker {
            if vaccination?.vaccine.getTotalAmountOfDoses() != nil {
                return vaccination?.vaccine.getTotalAmountOfDoses() ?? 5
            }
            else {
                return 5
            }
        }
        else {
            return vacciner.count
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === dosePicker {
            return String(row + 1)
        }
        else {
            return vacciner[row].simpleDescription()
        
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dosePicker {
            dosTextruta.text = String(row + 1)
            vaccination?.amountOfDosesTaken = row+1
            nästaDosDatumTextruta.isHidden = false
            nästaDosDatumEtikett.isHidden = false
            switch vaccination?.vaccine.protection(amountOfDosesTaken: vaccination?.amountOfDosesTaken){
            case .time(_):
                nästaDosDatumTextruta.text = datumsFormat.string(from: (vaccination?.vaccine.endDate(startDate: vaccination!.startDate, amountOfDosesTaken: row+1))!)
            case .unknown:
                nästaDosDatumTextruta.text = "Skyddstiden inte bestämd ännu. Fråga din läkare och fyll i själv."
            case .lifeLong:
                nästaDosDatumTextruta.text = "Du är skyddad för resten av livet!"
            default:
                nästaDosDatumTextruta.text = "Jag vet inte, men du har någon bugg i din vaccine.protection metod"
            }
        }
        else {
            valdRad = row
            navigationItem.title = vacciner[row].simpleDescription()
            vaccintypTextruta.text = vacciner[row].simpleDescription()
            startdatumTextruta.text = nil
            slutdatumTextruta.text = nil
            
            if vacciner[row].takenOnce() {
                nästaDosDatumTextruta.isHidden = true
                nästaDosDatumEtikett.isHidden = true
                dosEtikett.isHidden = true
                dosTextruta.isHidden = true
                slutdatumTextruta.isHidden = false
                slutdatumEtikett.isHidden = false
            }
            else {
                dosEtikett.isHidden = false
                dosTextruta.isHidden = false
                
                nästaDosDatumTextruta.isHidden = false
                nästaDosDatumEtikett.isHidden = false
                
                slutdatumTextruta.isHidden = true
                slutdatumEtikett.isHidden = true
                
                
                nästaDosDatumTextruta.text = nil
                dosTextruta.text = nil
            }
        }

        
        
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sparaKnapp.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddVaccinationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddVaccinationMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The VaccineViewController is not inside a navigation controller.")
        }

    
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let knapp = sender as? UIBarButtonItem, knapp === sparaKnapp else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let namn = vaccintypTextruta.text ?? ""
        startdatum = datumsFormat.date(from: startdatumTextruta.text!)!
        if dosEtikett.isHidden {
            // Set the meal to be passed to VaccineTableViewController after the unwind segue.
            vaccination = Vaccination(vaccine: Vaccine(rawValue: namn)!, startDate: startdatum, amountOfDosesTaken: nil)
        }
        else if !dosEtikett.isHidden {
            vaccination = Vaccination(vaccine: Vaccine(rawValue: namn)!, startDate: startdatum, amountOfDosesTaken: Int(dosTextruta.text!))

        }
        switch vaccination?.vaccine.protection(amountOfDosesTaken: vaccination?.amountOfDosesTaken) {
        case .time:
            if dosEtikett.isHidden {
                slutdatum = datumsFormat.date(from: slutdatumTextruta.text!)!
                vaccination?.setEndDate(endDate: slutdatum)
            }
            else {
                slutdatum = datumsFormat.date(from: nästaDosDatumTextruta.text!)!
                vaccination?.setEndDate(endDate: slutdatum)
            }
        default:
            break
        }
        if endDateWasManuallyChosen {
            if dosEtikett.isHidden {
            slutdatum = datumsFormat.date(from: slutdatumTextruta.text!)!
            vaccination?.setEndDate(endDate: slutdatum)
            }
            else {
                slutdatum = datumsFormat.date(from: nästaDosDatumTextruta.text!)!
                vaccination?.setEndDate(endDate: slutdatum)
            }
        }
        
    }
    
    //MARK: Private Methods
    
    func slutdatum(startdatum: Date) -> Date? {
        
        let openText = vaccintypTextruta.text!
        let vaccine = Vaccine(rawValue: openText)
        let protection = vaccine!.protection(amountOfDosesTaken: nil)
        
        switch protection {
        case .time:
            return vaccination?.getEndDate(amountOfDosesTaken: vaccination?.amountOfDosesTaken)
        case .lifeLong:
            slutdatumTextruta.text = "Du är skyddad för resten av livet!"
        case .unknown:
            slutdatumTextruta.text = "Skyddstiden inte bestämd ännu. Fråga din läkare och fyll i själv."
        }
        return nil
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        var textBool = vaccintypTextruta.text ?? ""
        if !textBool.isEmpty {
            textBool = startdatumTextruta.text ?? ""
        }
        sparaKnapp.isEnabled = !textBool.isEmpty
    }

}
