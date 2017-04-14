
(define-type proxy
  id: 1d0a2e32-ab57-4544-8c3f-2cf4af25f289
  upid)

(define (remote-car proxy #!optional (timeout 5) (default 'no-reply))
  (if (proxy? proxy)
      (!? (proxy-upid proxy) 'car timeout default)
      (with-exception-handler
       ##primordial-exception-handler
       (lambda ()
         (car proxy)))))

(define (remote-cdr proxy #!optional (timeout 5) (default 'no-reply))
  (if (proxy? proxy)
    (!? (proxy-upid proxy) 'cdr timeout default)
    (with-exception-handler
      ##primordial-exception-handler
      (lambda ()
        (cdr proxy)))))

(let ()
  (define real-car car)
  (define real-cdr cdr)

  (current-exception-handler
   (lambda (exn)
     (if (type-exception? exn)
         (let ((proc (type-exception-procedure exn)))
           (cond ((eq? proc real-car)
                  (remote-car (car (type-exception-arguments exn))))
                 ((eq? proc real-cdr)
                  (remote-cdr (car (type-exception-arguments exn))))
                 (else
                  (##primordial-exception-handler exn))))
         (##primordial-exception-handler exn)))))
