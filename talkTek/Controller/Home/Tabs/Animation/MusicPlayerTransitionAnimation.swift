//
//  MusicPlayerTransitionAnimation.swift
//
//

import Foundation
import UIKit
import ARNTransitionAnimator

final class MusicPlayerTransitionAnimation : TransitionAnimatable {
    
    fileprivate weak var rootVC: UIViewController! {
        get {
            return rootNavigationViewController.viewControllers.last!
        }
    }
    
    fileprivate weak var miniPlayerView: UIView! {
        get {
            return UIApplication.shared.keyWindow!.viewWithTag(5566)!
        }
    }

    fileprivate weak var playerViewController: PlayerViewController!
    fileprivate weak var rootNavigationViewController: UINavigationController!
    
    var completion: ((Bool) -> Void)?
    
    private var miniPlayerStartFrame: CGRect = CGRect.zero
    private var tabBarStartFrame: CGRect = CGRect.zero
    
    private var containerView: UIView?
    
    init(modalVC: PlayerViewController, rootNavigationViewController: UINavigationController) {
        self.playerViewController = modalVC
        self.rootNavigationViewController = rootNavigationViewController
    }
    
    func prepareContainer(_ transitionType: TransitionType, containerView: UIView, from fromVC: UIViewController, to toVC: UIViewController) {
        self.containerView = containerView
        if transitionType.isPresenting {
            rootVC.view.insertSubview(playerViewController.view, belowSubview: rootVC.tabBarController!.tabBar)
        } else {
            rootVC.view.insertSubview(playerViewController.view, belowSubview: rootVC.tabBarController!.tabBar)
        }
        rootVC.view.setNeedsLayout()
        rootVC.view.layoutIfNeeded()
        playerViewController.view.setNeedsLayout()
        playerViewController.view.layoutIfNeeded()
        miniPlayerStartFrame = miniPlayerView.frame
        tabBarStartFrame = rootVC.tabBarController!.tabBar.frame
    }
    
    func willAnimation(_ transitionType: TransitionType, containerView: UIView) {
        if transitionType.isPresenting {
            rootVC.beginAppearanceTransition(true, animated: false)
            playerViewController.view.frame.origin.y = miniPlayerView.frame.origin.y + miniPlayerView.frame.size.height
        } else {
            rootVC.beginAppearanceTransition(false, animated: false)
            miniPlayerView.alpha = 1.0
            miniPlayerView.frame.origin.y = -miniPlayerView.bounds.size.height
            rootVC.tabBarController!.tabBar.frame.origin.y = containerView.bounds.size.height
        }
    }
    
    func updateAnimation(_ transitionType: TransitionType, percentComplete: CGFloat) {
        if transitionType.isPresenting {
            let startOriginY = miniPlayerStartFrame.origin.y
            let endOriginY = -miniPlayerStartFrame.size.height
            let diff = -endOriginY + startOriginY
            let tabStartOriginY = tabBarStartFrame.origin.y
            let tabEndOriginY = playerViewController.view.frame.size.height
            let tabDiff = tabEndOriginY - tabStartOriginY
            let playerY = startOriginY - (diff * percentComplete)
            miniPlayerView.frame.origin.y = max(min(playerY,  miniPlayerStartFrame.origin.y), endOriginY)
            playerViewController.view.frame.origin.y = miniPlayerView.frame.origin.y + miniPlayerView.frame.size.height
            let tabY = tabStartOriginY + (tabDiff * percentComplete)
            rootVC.tabBarController!.tabBar.frame.origin.y = min(max(tabY, tabBarStartFrame.origin.y), tabEndOriginY)
            let alpha = 1.0 - (1.0 * percentComplete)
            rootVC.tabBarController!.tabBar.alpha = alpha
        } else {
            let window = UIApplication.shared.keyWindow!
            miniPlayerView.frame.origin.y = window.frame.height - 100
            playerViewController.view.frame.origin.y = miniPlayerView.frame.origin.y + miniPlayerView.frame.size.height
            rootVC.tabBarController!.tabBar.frame.origin.y = miniPlayerView.frame.origin.y + 50
            let alpha = 1.0 * percentComplete
            rootVC.tabBarController!.tabBar.alpha = alpha
            miniPlayerView.alpha = 1.0
        }
    }
    
    func finishAnimation(_ transitionType: TransitionType, didComplete: Bool) {
        rootVC.endAppearanceTransition()
        if transitionType.isPresenting {
            if didComplete {
                miniPlayerView.alpha = 0.0
                playerViewController.view.removeFromSuperview()
                containerView?.addSubview(playerViewController.view)
                
                completion?(transitionType.isPresenting)
            } else {
                rootVC.beginAppearanceTransition(true, animated: false)
                rootVC.endAppearanceTransition()
            }
        } else {
            if didComplete {
                playerViewController.view.removeFromSuperview()
                completion?(transitionType.isPresenting)
            } else {
                miniPlayerView.alpha = 0.0
                playerViewController.view.removeFromSuperview()
                containerView?.addSubview(playerViewController.view)
                rootVC.beginAppearanceTransition(false, animated: false)
                rootVC.endAppearanceTransition()
            }
        }
    }
}

extension MusicPlayerTransitionAnimation {
    
    func sourceVC() -> UIViewController { return rootVC }
    
    func destVC() -> UIViewController { return playerViewController }
}


