
(load "data-server-common")

(define server (make-node "localhost" 3001))
(define client (make-node "localhost" 3003))

(node-init client)

