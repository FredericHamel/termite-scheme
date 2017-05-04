
(define server (make-node "localhost" 3001))
(define client (make-node "localhost" 3003))

(define (remote-get n var)
  (!? (remote-service 'data-server n) (list 'get var) 5 'no-reply))

(define (remote-set! n var val)
  (!? (remote-service 'data-server n) (list 'set var val) 5 'no-reply))

(node-init client)

