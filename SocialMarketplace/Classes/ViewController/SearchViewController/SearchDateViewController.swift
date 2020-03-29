
//
//  SearchDateViewController.swift
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.

import UIKit

protocol SearchDateViewControllerDelegate: NSObjectProtocol {
    func searchDateViewControllerDidSelectedDate(_ item: Date?)
}

class SearchDateViewController: UIViewController {
    weak var delegate: SearchDateViewControllerDelegate?
    var dateSelected: Date?

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSet: UIButton!
    func present(inParentViewController parentViewController: UIViewController?) {
        view.frame = (parentViewController?.view.bounds)!
        parentViewController?.view.addSubview(view)
        parentViewController?.addChildViewController(self)
    }

    func dismissFromParentViewController() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSet.setTitle("se_btn_set".localized, for: .normal)
        btnCancel.setTitle("se_btn_cancel".localized, for: .normal)
        
        if dateSelected != nil {
            if let aSelected = dateSelected {
                datePicker.date = aSelected
            }
        } else {
            datePicker.date = Date()
            dateSelected = datePicker.date
        }
    }

    @IBAction func dateChanged(_ picker: UIDatePicker) {
        dateSelected = picker.date
    }

    @IBAction func actionCancel(_ sender: Any) {
        // [self.delegate searchDateViewControllerDidSelectedDate:self.dateSelected];
        closeDetail()
    }

    @IBAction func actionSet(_ sender: Any) {
        delegate?.searchDateViewControllerDidSelectedDate(dateSelected)
        closeDetail()
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didMove(toParentViewController: parent)
    }

    func closeDetail() {
        dismissFromParentViewController()
    }
}
