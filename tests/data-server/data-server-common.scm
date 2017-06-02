
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

;; Fetch the existance of variable.
(define (remote-lookup var)
  (lambda ()
    (let* ((nenv (eval 'env))
           (pvar (assoc var nenv)))
      (pair? pvar))))

(define (remote-apply thunk var)
  (lambda ()
    (let* ((nenv (eval 'env))
           (pvar (assoc var nenv)))
      (if (pair? pvar)
        (thunk (cdr pvar))
        (println "[ERROR] Variable " var " not found in environment")))))
