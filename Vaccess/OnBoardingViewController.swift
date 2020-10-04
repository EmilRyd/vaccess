//
//  OnBoardingViewController.swift
//  Vaccess
//
//  Created by emil on 2020-09-19.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    
    let pageHeadings = ["Håll ordning", "Håll koll", "Statistik", "Information", "Sätt igång!"]
    
    let pageSubHeadings = ["Lägg in tagna vaccinationer och få förslag på kommande vaccinationer", "Slå på notiser och bli påmind om kommande vaccinationer", "Tracka din historik och få information om hur många vaccin du tagit, hur mycket av vaccinationsprogrammet du klarat av o.s.v.", "Läs på om vacciner och ditt skydd med information hämtad direkt från Folkhälsomyndigheten.", ""]
    
    let pageImages = ["undraw_add_post_64nu", "undraw_new_notifications_fhvw", "undraw_analytics_5pgy", "undraw_online_information_4ui6", "undraw_happy_announcement_ac67" ]
    let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
    let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
    let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)

    let backgroundColors = [UIColor(red: 115/255, green: 201/255, blue: 47/255, alpha: 1),
                         UIColor(red: 4/255, green: 71/255, blue: 182/255, alpha: 1),
                           UIColor(red: 229/255, green: 1/255, blue: 81/255, alpha: 1),
                            UIColor(red: 250/255, green: 101/255, blue: 29/255, alpha: 1)]
    //let backgroundColors: [UIColor] = [Theme.primaryLight, Theme.primary, Theme.primaryDark, Theme.secondary, Theme.secondaryDark]
    
    @IBOutlet weak var getStartButton: UIButton!
    //MARK: PaperOnboardingDataSource
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let titleFont = UIFont(name: "Futura-Bold", size: 24)!
        let descriptionFont = UIFont(name: "Futura-Medium", size: 18)!
        
        
        
        return (OnboardingItemInfo(informationImage: UIImage(named: pageImages[index])!, title: pageHeadings[index], description: pageSubHeadings[index], pageIcon: UIImage(), color: backgroundColors[index], titleColor: .white, descriptionColor: .white, titleFont: titleFont, descriptionFont: descriptionFont))
        
        return [OnboardingItemInfo(informationImage: UIImage(named: "onboardingPic1")!, title: "Håll ordning!", description: "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", pageIcon: UIImage(), color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "undraw_new_notifications_fhvw")!, title: "Håll ordning på dina vaccin!", description: "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", pageIcon: UIImage(), color: backgroundColorTwo, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "undraw_new_notifications_fhvw")!, title: "Håll ordning på dina vaccin!", description: "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", pageIcon: UIImage(), color: backgroundColorThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "undraw_new_notifications_fhvw")!, title: "Håll ordning på dina vaccin!", description: "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", pageIcon: UIImage(), color: backgroundColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "undraw_new_notifications_fhvw")!, title: "Håll ordning på dina vaccin!", description: "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", pageIcon: UIImage(), color: backgroundColorThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)][index]
        
        //return [("undraw_new_notifications_fhvw", "Håll ordning på dina vaccin!", "Yeet yett yeet yeet yyeeetye yiheureyteadfgsdflnb", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descriptionFont)][index]
    }
    func onboardingItemsCount() -> Int {
        return 5
    }
    
    //MARK: PaperOnboardingDelegate
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        switch index {
        case 0, 1, 2, 3:
            if self.getStartButton.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.getStartButton.alpha = 0
                }
            }
        default:
            break
        }
       
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        switch index {
        case 0, 1, 2, 3:
            if self.getStartButton.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.getStartButton.alpha = 0
                }
            }
        case 4:
            UIView.animate(withDuration: 0.4) {
                self.getStartButton.alpha = 1
            }
        default:
            break
        }
        
    }
    

    @IBOutlet weak var onbaordingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onbaordingView.dataSource = self
        onbaordingView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func getStarted(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasWatchedWalkthrough")
        self.dismiss(animated: true, completion: nil)
    }
}
