
(define server (make-node "localhost" 3001))
(define client (make-node "localhost" 3002))

(define (remote-get n var)
  (!? (remote-service 'data-server n) (list 'get var)))

(define (remote-set! n var val)
  (!? (remote-service 'data-server n) (list 'set var val)))

(define (id x) x)

(define (range start end)
  (let loop ((cur end) (lst '()))
    (if (< start cur)
      (let ((val (- cur 1)))
        (loop val (cons val lst)))
      lst)))

(define (clone lst)
  (map (lambda (x)
         (if (list? x)
           (clone x)
           x)) lst))

(define-macro (closure f . var)
  `((lambda ,var
      ,f) ,@var))

(define lst (range 0 32))

(define my_lst
  (let ((lst (range 0 32)))
    (map (lambda (x) (clone lst)) lst)))

(define big_lst
  (map (lambda (x) (clone my_lst)) my_lst))

(node-init client)

