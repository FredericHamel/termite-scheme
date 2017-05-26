
(declare
  (block))

(define env '())

(define (remote-get n var)
  (!? (remote-service 'data-server n) (list 'get var)))

(define (remote-set! n var val)
  (!? (remote-service 'data-server n) (list 'set var val)))

(define (create-msg from msg)
  (lambda ()
    (println from msg)))

(define (test1 var)
  (lambda ()
    (let ((env (eval 'env)))
      (let ((pvar (assoc var env)))
        (time (pp (eval 'env)))
        (time (pp pvar))))))

