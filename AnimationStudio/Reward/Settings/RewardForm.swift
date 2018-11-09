//
//  RewardForm.swift
//  BoundlessKit_Example
//
//  Created by Akash Desai on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftForms

// should subclass this for each RewardPrimitive
class RewardForm: FormViewController {

    var reward: SampleStruct!
    var selectedRow: UITableViewCell?
    var fab: UIImageView!

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func generateForm() -> FormDescriptor {
        return FormDescriptor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fab = reward.buttonView ?? SampleStruct.presetButtonView
        view.addSubview(fab)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        tapGesture.delegate = self
        panGesture.delegate = self
        fab.isUserInteractionEnabled = true
        fab.addGestureRecognizer(tapGesture)
        fab.addGestureRecognizer(panGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubview(toFront: fab)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        reward.save()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Seguing")
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fab.transform = CGAffineTransform.init(translationX: 0, y: scrollView.contentOffset.y)
        tableView.bringSubview(toFront: fab)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell
    }
}

extension RewardForm: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func tap(_ gesture: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.commitRewardSample()
            self.reward.sample(target: self.view, sender: self.fab)
        }
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: view)
            gesture.setTranslation(.zero, in: view)
            gesture.view?.transform = gesture.view!.transform.translatedBy(x: translation.x, y: translation.y)
        }
    }
}

extension RewardForm {

    func commitRewardSample() {
        reward.setForm(form: form)
    }

    var saveSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)

        section.rows.append(RewardParamKey.RewardID.formRow(reward.settings))

        let saveRow: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: "button", type: .button, title: "Save")
            row.configuration.cell.appearance = ["backgroundColor": UIColor.from(rgb: "#007AFF") as AnyObject,
                                                 "titleLabel.textColor": UIColor.white as AnyObject
            ]
            row.configuration.button.didSelectClosure = { _ in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.commitRewardSample()
                    self.reward.save()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return row
        }()
        section.rows.append(saveRow)

        return section
    }

    var soundSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Sound", footerTitle: "For all sound options google 'SystemSoundID tuner88'")
        section.rows.append(RewardParamKey.HapticFeedback.formRow(reward.settings))
        section.rows.append(RewardParamKey.SystemSound.formRow(reward.settings))
        return section
    }

    var basicViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animation Location", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(reward.settings))
        return section
    }

    var preciseViewSection: FormSectionDescriptor {
        let section = FormSectionDescriptor(headerTitle: "Animation Location", footerTitle: nil)
        section.rows.append(RewardParamKey.ViewOption.formRow(reward.settings))
        section.rows.append(RewardParamKey.ViewMarginX.formRow(reward.settings))
        section.rows.append(RewardParamKey.ViewMarginY.formRow(reward.settings))
        return saveSection
    }
}

extension RewardForm {
    static func instantiate(for reward: RewardPrimitive) -> RewardForm? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: reward.rawValue + "Form") as? RewardForm
    }
}
