
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

;; Print on the server side if the variable is set.
(define (remote-lookup k var)
  (lambda ()
    (let* ((nenv (eval 'env))
           (pvar (assoc var nenv)))
        (k (pair? pvar)))))
