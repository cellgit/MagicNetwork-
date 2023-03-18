//
//  ViewController.swift
//  MagicNetwork
//
//  Created by liuhongli on 03/18/2023.
//  Copyright (c) 2023 liuhongli. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 44/2
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.addTarget(self, action: #selector(senderAction(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 30, width: 100, height: 60)
    }
    
    @objc func senderAction(sender: UIButton) {
        requestChat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    
    func requestChat() {
        let model = "gpt-3.5-turbo"
        let messages = [["role": "user", "content": "上一个问题,为什么最后还要恢复成双链"]]//illumina 测序文库前处理为啥要变性后还要复性,详细叙述一下原因
        let api = ChatApi.chat(model: model, messages: messages)
        ChatProvider.rx.request(api)
            .mapModel(type: ChatModel.self)
            .subscribe(onSuccess: { [weak self] model in
                guard let `self` = self else {return}
                
                let content = model?.choices?.first?.message?.content ?? ""
                
                debugPrint("content ======= \(content)")
                
            }, onFailure: { error in
                debugPrint("error ========= \(error)")
            }).disposed(by: disposeBag)
    }
    
}
