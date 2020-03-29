
//
//  SearchOptionsViewController.swift
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

protocol SearchOptionsViewControllerDelegate: NSObjectProtocol {
    func searchOptionsViewControllerDidSelectedItem(_ rowSelected: Int, forOption option: String?)
}

class SearchOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: SearchOptionsViewControllerDelegate?
    var arrayItems = [Any]()
    var searchOption = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!

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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeDetail))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
        let view = UIView(frame: CGRect.zero)
        tableView.tableFooterView = view
        tableView.bounces = false
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier)
        }
        let item = arrayItems[indexPath.row] as? String
        cell?.textLabel?.text = "\(item ?? "")"
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    NSString *item = self.arrayItems[indexPath.row];
        closeDetail()
        delegate?.searchOptionsViewControllerDidSelectedItem(indexPath.row, forOption: searchOption)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didMove(toParentViewController: parent)
    }

    @objc func closeDetail() {
        dismissFromParentViewController()
    }
}
