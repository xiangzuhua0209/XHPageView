//
//  ZHHomeShowViewController.swift
//  ZHFM
//
//  Created by xiangzuhua on 2021/5/11.
//

import UIKit
import XHPageView

class ZHHomeShowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
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

}

extension ZHHomeShowViewController: XHPageViewReloadable{
    func didSelectedSameTile(_ index: Int) {
        print("ZHHomeShowViewController didSelectedSameTile index: \(index)")
    }
    
    func contentViewDidEndScroll() {
        print("ZHHomeShowViewController contentViewDidEndScroll")
    }
    
    
}
