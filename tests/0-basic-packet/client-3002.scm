(load "common")

(define server (make-node "localhost" 3001))
(define client (make-node "*" 3002)) 

(node-init client)
(remote-spawn server
    (make-message "Message from client"))
        
