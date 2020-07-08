//
//  ViewController.swift
//  CaluculatorApp
//
//  Created by kenji on 2020/07/07.
//  Copyright © 2020 momo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var calucuratorCollectionView: UICollectionView!
  
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calucuratorHightConstraint: NSLayoutConstraint!
    var firstNumber = ""
    var secondNumber = ""
    enum CalucurateStatus{
          case none,plus,minus,mul,div
      }
    var calucurateStatus : CalucurateStatus = .none
    let numbers = [
        ["C","%","$","÷"],
        ["7","8","9","×"],
         ["4","5","6","-"],
         ["1","2","3","+"],
         ["0",".","="]]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = ((collectionView.frame.width-10) - 12*5) / 4
        let height = width
        if indexPath.section == 4 && indexPath.row == 0{
            width = width * 2 + 12 * 2
            
        }
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calucuratorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CaluculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach{ (element) in
            if "0"..."9" ~= element || element.description == "."{
                cell.numberLabel.backgroundColor = .darkGray
            }
            else if element == "C" || element == "%" || element == "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        
        }
        return cell
        
    }
    
    func clear(){
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calucurateStatus = .none
    }
    func calucurateContinue(){
        firstNumber = numberLabel.text ?? ""
        secondNumber = ""
        calucurateStatus = .none
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
       
        if calucurateStatus == .none{
            switch number {
                case "0"..."9":
                    if firstNumber.hasPrefix("0"){ firstNumber = ""}
                    firstNumber += number
                    numberLabel.text = firstNumber
                case ".":
                    
                    if firstNumber.count != 0 && firstNumber.range(of:".") == nil{
                        firstNumber += number
                        numberLabel.text  = firstNumber
                    }
            
                case "+":
                    
                    calucurateStatus = .plus
                case "-":
                    
                    calucurateStatus = .minus
                case "×":
                    
                    calucurateStatus = .mul
                case "÷":
                    
                    calucurateStatus = .div
                case "C":
                    clear()
                default:
                    break
                }
        }
        else {
            switch number {
                case "0"..."9":
                    if secondNumber.hasPrefix("0"){ secondNumber = ""}
                    secondNumber += number
                    numberLabel.text = secondNumber
                case ".":
                   if secondNumber.count != 0 && secondNumber.range(of:".") == nil{
                       secondNumber += number
                       numberLabel.text  = secondNumber
                   }
                
                case "=":
                    
                    let firstNum = Double(firstNumber) ?? 0
                    let secondNum = Double(secondNumber) ?? 0
                    
                    
                    switch calucurateStatus {
                    
                    case .plus:
                        numberLabel.text = String(firstNum + secondNum)
                    case .minus:
                        numberLabel.text = String(firstNum - secondNum)
                    case .mul:
                        numberLabel.text = String(firstNum * secondNum)
                    case .div:
                        numberLabel.text = String(firstNum / secondNum)
                    default:
                        break
                    }
                
                    print(firstNumber,calucurateStatus, secondNumber,"=",numberLabel.text)
                    calucurateContinue()
                
               case "C":
                    clear()
               default:
                   break
               }
        }
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calucuratorCollectionView.delegate = self
        calucuratorCollectionView.dataSource = self
        calucuratorCollectionView.register(CaluculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        calucuratorHightConstraint.constant = view.frame.width * 1.4
        calucuratorCollectionView.backgroundColor = .clear
        calucuratorCollectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        view.backgroundColor = .black
        
        
    }


}

class CaluculatorViewCell : UICollectionViewCell{
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                self.numberLabel.alpha = 0.7
            }
            else{
                self.numberLabel.alpha = 1
            }
        }
    }
    let numberLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 32)
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame:CGRect){
        super.init(frame:frame)
        addSubview(numberLabel)
    
        numberLabel.frame.size = self.frame.size
        numberLabel.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
