//
//  VaccineViewController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-11.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//
import os.log
import UIKit
import MaterialComponents.MaterialTextFields
import UserNotifications
class VaccineViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let center = UNUserNotificationCenter.current()

    
    //MARK: Properties
    @IBOutlet weak var dosEtikett: UILabel!
    @IBOutlet weak var slutdatumEtikett: UILabel!
    @IBOutlet weak var sparaKnapp: UIBarButtonItem!
    @IBOutlet weak var nästaDosDatumEtikett: UILabel!
    @IBOutlet weak var vaccintypTextruta: MDCTextField!
    @IBOutlet weak var startdatumTextruta: MDCTextField!
    @IBOutlet weak var slutdatumTextruta: MDCTextField!
    @IBOutlet weak var dosTextruta: MDCTextField!
    @IBOutlet weak var nästaDosDatumTextruta: MDCTextField!
    
    var vaccintypTextrutaController: MDCTextInputControllerFilled?
    var startdatumTextrutaController: MDCTextInputControllerFilled?
    var slutdatumTextrutaController: MDCTextInputControllerFilled?
    var dosTextrutaController: MDCTextInputControllerFilled?
    var nästaDosDatumTextrutaController: MDCTextInputControllerFilled?
    

    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var nextDoseDatePicker = UIDatePicker()
    var dosePicker = UIPickerView()
    let datumsFormat = DateFormatter()
    var startdatum = Date()
    var slutdatum = Date()
    var endDateWasManuallyChosen = false
    var vaccination: Vaccination?
    var comingVaccination: Vaccination?
    var valdRad: Int!
    let vacciner = Vaccine.allValues
    var presentingComingVaccination: Bool = false
    var originalStartDate = Date(timeIntervalSinceNow: 5000000000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Fixa layoute
        slutdatumTextruta.isEnabled = true
        //dosEtikett.isHidden = true
        dosTextruta.isHidden = true
        //nästaDosDatumEtikett.isHidden = true
        nästaDosDatumTextruta.isHidden = true
        sparaKnapp.title = "Lägg till"
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        
        vaccintypTextruta.font = UIFont(name: "Futura-Medium", size: 15.0)
        startdatumTextruta.font = UIFont(name: "Futura-Medium", size: 15)
        dosTextruta.font = UIFont(name: "Futura-Medium", size: 15.0)
        slutdatumTextruta.font = UIFont(name: "Futura-Medium", size: 15.0)
        nästaDosDatumTextruta.font = UIFont(name: "Futura-Medium", size: 15.0)
        
        // Skapa vaccin-pickern
        let vaccinVäljare = UIPickerView()
        
        vaccinVäljare.delegate = self
        
        vaccintypTextruta.inputView = vaccinVäljare
        
        datumsFormat.dateFormat = "dd/MM - yyyy"

        // Skapa dos-pickern
        
        dosePicker.delegate = self
        
        dosTextruta.inputView = dosePicker
        
        dosTextruta.delegate = self
        

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
        
        vaccintypTextrutaController = MDCTextInputControllerFilled(textInput: vaccintypTextruta)// Hold on as a property
        startdatumTextrutaController = MDCTextInputControllerFilled(textInput: startdatumTextruta)// Hold on as a property
        slutdatumTextrutaController = MDCTextInputControllerFilled(textInput: slutdatumTextruta)// Hold on as a property
        dosTextrutaController = MDCTextInputControllerFilled(textInput: dosTextruta)// Hold on as a property
        nästaDosDatumTextrutaController = MDCTextInputControllerFilled(textInput: nästaDosDatumTextruta)// Hold on as a property
    
        startdatumTextrutaController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        startdatumTextrutaController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        vaccintypTextrutaController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        vaccintypTextrutaController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        slutdatumTextrutaController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        slutdatumTextrutaController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        dosTextrutaController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        dosTextrutaController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        
        nästaDosDatumTextrutaController?.activeColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)
        nästaDosDatumTextrutaController?.floatingPlaceholderActiveColor = UIColor(red: 0.108, green: 0.640, blue: 0.356, alpha: 1.0)

        
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        // Set up views if editing an existing Vaccination.
        if let vaccination = vaccination  {
            if vaccination.vaccine.getTotalAmountOfDoses() == 1 {
                slutdatumTextruta.isHidden = false
                //slutdatumEtikett.isHidden = false
                navigationItem.title = vaccination.vaccine.rawValue
                vaccintypTextruta.text   = vaccination.vaccine.rawValue
                
                datumsFormat.dateFormat = "dd/MM - yyyy"
                startdatumTextruta.text = datumsFormat.string(from: vaccination.startDate)
                originalStartDate = vaccination.startDate
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

                vaccintypTextruta.isEnabled = false
                updateSaveButtonState()

                
            }
            else {
                navigationItem.title = vaccination.vaccine.rawValue
                vaccintypTextruta.text   = vaccination.vaccine.rawValue
                //slutdatumEtikett.isHidden = true
                slutdatumTextruta.isHidden = true
                //dosEtikett.isHidden = false
                dosTextruta.isHidden = false
                dosTextruta.text = String(vaccination.amountOfDosesTaken!)
                if vaccination.amountOfDosesTaken == 17 {
                    dosTextruta.text = "Booster"

                }
                nästaDosDatumTextruta.isHidden = false
                //nästaDosDatumEtikett.isHidden = false
                startdatumTextruta.text = datumsFormat.string(from: vaccination.startDate)
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
                
                vaccintypTextruta.isEnabled = false
                dosTextruta.isEnabled = false
                updateSaveButtonState()
            }
            if !presentingComingVaccination {
                sparaKnapp.title = "Spara"
            }
        }
    }
    
    deinit {
        //Stop listening to keyboard events

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
                    if dosTextruta.isHidden || !dosTextruta.isEnabled{
                        let _ = slutdatum(startdatum: startdatum)
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
        updateSaveButtonState()
        
        
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        
        view.endEditing(true)
        if valdRad != nil {
            if !vacciner[valdRad].takenOnce() {
                //slutdatumEtikett.isHidden = true
                slutdatumTextruta.isHidden = true
                
                //dosEtikett.isHidden = false
                dosTextruta.isHidden = false
            }
        }
        
        
    }
    
    @objc func keyboardWillChange (notification: Notification) {

        
      guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let keyBoard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
            return
        }
        
        
      if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification  {
            view.frame.origin.y = -38 //50
            
        }
        else {
            view.frame.origin.y = 0
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
                return ((vaccination?.vaccine.getTotalAmountOfDoses() ?? 5) + 1)
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
            if row == vaccination?.vaccine.getTotalAmountOfDoses() {
                return "Booster"
            }
            return String(row + 1)
        }
        else {
            return vacciner[row].simpleDescription()
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dosePicker {
            if row == vaccination?.vaccine.getTotalAmountOfDoses() {
                dosTextruta.text = "Booster"
                vaccination?.amountOfDosesTaken = 17
            }
            else {
                dosTextruta.text = String(row + 1)
                vaccination?.amountOfDosesTaken = row+1


            }
            nästaDosDatumTextruta.isHidden = false
            //nästaDosDatumEtikett.isHidden = false
            switch vaccination?.vaccine.protection(amountOfDosesTaken: vaccination?.amountOfDosesTaken){
            case .time(_):
                nästaDosDatumTextruta.text = datumsFormat.string(from: (vaccination?.vaccine.endDate(startDate: vaccination!.startDate, amountOfDosesTaken: row+1))!)
            case .unknown:
                nästaDosDatumTextruta.text = "Vet ej."
            case .lifeLong:
                nästaDosDatumTextruta.text = "Du är skyddad för resten av livet!"
            default:
                nästaDosDatumTextruta.text = "Jag vet inte, men du har någon bugg i din vaccine.protection metod"
            }
        }
        else {
            valdRad = row
            navigationItem.title = vacciner[row].simpleTableDescription()
            vaccintypTextruta.text = vacciner[row].simpleDescription()
            startdatumTextruta.text = nil
            slutdatumTextruta.text = nil
            
            if vacciner[row].takenOnce() {
                nästaDosDatumTextruta.isHidden = true
                //nästaDosDatumEtikett.isHidden = true
                //dosEtikett.isHidden = true
                dosTextruta.isHidden = true
                slutdatumTextruta.isHidden = false
                //slutdatumEtikett.isHidden = false
            }
            else {
                //dosEtikett.isHidden = false
                dosTextruta.isHidden = false
                
                nästaDosDatumTextruta.isHidden = false
                //nästaDosDatumEtikett.isHidden = false
                
                slutdatumTextruta.isHidden = true
                //slutdatumEtikett.isHidden = true
                
                
                nästaDosDatumTextruta.text = nil
                dosTextruta.text = nil
            }
        }
        
        
        
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sparaKnapp.isEnabled = false
        updateSaveButtonState()
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
            let isPresentingInAddMealMode = presentingViewController is VaccinationTabBarController
            
            if isPresentingInAddMealMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }
        
    
    }
    
    
    
   
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // This method lets you configure a view controller before it's presented.
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        
        var vaccinationTabBarController: VaccinationTabBarController
        
        if presentingViewController as? VaccinationTabBarController != nil{
            
            vaccinationTabBarController = presentingViewController as! VaccinationTabBarController
        }
        else {
            vaccinationTabBarController = navigationController?.tabBarController as! VaccinationTabBarController

        }
        
        /*for i in vaccinationTabBarController.comingVaccinations {
            if i.vaccine == Vaccine(rawValue: vaccintypTextruta.text!) {
                let alert = UIAlertController(title: "Kan inte spara vaccin", message: "Vaccinet du vill lägga in som taget med denna vaccinering finns redan inlagt. Gå istället till ´Mina Vaccinationer´ och klicka på den vaccinering det står att du ska ta, och klicka ´Lägg till´", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel)
                
                
                alert.addAction(alertAction)
                present(alert, animated: true)
                
                
            }
        }*/
        
        
        
            // Configure the destination view controller only when the save button is pressed.
            guard let knapp = sender as? UIBarButtonItem, knapp === sparaKnapp else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            
            let namn = vaccintypTextruta.text ?? ""
            startdatum = datumsFormat.date(from: startdatumTextruta.text!)!
            if dosTextruta.isHidden {
                // Set the meal to be passed to VaccineTableViewController after the unwind segue.
                vaccination = Vaccination(vaccine: Vaccine(rawValue: namn)!, startDate: startdatum, amountOfDosesTaken: 1)
            }
            else if !dosTextruta.isHidden {
                vaccination = Vaccination(vaccine: Vaccine(rawValue: namn)!, startDate: startdatum, amountOfDosesTaken: vaccination?.amountOfDosesTaken)
                
        }
            switch vaccination?.vaccine.protection(amountOfDosesTaken: vaccination?.amountOfDosesTaken) {
            case .time:
                if dosTextruta.isHidden {
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
                if dosTextruta.isHidden {
                    slutdatum = datumsFormat.date(from: slutdatumTextruta.text!)!
                    vaccination?.setEndDate(endDate: slutdatum)
                }
                else {
                    slutdatum = datumsFormat.date(from: nästaDosDatumTextruta.text!)!
                    vaccination?.setEndDate(endDate: slutdatum)
                }
            }
            
            if vaccination?.manualEndDate != nil && sparaKnapp.title == "Lägg till" {
                
                
                
                if vaccination!.amountOfDosesTaken! < vaccination!.vaccine.getTotalAmountOfDoses() {
                    comingVaccination = Vaccination(vaccine: vaccination!.vaccine, startDate: vaccination!.manualEndDate!, amountOfDosesTaken: (vaccination!.amountOfDosesTaken! + 1))
                    comingVaccination?.manualEndDate = comingVaccination?.getEndDate(atDate: comingVaccination!.startDate, amountOfDosesTaken: comingVaccination?.amountOfDosesTaken)
                }
                else {
                     
                        comingVaccination = Vaccination(vaccine: vaccination!.vaccine, startDate: vaccination!.manualEndDate!, amountOfDosesTaken: 17)
                    
                    /*else {
                        comingVaccination = Vaccination(vaccine: vaccination!.vaccine, startDate: vaccination!.manualEndDate!, amountOfDosesTaken: 1)

                    }*/
                }
                
            }
                
                
        if vaccination!.startDate > originalStartDate {
            vaccinationTabBarController.vaccinationsTakenInTime.append(vaccination!)
            
        }
        else {
            vaccinationTabBarController.vaccinationsNotTakenInTime.append(vaccination!)
        }
            vaccinationTabBarController.locallyModified = true
        
    
        makeNotification(identifier: comingVaccination!.vaccine.simpleDescription() + datumsFormat.string(from: comingVaccination!.startDate), deliveryDate: comingVaccination!.startDate, vaccination: comingVaccination!)
            
    }
    
    //MARK: Private Methods
    
    func slutdatum(startdatum: Date) -> Date? {
        
        let openText = vaccintypTextruta.text!
        let vaccine = Vaccine(rawValue: openText)
        let protection = vaccine!.protection(amountOfDosesTaken: 1)
        
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
        var bool = false
        if !textBool.isEmpty {
            textBool = startdatumTextruta.text ?? ""
            if !textBool.isEmpty {
                textBool = dosTextruta.text ?? ""
                if !textBool.isEmpty || dosTextruta.isHidden {
                    textBool = slutdatumTextruta.text ?? ""
                    if !textBool.isEmpty {
                    bool = true
                    /*let vaccine = Vaccine(rawValue: vaccintypTextruta.text!)
                    let amountOfDosesTaken = Int(dosTextruta.text!) ?? 1
                    switch vaccine!.protection(amountOfDosesTaken: amountOfDosesTaken) {
                    case .unknown:
                        bool = endDateWasManuallyChosen
                        
                    default:
                        bool = true
                    }*/
                    if bool {
                        let vaccinationTabBarController: VaccinationTabBarController
                        if presentingViewController as? VaccinationTabBarController != nil{
                            vaccinationTabBarController = presentingViewController as! VaccinationTabBarController
                            
                            for i in vaccinationTabBarController.comingVaccinations {
                                if i.vaccine == Vaccine(rawValue: vaccintypTextruta.text!) {
                                    bool = false
                                }
                            }
                        }
                        else {
                            vaccinationTabBarController = (self.storyboard?.instantiateViewController(identifier: "VaccinationTabBarController"))!
                            bool = true
                        }
                        
                        
                    }
                    }
                }
            }
        }
        sparaKnapp.isEnabled = bool
        
    }
    
    
    func makeNotification(identifier: String, deliveryDate: Date, vaccination: Vaccination) {
        let content = UNMutableNotificationContent()
        
        let vaccineName = (comingVaccination!.vaccine.simpleDescription()).lowercased()
           print(vaccineName)
           content.title = "Det finns ett vaccin att ta!"
           content.subtitle = ""
        content.body = "Vaccinet mot \(String(describing: vaccineName)) kan tas nu."
           content.sound = UNNotificationSound.default
           content.threadIdentifier = "local-notifications temp"
           
           
           let date = Date(timeIntervalSinceNow: 20)
           let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        print(identifier)
           
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           center.add(request) { (error) in
               if error != nil {
                   print(error)
               }
           }
    }
    
    
    //MARK: Actions
    @IBAction func addVaccination(_ sender: UIBarButtonItem) {
        let vaccinationTabBarController = presentingViewController as! VaccinationTabBarController
        for i in vaccinationTabBarController.comingVaccinations {
            if i.vaccine == Vaccine(rawValue: vaccintypTextruta.text!) {
                let alert = UIAlertController(title: "Kan inte spara vaccin", message: "Vaccinet du vill lägga in som taget med denna vaccinering finns redan inlagt. Gå istället till ´Mina Vaccinationer´ och klicka på den vaccinering det står att du ska ta, och klicka ´Lägg till´", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel)
                
                
                alert.addAction(alertAction)
                present(alert, animated: true)
                return
                
            }
        }
        
    }
    
    
    
    
    
}
