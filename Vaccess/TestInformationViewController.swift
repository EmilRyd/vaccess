//
//  TestInformationViewController.swift
//  Vaccess
//
//  Created by emil on 2020-09-30.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import Instructions

class TestInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    
    
    //MARK: CoachMarksControllerDataSource
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = walkthroughTitles[index]
     coachViews.bodyView.background.innerColor = Theme.primary
     coachViews.arrowView?.background.innerColor = Theme.primary
        coachViews.bodyView.hintLabel.font = UIFont(name: "Futura-medium", size: 15)
        coachViews.bodyView.hintLabel.textColor = .white
        coachViews.bodyView.separator.isHidden = true
        coachViews.bodyView.nextLabel.isHidden = true

        if index == walkthroughTitles.count - 1 {
            coachViews.bodyView.nextLabel.text = ""

        }
        else {
            coachViews.bodyView.nextLabel.text = ""

        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        
        return coachMarksController.helper.makeCoachMark(for: pointsOfInterest[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return pointsOfInterest.count
    }
    
    //MARK: Variables and Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tutorialButton: UIButton!
    
    
    
    var datumsFormat = DateFormatter() {
           didSet {
               datumsFormat.dateFormat = "dd/MM - yyyy"
           }
       }
    var pointsOfInterest = [UIView(), UIView(), UIView(), UIView()]
    let coachMarksController = CoachMarksController()
    var walkthroughTitles = ["Här ser du alla vacciner du kan ta. Varje ruta representerar ett specifikt vaccin.", "Längst ner i varje ruta kan du se ditt skydd mot vederbörande sjukdom. Det finns tre stadier: Inget, partiellt och fullt.", "Här kan du söka och filtrera för att få fram just den information du vill ha.", "Om du klickar på en ruta får du upp information om sjukdomen och dess vaccin."]
    let searchController = UISearchController(searchResultsController: nil)
           var currentVaccineArray = [String]()
           let allContinents = ["Alla", "Fullt", "Partiellt", "Inget"]
           let allScopeTitles = ["Alla", "Fullt", "Partiellt", "Inget"]
       var allVaccines: [String] = []
       var allVaccinesAsProtectedVaccines: [ProtectionVaccine] = []
           var array = [String]()
           var filteredProtectionVaccines: [ProtectionVaccine] = []
           var isSearchBarEmpty: Bool {
               return searchController.searchBar.text?.isEmpty ?? true
           }
           var isFiltering: Bool {
               let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
               return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
               //return searchController.isActive && !isSearchBarEmpty
           }
           
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
         if filteredProtectionVaccines.count == 0 {
             
             tutorialButton.isHidden = true
             
         }
         else {
             tutorialButton.isHidden = false
         }
            return filteredProtectionVaccines.count
        }
        else {
            return allVaccines.count
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestInformationCollectionViewCell", for: indexPath) as? TestInformationCollectionViewCell else {
            fatalError("Expected cell to be a CountrycollectionViewCell but got something else.")
        }
        if isFiltering {
            
            
            
            cell.vaccineLabel.text = filteredProtectionVaccines[indexPath.row].name
            cell.protectionLabel.text = filteredProtectionVaccines[indexPath.row].totalProtection.rawValue
            
            
        }
        else {
            
            
            
            cell.vaccineLabel.text = allVaccines[indexPath.row]
            cell.protectionLabel.text = allVaccinesAsProtectedVaccines[indexPath.row].totalProtection.rawValue

        }
        
        
            //cell.vaccineLabel.font = UIFont(name: "Futura-Medium", size: 12.0)
        
        if indexPath.row == 3 {
            //cell.vaccineLabel.text = "HIB"
        }
     
        if indexPath.row == 0 {
            
            /*var walkthroughTitles = ["Här ser du alla vacciner du kan ta.", "Varje ruta representerar ett specifikt vaccin.", "Till höger i varje ruta kan du se ditt skydd mot vederbörande sjukdom. Det finns tre stadier: Inget, partiellt och fullt.", "Här kan du också filtrera för att få fram just den information du vill ha.", "Om du klickar på en ruta får du upp information om sjukdomen och dess vaccin."]*/
            
            
            pointsOfInterest[0] = cell.vaccineLabel
            pointsOfInterest[1] = cell.protectionLabel
            pointsOfInterest[2] = searchController.searchBar
            pointsOfInterest[3] = cell.cardView
            
            
        }
        
        
        setCorrectBackgroundColor(for: cell)
        
            
        
        switch cell.vaccineLabel.text {
        case "Meningokocker", "Pneumokocker", "Tuberkulos", "Stelkramp", "Tyfoidfeber", "Vattkoppor":
            cell.vaccineLabel.numberOfLines = 1
        default:
            cell.vaccineLabel.numberOfLines = 2
        }

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TestInformationCollectionViewCell
        cell.cardView.backgroundColor = Theme.secondaryLight
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TestInformationCollectionViewCell
        setCorrectBackgroundColor(for: cell)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TestInformationCollectionViewCell
        cell.cardView.backgroundColor = Theme.secondaryLight
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TestInformationCollectionViewCell
        setCorrectBackgroundColor(for: cell)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
     collectionView.delegate = self
     collectionView.dataSource = self
         
     searchController.searchBar.setValue("Avbryt", forKey: "cancelButtonText")
        searchController.searchBar.isHidden = false
        searchController.hidesBottomBarWhenPushed = false
    
     
     coachMarksController.dataSource = self
     pointsOfInterest[0] = collectionView
     coachMarksController.overlay.isUserInteractionEnabled = true
     datumsFormat.dateFormat = "dd/MM - yyyy"
     let height: CGFloat = 56
     //Fix font layout
     tutorialButton.backgroundColor = Theme.secondaryLight
     tutorialButton.layer.cornerRadius = tutorialButton.frame.height / 2
     tutorialButton.layer.shadowOpacity = 0.25
     tutorialButton.layer.shadowRadius = 5
     tutorialButton.layer.shadowOffset = CGSize(width: 0, height: 10)
     tutorialButton.imageView?.tintColor = .white
     
     
     tutorialButton.frame = CGRect(x: 24, y: UIScreen.main.bounds.height - 24 - height - (self.tabBarController?.tabBar.frame.height ?? 49), width: height, height: height)
     
     
        self.modalPresentationStyle = .fullScreen

        
        for i in Vaccine.allValues {
            allVaccines.append(i.simpleTableDescription())
            
        }
        
        var vacc: String? = nil
        var index = 0
        for i in allVaccines {
            if i == vacc ?? "" {
                allVaccines.remove(at: index-1)
            }
            vacc = i
            index += 1
        }
            collectionView.reloadData()
        allVaccines.sort()
      
        currentVaccineArray = allVaccines
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sök efter vaccin"
        navigationItem.searchController = searchController
        
        searchController.searchBar.scopeButtonTitles = ProtectionVaccine.TotalProtection.allCases
        .map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        
        definesPresentationContext = true
        
        
        
        
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 21)!]
        
        
        self.navigationController!.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Information"
        longTitleLabel.font = UIFont(name: "Futura-Medium", size: 30)
        longTitleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        for i in Vaccine.allValues {
            
            let protVacc = ProtectionVaccine(name: i.simpleTableDescription(), protection: "Inget")
            let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
            if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 2 {
                protVacc.totalProtection = .Fullt
            }
            else if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 1 {
                protVacc.totalProtection = .Partiellt
            }
            
            allVaccinesAsProtectedVaccines.append(protVacc)

        }
        
        var protVacc: ProtectionVaccine? = nil
        var index2 = 0
        for i in allVaccinesAsProtectedVaccines {
            if i.name == protVacc?.name ?? "" {
                allVaccinesAsProtectedVaccines.remove(at: index2 - 1)
            }
            protVacc = i
            index2 += 1
        }
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPaths = collectionView.indexPathsForSelectedItems else {
            return
        }
        if indexPaths.count != 0 {
            let indexPath = indexPaths[0]
            guard let cell = collectionView.cellForItem(at: indexPath)
             else {
                return
            }
            cell.isSelected = false
        }
            
        
        
    }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           allVaccinesAsProtectedVaccines = []
           for i in Vaccine.allValues {
               
               let protVacc = ProtectionVaccine(name: i.simpleTableDescription(), protection: "Inget")
               let vaccinationTabBarController = self.tabBarController as! VaccinationTabBarController
               if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 2 {
                   protVacc.totalProtection = .Fullt
               }
               else if vaccinationTabBarController.coverageForThisVaccine(vaccine: i) == 1 {
                   protVacc.totalProtection = .Partiellt
               }
               
               allVaccinesAsProtectedVaccines.append(protVacc)

           }
        
        var protVacc: ProtectionVaccine? = nil
        var index2 = 0
        for i in allVaccinesAsProtectedVaccines {
            if i.name == protVacc?.name ?? "" {
                allVaccinesAsProtectedVaccines.remove(at: index2 - 1)
            }
            protVacc = i
            index2 += 1
        }
        collectionView.reloadData()
        
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let indexPath = collectionView.indexPathsForSelectedItems![0]
        //let destinationViewController = segue.destination as! ViewController
        //destinationViewController.font = UIFont(name: array[indexPath!.row], size: 17.0)
        var vaccine: String
        if isFiltering {
            vaccine = filteredProtectionVaccines[indexPath.row].name
        }
        else {
            vaccine = allVaccines[indexPath.row]

        }
        
        vaccine = vaccine.lowercased()
        
        let NC = segue.destination as! UINavigationController
        let VC = NC.viewControllers[0] as! VaccineInformationViewController
        
        VC.currentVaccine = makeStringURLCompatible(string: vaccine)
        
        segue.destination.modalPresentationStyle = .fullScreen
        
        

     
     
        
        
    }
    
    func filterContentForSearchText(_ searchText: String, category: ProtectionVaccine.TotalProtection? = nil) {
            filteredProtectionVaccines = allVaccinesAsProtectedVaccines.filter { (protectionVaccine: ProtectionVaccine) -> Bool in
                let doesCategoryMatch = category == .Alla || protectionVaccine.totalProtection == category
                
                if isSearchBarEmpty {
                    return doesCategoryMatch
                }
                else {
                    return doesCategoryMatch && protectionVaccine.name.lowercased().contains(searchText.lowercased())
                }
        }
        var vacc: ProtectionVaccine? = nil
        var index = 0
        for i in filteredProtectionVaccines {
            if i.name == vacc?.name {
                filteredProtectionVaccines.remove(at: index-1)
            }
            vacc = i
            index += 1
        }
            collectionView.reloadData()
        
        
        }
    
    
    func makeStringURLCompatible(string: String) -> String {
        let newString = string.lowercased()
        if newString.localizedStandardContains("meningokocker") {
            return "meningokocker"
        }
        if newString == "tbe" {
            return "tick-borne-encefalitis-tbe"
        }
        if newString == "hib" {
            return "haemophilus-influenzae-typ-b-hib"
        }
        if newString == "tuberkulos" {
            return "tuberkulos-tb"
        }
        if newString == "hpv" {
            return "humant-papillomvirus-hpv"
        }
        var array = Array(newString)
        var iter = 0
        while iter < array.count {
            switch array[iter] {
            case "å", "ä":
                array[iter] = "a"
            case "ö":
                array[iter] = "o"
            case " ":
                array[iter] = "-"
            case "(", ")":
                array.remove(at: iter)
            default:
                break
            }
            iter += 1
        }
        
        return String(array)
    }
    
    private func setCorrectBackgroundColor(for cell: TestInformationCollectionViewCell) {
        switch cell.protectionLabel.text! {
        case "Inget":
            cell.cardView.backgroundColor = Theme.secondaryLight.withAlphaComponent(0.2)
        case "Partiellt":
            cell.cardView.backgroundColor = Theme.primaryLight.withAlphaComponent(0.7)
        case "Fullt":
            cell.cardView.backgroundColor = Theme.primary
        default:
            break

        }
    }
    
 @IBAction func startWalkthrough(_ sender: UIButton) {
     //Walkthrough
    
    
    let cell = self.collectionView.cellForItem(at: self.collectionView.indexPathsForVisibleItems[0]) as! TestInformationCollectionViewCell
    pointsOfInterest[0] = cell.vaccineLabel
    pointsOfInterest[1] = cell.protectionLabel
    pointsOfInterest[2] = searchController.searchBar
    pointsOfInterest[3] = cell.cardView
     
     self.coachMarksController.start(in: .window(over: self))
 }
    
    @IBAction func unwindToInformationViewController(sender: UIStoryboardSegue) {
        let indexPaths = collectionView.indexPathsForSelectedItems!
        for i in indexPaths {
            collectionView.deselectItem(at: i, animated: true)
            let cell = collectionView.cellForItem(at: i) as! TestInformationCollectionViewCell
            setCorrectBackgroundColor(for: cell)
        }
        searchController.hidesBottomBarWhenPushed = false
        
    }
    

    

}


extension TestInformationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let continent = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: continent)
    }
}

extension TestInformationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        let category = ProtectionVaccine.TotalProtection(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}
