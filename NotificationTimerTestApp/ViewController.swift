//
//  ViewController.swift
//  NotificationTimerTestApp
//
//  Created by 住田雅隆 on 2022/04/24.
//

import UIKit
import os

class ViewController: UIViewController {
    var datePicker: UIDatePicker = UIDatePicker()
    var textField = UITextField()
    
    
    @IBAction func datePicker(_ sender: Any) {
        
        let ac = UIAlertController(title: "時間の設定", message: "設定した時間にチェックが付いていないと通知します!!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "セット", style: .destructive) { (action) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H時間m分後"
            let date = dateFormatter.date(from: self.textField.text!)
            
            os_log("setlocalNotfication")
           
           // notification's payload の設定
           let content = UNMutableNotificationContent()
           content.title = "チェックが付いていないタスク"
           content.subtitle = "タスクは完了しましたか？"
           content.body = ""
           content.sound = UNNotificationSound.default
           
           // １回だけ
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
           let request = UNNotificationRequest(identifier: "Time Interval",
                                                         content: content,
                                                         trigger: trigger)
            // 通知の登録
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            print(self.textField.text!)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            print("キャンセルされました")
        }
        ac.addTextField { (textField) in
            // 決定バーの生成
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
            let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
            toolbar.setItems([spacelItem, doneItem], animated: true)
            textField.inputView = self.datePicker
            textField.inputAccessoryView = toolbar
            self.textField = textField
            
            // ピッカー設定
            self.datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
            self.datePicker.timeZone = NSTimeZone.local
            self.datePicker.locale = Locale.current
            
            
            
        }
        ac.addAction(cancel)
        ac.addAction(ok)
        self.present(ac, animated: true, completion: nil)
        print("編集します")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        
        // 通知の使用許可をリクエスト
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    }
    // 決定ボタン押下
    @objc func done() {
        textField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "H時間m分後"
        let time = formatter.string(from: datePicker.date)
        
        textField.text = time
    }
    
}
