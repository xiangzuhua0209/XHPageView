//
//  ZHHomeRecommendVC.swift
//  ZHFM
//
//  Created by xiangzuhua on 2021/5/11.
//

import UIKit
import XHPageView

class ZHHomeRecommendVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
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

extension ZHHomeRecommendVC: XHPageViewReloadable{
    func didSelectedSameTile(_ index: Int) {
        print("ZHHomeRecommendVC didSelectedSameTile index: \(index)")
    }
    
    func contentViewDidEndScroll() {
        print("ZHHomeRecommendVC contentViewDidEndScroll")
    }
}
