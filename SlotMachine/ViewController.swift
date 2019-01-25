//
//  ViewController.swift
//  SlotMachine
//
//  Created by Ivan on 2019-01-24.
//  Copyright © 2019 CentennialCollege. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    /*--- Some pre declared variables ---*/
    var playerMoney:Int = 1000
    var playerBet: Int = 10
    var winnings:Int = 0
    var component1: Int = 0
    var component2: Int = 0
    var componenet3: Int = 0
    
    
    /*--- Outlets ---*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    /*--- 3 components of reels ---*/
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    /*labels, textfield and button for UI ---*/
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var playeMoneyLbl: UITextField!
    @IBOutlet weak var playerBetTxt: UITextField!
    
    @IBOutlet weak var spinBtn: UIButton!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var quitBtn: UIButton!
    
    /*
    @IBAction func addCoins(_ sender: UIButton) {
        playeMoneyLbl.text = "100"
        playerMoney = playerMoney + 100
    }
    */
    
    /*--- to show number of component per picker ---*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    /*--- number of rows per picker ---*/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 200
    }
    
    /*--- row height of each picker ---*/
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 70.0
        
    }
    
    /*--- width of each picker ---*/
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    /*--- to generate random number ---*/
    func randomNumber() -> Int {
        let lower : UInt32 = 20
        let upper : UInt32 = 150
        let randomNumber = arc4random_uniform(upper - lower) + lower
        
        return Int(arc4random_uniform(UInt32(randomNumber)))+5
    }
    
    /*--- reels with 7 images and 200 rows for spinning ---*/
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //pickerView.transform = CGAffineTransform(rotationAngle: 300)
        /*--- view for each picker ---*/
        //let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 250, height: 60))
        
        /* image view ---*/
        //let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let myView = UIView(frame: CGRect(x:0,y:0, width:50, height:50))
        
        let myImageView = UIImageView(frame: CGRect(x:0,y:0,width:60,height:60))
        var Aztec:Int=0
        var Mask:Int=1
        var Maya:Int=2
        var Mictlan:Int=3
        var Quetza:Int=4
        var Statue:Int=5
        var Tlaloc:Int=6
        
        /* to create multiple rows of same image for spinning effect more visible */
        for _ in 6 ... 200 {
            Tlaloc=Tlaloc+7
            
            
            switch row {
                
            case Aztec:
                myImageView.image = UIImage(named:"aztec.png")
                
                
            case Mask:
                myImageView.image = UIImage(named:"mask.png")
                
            case Maya:
                myImageView.image = UIImage(named:"maya.png")
                
            case Mictlan:
                myImageView.image = UIImage(named:"mictlantecuhtli.png")
                
            case Quetza:
                myImageView.image = UIImage(named:"quetzalcoatl.png")
                
            case Statue:
                myImageView.image = UIImage(named:"statue.png")
                
            default :
                myImageView.image = UIImage(named:"tlaloc.png")
                Aztec=Aztec+7
                Mask=Mask+7
                Maya=Maya+7
                Mictlan=Mictlan+7
                Quetza=Quetza+7
                Statue=Statue+7
                
            }
        }
        
        /*--- setting image view inside picker view ---*/
        myView.addSubview(myImageView)
        
        
        return myView
    }
    
    
    
    /*--- function for spinning the reel ---*/
    @IBAction func spin(_ sender: AnyObject) {
        
        spinBtn.isHidden=false
        playerBet =  NumberFormatter().number(from: playerBetTxt.text!) as! Int
        
        
        if playerBet > playerMoney && playerMoney != 0{
            resultLabel.text = "Not enough coins"
        }
        else if (playerBet < 0) {
            resultLabel.text = "Incorrect amount"
        }
        else if playerMoney == 0
        {
            resultLabel.text="Get more spins"
            playeMoneyLbl.text="0"
            spinBtn.isHidden=true
        }else if playerBet == 0 {
            resultLabel.text="Enter a valid bet amount"
        }else if playerBet <= playerMoney
        {
            resultLabel.text=""
            picker.selectRow((randomNumber()) , inComponent: 0, animated: true)
            picker.selectRow((randomNumber()) , inComponent: 1, animated: true)
            picker.selectRow((randomNumber()) , inComponent: 2, animated: true)
            determineWinnings();
        }
        self.view.endEditing(true)
       
    }
    
    /*--- Utility function to reset the state of game ---*/
    @IBAction func reset(_ sender: AnyObject) {
        
        playeMoneyLbl.text="1000"
        playerBetTxt.text = "10"
        resultLabel.text="Press spin button"
        spinBtn.isHidden=false
        quitBtn.isHidden = false
        
        playerMoney = 1000
        playerBet = 10
        winnings = 0
        
    }
    
    /*--- Function to quit the game. ---*/
    @IBAction func quit(_ sender: AnyObject) {
        exit(0)
    }
    
    
    /*--- Utility function to show a win message and increase player money ---*/
    func showWinMessage() {
        playerMoney += winnings
        resultLabel.text = "You Won: \(winnings)"
        playeMoneyLbl.text="\(playerMoney)"
        checkJackPot()
    }
    
    /*--- Utility function to show a loss message and reduce player money ---*/
    func showLossMessage() {
        playerMoney -= playerBet
        resultLabel.text = "You Lost: \(playerBet)"
        playeMoneyLbl.text="\(playerMoney)"
    }
    
    /*--- Check to see if the player won the jackpot ---*/
    func checkJackPot() {
        var jackpot:Int = 10
        /*--- To get the image of each picker ---*/
        component1 = picker.selectedRow(inComponent: 0)
        component2 = picker.selectedRow(inComponent: 1)
        componenet3 = picker.selectedRow(inComponent: 2)
        
        if(component1>6){
            component1 = component1%7
        }
        if(component2>6){
            component2 = component2%7
        }
        if(componenet3>6){
            componenet3 = componenet3%7
        }
        
        /*--- Condition to win jackpot ---*/
        if (component1 == component2 && component2 == componenet3  ){
            if (component1 == 5 && component2 == 5 && componenet3 == 5) || (component1 == 6 && component2 == 6 && componenet3 == 6) {
                jackpot = jackpot * playerBet
                resultLabel.text = "JACKPOT: \(jackpot) COINS"
                playerMoney += jackpot
                playeMoneyLbl.text="\(playerMoney)"
            }
        }
    }
    
    /*--- Utility function to decide result of spin is win or lose ---*/
    func determineWinnings()
    {
        /*--- To get the image of each picker ---*/
        component1 = picker.selectedRow(inComponent: 0)
        component2 = picker.selectedRow(inComponent: 1)
        componenet3 = picker.selectedRow(inComponent: 2)
        
        if(component1>6){
            component1 = component1%7
        }
        if(component2>6){
            component2 = component2%7
        }
        if(componenet3>6){
            componenet3 = componenet3%7
        }
        winnings = 0
        /*--- if three images are same ---*/
        if (component1 == component2 && component2 == componenet3  ){
            if component1 == 0
            {
                print("aztec")
                winnings = playerBet * 10
            }
            else if component1 == 1 {
                print("mask")
                winnings = playerBet * 12
            }
            else if component1 == 2 {
                print("maya")
                winnings = playerBet * 14
            }
            else if component1 == 3 {
                print("mictlan")
                winnings = playerBet * 16
            }
            else if component1 == 4 {
                print("quetza")
                winnings = playerBet * 18
            }
            else if component1 == 5 {
                print("statue")
                winnings = playerBet * 20
            }
            else if component1 == 6 {
                print("tlaloc")
                winnings = playerBet * 8
            }
            showWinMessage()
            
            
        }
            /*--- if two images are same ---*/
        else if (component1 == component2 || component1 == componenet3){
            if component1 == 2 {
                print("maya")
                winnings = playerBet * 4
                showWinMessage()
                
            }
            else if component1 == 4 {
                print("quetza")
                winnings = playerBet * 4
                showWinMessage()
                
            }
            else if component1 == 5 {
                print("statue")
                winnings = playerBet * 6
                showWinMessage()
                
            }
            else {
                showLossMessage()
                
            }
        }
            /*--- if last two images are same ---*/
        else if (component2 == componenet3 ){
            if component2 == 2 {
                print("maya")
                winnings = playerBet * 4
                showWinMessage()
                
            }
            else if component2 == 4 {
                print("quetza")
                winnings = playerBet * 4
                showWinMessage()
                
            }
            else if component2 == 5 {
                print("statue")
                winnings = playerBet * 6
                showWinMessage()
                
            }
            else {
                showLossMessage()
                
            }
        }
            /*--- if no image is same ---*/
        else {
            showLossMessage()
            
        }
        
        
        
    }
    
}


