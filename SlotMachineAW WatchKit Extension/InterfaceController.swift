//
//  InterfaceController.swift
//  SlotMachineAW WatchKit Extension
//
//  Created by Bruce Milyko on 4/12/15.
//  Copyright (c) 2015 Bruce Milyko. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var spinButton: WKInterfaceButton!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    
    @IBOutlet weak var slotLeft1: WKInterfaceImage!
    @IBOutlet weak var slotLeft2: WKInterfaceImage!
    @IBOutlet weak var slotLeft3: WKInterfaceImage!
    @IBOutlet weak var slotLeft4: WKInterfaceImage!
    
    @IBOutlet weak var slotCenter1: WKInterfaceImage!
    @IBOutlet weak var slotCenter2: WKInterfaceImage!
    @IBOutlet weak var slotCenter3: WKInterfaceImage!
    @IBOutlet weak var slotCenter4: WKInterfaceImage!
    
    @IBOutlet weak var slotRight1: WKInterfaceImage!
    @IBOutlet weak var slotRight2: WKInterfaceImage!
    @IBOutlet weak var slotRight3: WKInterfaceImage!
    @IBOutlet weak var slotRight4: WKInterfaceImage!
    
    var timer : NSTimer!
    var isSpinning = false
    var gamePlayedCount = 0
    var score = 100
    
    var leftNumberOfSpins = 0, centerNumberOfSpins = 0, rightNumberOfSpins = 0
    
    var leftSpinCount = 0, centerSpinCount = 0, rightSpinCount = 0
    
    var maxSpinCount = 70
    var minSpinCount = 55
    
    var leftItem = 19
    var centerItem = 7
    var rightItem = 13
    
    var namesOfItems = ["slot-A-up", "slot-A-down", "slot-bonus-up", "slot-bonus-down", "slot-gem-up", "slot-gem-down", "slot-J-up", "slot-J-down", "slot-K-up", "slot-K-down", "slot-L-up", "slot-L-down", "slot-Q-up", "slot-Q-down", "slot-star-up", "slot-star-down", "slot-wild-up", "slot-wild-down", "slot-7-up", "slot-7-down"]
    var valuesOfItemsX3 = [3, 3, 50, 50, 10, 10, 70, 70, 100, 100, 25, 25, 80, 80, 500, 500, 200, 200, 1000, 1000]
    var valuesOfItemsX2 = [2, 2, 25, 25, 5, 5, 35, 35, 50, 50, 12, 12, 40, 40, 250, 250, 100, 100, 300, 300]
    var winTextForItemsX3 = ["3 pots", "3 pots", "3 bonuses", "3 bonuses", "3 diamonds", "3 diamonds", "3 jacks", "3 jacks", "3 kings", "3 kings", "3 helmets", "3 helmets", "3 queens", "3 queens", "3 stars", "3 stars", "3 wilds", "3 wilds", "3 sevens", "3 sevens"]
    var winTextForItemsX2 = ["2 pots", "2 pots", "2 bonuses", "2 bonuses", "2 diamonds", "2 diamonds", "2 jacks", "2 jacks", "2 kings", "2 kings", "2 helmets", "2 helmets", "2 queens", "2 queens", "2 stars", "2 stars", "2 wilds", "2 wilds", "2 sevens", "2 sevens"]
    
    var blinkDuration = 1.8
    var winTimer: NSTimer!
    var blinkIsOn = false

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func spinButtonPressed() {
        if isSpinning {
            return
        }
        isSpinning = true
        prepareNextSpin()
        gamePlayedCount += 1
        score -= 1
        scoreLabel.setText("\(score)")
        self.spinButton.setTitle("Good Luck")
        self.spinButton.setBackgroundColor(UIColor.redColor())
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.22, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func prepareNextSpin() {
        var variation = maxSpinCount - minSpinCount
        var rndNum1 = Int(arc4random_uniform(UInt32(variation)))
        leftNumberOfSpins = (minSpinCount + rndNum1) * 2
        
        var rndNum2 = Int(arc4random_uniform(UInt32(variation)))
        centerNumberOfSpins = (minSpinCount + rndNum2) * 2
        
        var rndNum3 = Int(arc4random_uniform(UInt32(variation)))
        rightNumberOfSpins = (minSpinCount + rndNum3) * 2
        
        leftSpinCount = 0; centerSpinCount = 0; rightSpinCount = 0
    }
    
    func update() {
        if !isSpinning {
            return
        }
        
        leftSpinCount += 1
        centerSpinCount += 1
        rightSpinCount += 1
        
        if leftSpinCount <= leftNumberOfSpins {
            leftItem -= 1
            if leftItem < 0 {
                leftItem = 19
            }
            rotateSlotItems(leftItem, columnIndex: 0)
        }
        
        if centerSpinCount <= centerNumberOfSpins {
            centerItem -= 1
            if centerItem < 0 {
                centerItem = 19
            }
            rotateSlotItems(centerItem, columnIndex: 1)
        }
        
        if rightSpinCount <= rightNumberOfSpins {
            rightItem -= 1
            if rightItem < 0 {
                rightItem = 19
            }
            rotateSlotItems(rightItem, columnIndex: 2)
        }
        
        if leftSpinCount >= leftNumberOfSpins && centerSpinCount >= centerNumberOfSpins && rightSpinCount >= rightNumberOfSpins {
            timer.invalidate()
            calculateScore()
        }
    }
        
        func rotateSlotItems(index : Int, columnIndex : Int) {
            var image1, image2, image3, image4: WKInterfaceImage
            
            switch columnIndex{
            case 0:
                //left column
                image1 = slotLeft1
                image2 = slotLeft2
                image3 = slotLeft3
                image4 = slotLeft4
            case 1:
                //center column
                image1 = slotCenter1
                image2 = slotCenter2
                image3 = slotCenter3
                image4 = slotCenter4
            default:
                image1 = slotRight1
                image2 = slotRight2
                image3 = slotRight3
                image4 = slotRight4
            }
            var indexRow1 = index - 2
            if indexRow1 < 0 {
                indexRow1 = 20 + indexRow1
            }
            image1.setImageNamed(namesOfItems[indexRow1])
            var indexRow2 = index - 1
            if indexRow2 < 0 {
                indexRow2 = 19
            }
            image2.setImageNamed(namesOfItems[indexRow2])
            image3.setImageNamed(namesOfItems[index])
            var indexRow4 = index + 1
            if indexRow4 > 19 {
                indexRow4 = 0
            }
            image4.setImageNamed(namesOfItems[indexRow4])
        }
        
        func calculateScore() {
            var points = 0
            if leftItem == centerItem && centerItem == rightItem {
                // three of a kind
                points = valuesOfItemsX3[leftItem]
                var winText = winTextForItemsX3[leftItem]
                updateForWin(points, winText: winText)
            } else if leftItem == centerItem || leftItem == rightItem {
                points = valuesOfItemsX2[leftItem]
                var winText = winTextForItemsX2[leftItem]
                updateForWin(points, winText: winText)
            } else if centerItem == rightItem {
                points = valuesOfItemsX2[centerItem]
                var winText = winTextForItemsX2[centerItem]
                updateForWin(points, winText: winText)
            }
            
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getReadyForNextSpin"), userInfo: nil, repeats: false)
        }
    
    func updateForWin(points: Int, winText: String) {
        score = score + points
        scoreLabel.setText("\(score)")
        spinButton.setTitle("\(winText) - \(points)")
        spinButton.setBackgroundColor(UIColor.blueColor())
        blinkDuration = 2.8
        winTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("blink"), userInfo: nil, repeats: true)
    }
    
    func getReadyForNextSpin() {
        isSpinning = false
        spinButton.setTitle("SPIN")
        spinButton.setBackgroundColor(UIColor.clearColor())
    }
    
    func blink() {
        blinkDuration -= 0.2
        if blinkDuration < 0 {
            winTimer.invalidate()
            slotLeft2.setImageNamed(namesOfItems[leftItem - 1])
            slotLeft3.setImageNamed(namesOfItems[leftItem])
            slotCenter2.setImageNamed(namesOfItems[centerItem - 1])
            slotCenter3.setImageNamed(namesOfItems[centerItem])
            slotRight2.setImageNamed(namesOfItems[rightItem - 1])
            slotRight3.setImageNamed(namesOfItems[rightItem])
        } else {
            blinkIsOn = !blinkIsOn
            if blinkIsOn {
                slotLeft2.setImageNamed("slot-empty")
                slotLeft3.setImageNamed("slot-empty")
                slotCenter2.setImageNamed("slot-empty")
                slotCenter3.setImageNamed("slot-empty")
                slotRight2.setImageNamed("slot-empty")
                slotRight3.setImageNamed("slot-empty")
            } else {
                slotLeft2.setImageNamed(namesOfItems[leftItem - 1])
                slotLeft3.setImageNamed(namesOfItems[leftItem])
                slotCenter2.setImageNamed(namesOfItems[centerItem - 1])
                slotCenter3.setImageNamed(namesOfItems[centerItem])
                slotRight2.setImageNamed(namesOfItems[rightItem - 1])
                slotRight3.setImageNamed(namesOfItems[rightItem])
            }
        }
    }
}

